#include "printing/cups_printer.h"

#include <cups/cups.h>
#include <cups/ipp.h>

#include <algorithm>
#include <cstring>
#include <ctime>
#include <iomanip>
#include <sstream>
#include <stdexcept>

namespace viewtouch {

// ── ESC/POS command constants ────────────────────────────────
namespace escpos {
    // Reset printer
    constexpr uint8_t INIT[]          = {0x1B, 0x40};
    // Select justification: 0=left, 1=center, 2=right
    constexpr uint8_t ALIGN_CENTER[]  = {0x1B, 0x61, 0x01};
    constexpr uint8_t ALIGN_LEFT[]    = {0x1B, 0x61, 0x00};
    constexpr uint8_t ALIGN_RIGHT[]   = {0x1B, 0x61, 0x02};
    // Double-height + double-width ON / OFF
    constexpr uint8_t DOUBLE_ON[]     = {0x1D, 0x21, 0x11};
    constexpr uint8_t DOUBLE_OFF[]    = {0x1D, 0x21, 0x00};
    // Bold ON / OFF
    constexpr uint8_t BOLD_ON[]       = {0x1B, 0x45, 0x01};
    constexpr uint8_t BOLD_OFF[]      = {0x1B, 0x45, 0x00};
    // Feed + full cut
    constexpr uint8_t FEED_CUT[]      = {0x1D, 0x56, 0x41, 0x03};
    // Line feed
    constexpr uint8_t LF[]            = {0x0A};
}  // namespace escpos

// ── Helpers ──────────────────────────────────────────────────
namespace {

void append(std::vector<uint8_t>& buf, const uint8_t* data, size_t len) {
    buf.insert(buf.end(), data, data + len);
}

template <size_t N>
void append(std::vector<uint8_t>& buf, const uint8_t (&arr)[N]) {
    buf.insert(buf.end(), arr, arr + N);
}

void append_text(std::vector<uint8_t>& buf, const std::string& text) {
    buf.insert(buf.end(), text.begin(), text.end());
}

/// Format cents as "$12.34"
std::string fmt_money(int32_t cents) {
    bool negative = cents < 0;
    if (negative) cents = -cents;
    std::ostringstream os;
    if (negative) os << '-';
    os << '$' << (cents / 100) << '.' << std::setw(2) << std::setfill('0') << (cents % 100);
    return os.str();
}

/// Pad or truncate a string to exactly `width` characters.
std::string pad_right(const std::string& s, size_t width) {
    if (s.size() >= width) return s.substr(0, width);
    return s + std::string(width - s.size(), ' ');
}
std::string pad_left(const std::string& s, size_t width) {
    if (s.size() >= width) return s.substr(0, width);
    return std::string(width - s.size(), ' ') + s;
}

}  // namespace

// ── CupsPrinter implementation ───────────────────────────────

CupsPrinter::CupsPrinter(std::string printer_name, std::string store_name)
    : printer_name_(std::move(printer_name)),
      store_name_(std::move(store_name)) {}

void CupsPrinter::set_store_name(const std::string& name) {
    store_name_ = name;
}

std::string CupsPrinter::resolve_printer() const {
    if (!printer_name_.empty()) {
        return printer_name_;
    }
    // Ask CUPS for the system default printer.
    const char* def = cupsGetDefault();
    if (def) return std::string(def);
    return {};
}

// ── Build ESC/POS receipt payload ────────────────────────────

std::vector<uint8_t> CupsPrinter::build_receipt_payload(const Ticket& ticket,
                                                         const std::string& customer_name,
                                                         const std::string& comment) const {
    constexpr int LINE_WIDTH = 42;  // 42 columns for 80mm paper, standard

    std::vector<uint8_t> buf;
    buf.reserve(2048);

    // 1. Initialize printer
    append(buf, escpos::INIT);

    // 2. Store header (centered, double-size)
    append(buf, escpos::ALIGN_CENTER);
    append(buf, escpos::DOUBLE_ON);
    append_text(buf, store_name_);
    append(buf, escpos::LF);
    append(buf, escpos::DOUBLE_OFF);
    append_text(buf, std::string(LINE_WIDTH, '-'));
    append(buf, escpos::LF);

    // 2b. Customer info (for phone orders)
    if (!customer_name.empty()) {
        append(buf, escpos::ALIGN_LEFT);
        append(buf, escpos::BOLD_ON);
        append_text(buf, "Customer: " + customer_name);
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
    }
    if (!comment.empty()) {
        append(buf, escpos::ALIGN_LEFT);
        append_text(buf, "Note: " + comment);
        append(buf, escpos::LF);
    }
    if (!customer_name.empty() || !comment.empty()) {
        append_text(buf, std::string(LINE_WIDTH, '-'));
        append(buf, escpos::LF);
    }

    // 3. Ticket info
    append(buf, escpos::ALIGN_LEFT);
    append_text(buf, "Ticket: " + ticket.id);
    append(buf, escpos::LF);
    append_text(buf, std::string(LINE_WIDTH, '-'));
    append(buf, escpos::LF);

    // 4. Column header
    append(buf, escpos::BOLD_ON);
    append_text(buf, pad_right("Item", 24) + pad_right("Qty", 6) + pad_left("Price", 12));
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_OFF);
    append_text(buf, std::string(LINE_WIDTH, '-'));
    append(buf, escpos::LF);

    // 5. Line items
    for (const auto& ti : ticket.items) {
        std::string qty_str = std::to_string(ti.quantity);
        int32_t mod_adj = 0;
        for (const auto& m : ti.modifiers) {
            mod_adj += m.price_adjustment_cents;
        }
        int32_t line_total  = (ti.item.price_cents + mod_adj) * ti.quantity;
        std::string line =
            pad_right(ti.item.name, 24) +
            pad_right(qty_str, 6) +
            pad_left(fmt_money(line_total), 12);
        append_text(buf, line);
        append(buf, escpos::LF);

        // Print modifiers indented under the item — receipt only shows paid mods
        for (const auto& m : ti.modifiers) {
            if (m.price_adjustment_cents <= 0) continue;
            std::string action_str;
            switch (m.action) {
                case ModifierAction::ADD:    action_str = "ADD "; break;
                case ModifierAction::EXTRA:  action_str = "EXTRA "; break;
                case ModifierAction::SIDE:   action_str = "ON SIDE "; break;
                case ModifierAction::DOUBLE: action_str = "DOUBLE "; break;
                default: break;
            }
            std::string mod_line = "  " + action_str + m.modifier_name;
            mod_line = pad_right(mod_line, 30) +
                       pad_left("+" + fmt_money(m.price_adjustment_cents), 12);
            append_text(buf, mod_line);
            append(buf, escpos::LF);
        }
    }

    // 6. Totals
    append_text(buf, std::string(LINE_WIDTH, '-'));
    append(buf, escpos::LF);
    append(buf, escpos::ALIGN_RIGHT);
    append_text(buf, "Subtotal: " + fmt_money(ticket.subtotal_cents));
    append(buf, escpos::LF);
    append_text(buf, "     Tax: " + fmt_money(ticket.tax_cents));
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_ON);
    append_text(buf, "   TOTAL: " + fmt_money(ticket.total_cents));
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_OFF);

    // 7. Footer
    append(buf, escpos::ALIGN_CENTER);
    append(buf, escpos::LF);
    append_text(buf, "Thank you!");
    append(buf, escpos::LF);
    append(buf, escpos::LF);

    // 8. Feed and cut
    append(buf, escpos::FEED_CUT);

    return buf;
}

// ── Send raw bytes to CUPS ───────────────────────────────────

PrintResult CupsPrinter::send_raw(const std::vector<uint8_t>& data,
                                  const std::string& target_printer) {
    PrintResult result;

    std::string printer = target_printer.empty() ? resolve_printer() : target_printer;
    if (printer.empty()) {
        result.error = "No printer found (no default CUPS printer configured)";
        return result;
    }

    // CUPS requires data to come from a file or a pipe.  We use a temporary
    // file which is the most portable approach with the CUPS C API.
    //
    // cupsPrintFile sends the job and returns a job-id (>0 on success).
    // We write raw bytes to a temp file, tell CUPS the MIME type is
    // application/octet-stream so it passes bytes through unmodified.

    char tmppath[] = "/tmp/vt_receipt_XXXXXX";
    int fd = mkstemp(tmppath);
    if (fd < 0) {
        result.error = "Failed to create temp file for print job";
        return result;
    }

    ssize_t written = write(fd, data.data(), data.size());
    close(fd);

    if (written < 0 || static_cast<size_t>(written) != data.size()) {
        unlink(tmppath);
        result.error = "Failed to write receipt data to temp file";
        return result;
    }

    int job_id = cupsPrintFile(
        printer.c_str(),
        tmppath,
        "ViewTouch Receipt",       // job title shown in CUPS UI
        0,                         // num_options
        nullptr                    // options (raw mode is set via MIME type)
    );

    unlink(tmppath);  // clean up temp file

    if (job_id == 0) {
        // cupsLastErrorString() gives a human-readable CUPS error.
        result.error = std::string("CUPS error: ") + cupsLastErrorString();
        return result;
    }

    result.success = true;
    result.job_id  = job_id;
    return result;
}

PrintResult CupsPrinter::print_receipt(const Ticket& ticket,
                                        const std::string& customer_name,
                                        const std::string& comment) {
    auto payload = build_receipt_payload(ticket, customer_name, comment);
    return send_raw(payload);
}

PrintResult CupsPrinter::print_kitchen(const Ticket& ticket,
                                        const std::string& printer_name,
                                        const std::string& customer_name,
                                        const std::string& comment) {
    auto payload = build_kitchen_payload(ticket, customer_name, comment);
    return send_raw(payload, printer_name);
}

PrintResult CupsPrinter::print_report(const std::string& report_text,
                                       const std::string& printer_name) {
    std::vector<uint8_t> buf;
    buf.reserve(report_text.size() + 64);
    append(buf, escpos::INIT);
    append_text(buf, report_text);
    append(buf, escpos::LF);
    append(buf, escpos::FEED_CUT);
    return send_raw(buf, printer_name);
}

PrintResult CupsPrinter::print_formatted_report(const DailyReport& report,
                                                  const std::string& title,
                                                  const std::string& date_range,
                                                  const std::vector<DailyReport>& daily_breakdown,
                                                  const std::string& printer_name) {
    auto payload = build_report_payload(report, title, date_range, daily_breakdown);
    return send_raw(payload, printer_name);
}

std::vector<uint8_t> CupsPrinter::build_report_payload(
        const DailyReport& rpt,
        const std::string& title,
        const std::string& date_range,
        const std::vector<DailyReport>& daily_breakdown) const {
    constexpr int W = 42;  // 42-column 80mm thermal paper

    std::vector<uint8_t> buf;
    buf.reserve(4096);

    append(buf, escpos::INIT);

    // ── Store name header ──
    append(buf, escpos::ALIGN_CENTER);
    append(buf, escpos::DOUBLE_ON);
    append_text(buf, store_name_);
    append(buf, escpos::LF);
    append(buf, escpos::DOUBLE_OFF);
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);

    // ── Report title ──
    append(buf, escpos::DOUBLE_ON);
    append(buf, escpos::BOLD_ON);
    append_text(buf, title);
    append(buf, escpos::LF);
    append(buf, escpos::DOUBLE_OFF);
    append(buf, escpos::BOLD_OFF);

    // Date or date range
    if (!date_range.empty()) {
        append_text(buf, date_range);
    } else {
        append_text(buf, rpt.date);
    }
    append(buf, escpos::LF);
    append_text(buf, std::string(W, '='));
    append(buf, escpos::LF);

    // ── Sales Summary ──
    append(buf, escpos::ALIGN_LEFT);
    append(buf, escpos::BOLD_ON);
    append_text(buf, "SALES SUMMARY");
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_OFF);
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);

    auto row = [&](const std::string& label, const std::string& value) {
        append_text(buf, pad_right(label, W - 12) + pad_left(value, 12));
        append(buf, escpos::LF);
    };

    row("Total Tickets", std::to_string(rpt.total_tickets));
    row("Gross Revenue", fmt_money(rpt.total_revenue_cents));
    row("Tax Collected", fmt_money(rpt.total_tax_cents));
    append(buf, escpos::BOLD_ON);
    row("Net Revenue", fmt_money(rpt.net_revenue_cents));
    append(buf, escpos::BOLD_OFF);

    // ── Payment Breakdown ──
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_ON);
    append_text(buf, "PAYMENTS");
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_OFF);
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);

    {
        std::string cash_label = "Cash:  " + std::to_string(rpt.cash_count) + " txns";
        row(cash_label, fmt_money(rpt.cash_total_cents));
        std::string card_label = "Card:  " + std::to_string(rpt.card_count) + " txns";
        row(card_label, fmt_money(rpt.card_total_cents));
    }

    // ── Adjustments ──
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_ON);
    append_text(buf, "ADJUSTMENTS");
    append(buf, escpos::LF);
    append(buf, escpos::BOLD_OFF);
    append_text(buf, std::string(W, '-'));
    append(buf, escpos::LF);

    row("Voided", std::to_string(rpt.voided_count));
    {
        std::string comp_label = "Comped:  " + std::to_string(rpt.comped_count);
        row(comp_label, fmt_money(rpt.comped_total_cents));
        std::string ref_label = "Refunds:  " + std::to_string(rpt.refunded_count);
        row(ref_label, fmt_money(rpt.refunded_total_cents));
    }

    // ── Item Sales ──
    if (!rpt.item_sales.empty()) {
        append_text(buf, std::string(W, '-'));
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_ON);
        append_text(buf, "ITEM SALES");
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
        append_text(buf, std::string(W, '-'));
        append(buf, escpos::LF);

        // Column header
        append(buf, escpos::BOLD_ON);
        append_text(buf, pad_right("Item", 22) + pad_left("Qty", 8) + pad_left("Revenue", 12));
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
        append_text(buf, std::string(W, '-'));
        append(buf, escpos::LF);

        for (const auto& e : rpt.item_sales) {
            append_text(buf, pad_right(e.item_name, 22)
                           + pad_left(std::to_string(e.quantity_sold), 8)
                           + pad_left(fmt_money(e.revenue_cents), 12));
            append(buf, escpos::LF);
        }
    }

    // ── Daily Breakdown (for range reports) ──
    if (!daily_breakdown.empty()) {
        append_text(buf, std::string(W, '='));
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_ON);
        append_text(buf, "DAILY BREAKDOWN");
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
        append_text(buf, std::string(W, '-'));
        append(buf, escpos::LF);

        // Column header
        append(buf, escpos::BOLD_ON);
        append_text(buf, pad_right("Date", 14) + pad_left("Tickets", 8) + pad_left("Net Rev", 20));
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
        append_text(buf, std::string(W, '-'));
        append(buf, escpos::LF);

        for (const auto& d : daily_breakdown) {
            append_text(buf, pad_right(d.date, 14)
                           + pad_left(std::to_string(d.total_tickets), 8)
                           + pad_left(fmt_money(d.net_revenue_cents), 20));
            append(buf, escpos::LF);
        }
    }

    // ── Footer ──
    append_text(buf, std::string(W, '='));
    append(buf, escpos::LF);

    // Print timestamp
    {
        auto now = std::time(nullptr);
        auto* tm = std::localtime(&now);
        std::ostringstream ts;
        ts << "Printed: "
           << (tm->tm_year + 1900) << '-'
           << std::setw(2) << std::setfill('0') << (tm->tm_mon + 1) << '-'
           << std::setw(2) << std::setfill('0') << tm->tm_mday << ' '
           << std::setw(2) << std::setfill('0') << tm->tm_hour << ':'
           << std::setw(2) << std::setfill('0') << tm->tm_min;
        append(buf, escpos::ALIGN_CENTER);
        append_text(buf, ts.str());
        append(buf, escpos::LF);
    }

    append(buf, escpos::LF);
    append(buf, escpos::FEED_CUT);
    return buf;
}

// ── Enumerate CUPS printers ──────────────────────────────────

std::vector<PrinterInfo> CupsPrinter::list_printers() {
    std::vector<PrinterInfo> result;
    cups_dest_t* dests = nullptr;
    int num = cupsGetDests(&dests);
    for (int i = 0; i < num; ++i) {
        PrinterInfo info;
        info.name = dests[i].name;
        info.is_default = (dests[i].is_default != 0);
        const char* desc = cupsGetOption("printer-info", dests[i].num_options, dests[i].options);
        if (desc) info.description = desc;
        const char* uri = cupsGetOption("device-uri", dests[i].num_options, dests[i].options);
        if (uri) info.uri = uri;
        result.push_back(std::move(info));
    }
    cupsFreeDests(num, dests);
    return result;
}

// ── Build kitchen ticket payload ─────────────────────────────

std::vector<uint8_t> CupsPrinter::build_kitchen_payload(const Ticket& ticket,
                                                          const std::string& customer_name,
                                                          const std::string& comment) const {
    constexpr int LINE_WIDTH = 42;

    std::vector<uint8_t> buf;
    buf.reserve(1024);

    // Initialize
    append(buf, escpos::INIT);

    // Header — large, bold
    append(buf, escpos::ALIGN_CENTER);
    append(buf, escpos::DOUBLE_ON);
    append(buf, escpos::BOLD_ON);
    append_text(buf, "** KITCHEN **");
    append(buf, escpos::LF);
    append(buf, escpos::DOUBLE_OFF);
    append(buf, escpos::BOLD_OFF);

    // Customer info (for phone orders)
    if (!customer_name.empty()) {
        append(buf, escpos::ALIGN_LEFT);
        append(buf, escpos::BOLD_ON);
        append_text(buf, "Customer: " + customer_name);
        append(buf, escpos::LF);
        append(buf, escpos::BOLD_OFF);
    }
    if (!comment.empty()) {
        append(buf, escpos::ALIGN_LEFT);
        append_text(buf, "Note: " + comment);
        append(buf, escpos::LF);
    }

    // Ticket ID
    append(buf, escpos::ALIGN_CENTER);
    append_text(buf, "Ticket: " + ticket.id);
    append(buf, escpos::LF);
    append_text(buf, std::string(LINE_WIDTH, '='));
    append(buf, escpos::LF);

    // Items — only those with send_to_kitchen
    append(buf, escpos::ALIGN_LEFT);
    for (const auto& ti : ticket.items) {
        if (!ti.item.send_to_kitchen) continue;

        // Double-size item name + quantity
        append(buf, escpos::DOUBLE_ON);
        append(buf, escpos::BOLD_ON);
        std::string item_line = std::to_string(ti.quantity) + "x " + ti.item.name;
        append_text(buf, item_line);
        append(buf, escpos::LF);
        append(buf, escpos::DOUBLE_OFF);
        append(buf, escpos::BOLD_OFF);

        // All modifiers, clearly listed
        for (const auto& m : ti.modifiers) {
            std::string action_str;
            switch (m.action) {
                case ModifierAction::NO:     action_str = "NO "; break;
                case ModifierAction::ADD:    action_str = "ADD "; break;
                case ModifierAction::EXTRA:  action_str = "EXTRA "; break;
                case ModifierAction::LIGHT:  action_str = "LIGHT "; break;
                case ModifierAction::SIDE:   action_str = "ON SIDE "; break;
                case ModifierAction::DOUBLE: action_str = "DOUBLE "; break;
                default: break;
            }
            append_text(buf, "   >> " + action_str + m.modifier_name);
            append(buf, escpos::LF);
        }
        append_text(buf, std::string(LINE_WIDTH, '-'));
        append(buf, escpos::LF);
    }

    // Feed and cut
    append(buf, escpos::LF);
    append(buf, escpos::FEED_CUT);

    return buf;
}

// ── Query job status ─────────────────────────────────────────

PrintJobStatus CupsPrinter::query_job(int job_id) {
    PrintJobStatus status;
    status.job_id = job_id;

    cups_job_t* jobs  = nullptr;
    std::string printer = resolve_printer();
    if (printer.empty()) {
        status.state   = "ERROR";
        status.message = "No printer configured";
        return status;
    }

    int num_jobs = cupsGetJobs(&jobs, printer.c_str(), /*myjobs=*/0, CUPS_WHICHJOBS_ALL);

    bool found = false;
    for (int i = 0; i < num_jobs; ++i) {
        if (jobs[i].id == job_id) {
            found = true;
            switch (jobs[i].state) {
                case IPP_JOB_PENDING:
                case IPP_JOB_HELD:
                    status.state = "QUEUED";
                    break;
                case IPP_JOB_PROCESSING:
                    status.state = "PRINTING";
                    break;
                case IPP_JOB_COMPLETED:
                    status.state = "COMPLETE";
                    break;
                case IPP_JOB_STOPPED:
                case IPP_JOB_CANCELED:
                case IPP_JOB_ABORTED:
                default:
                    status.state   = "ERROR";
                    status.message = "Job state: " + std::to_string(jobs[i].state);
                    break;
            }
            break;
        }
    }

    if (!found) {
        status.state   = "ERROR";
        status.message = "Job ID not found in CUPS queue";
    }

    cupsFreeJobs(num_jobs, jobs);
    return status;
}

}  // namespace viewtouch
