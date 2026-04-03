#include "printing/cups_printer.h"

#include <cups/cups.h>
#include <cups/ipp.h>

#include <algorithm>
#include <cstring>
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

std::vector<uint8_t> CupsPrinter::build_receipt_payload(const Ticket& ticket) const {
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

PrintResult CupsPrinter::print_receipt(const Ticket& ticket) {
    auto payload = build_receipt_payload(ticket);
    return send_raw(payload);
}

PrintResult CupsPrinter::print_kitchen(const Ticket& ticket,
                                        const std::string& printer_name) {
    auto payload = build_kitchen_payload(ticket);
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

std::vector<uint8_t> CupsPrinter::build_kitchen_payload(const Ticket& ticket) const {
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

    // Ticket ID
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
