#pragma once

#include <cstdint>
#include <string>
#include <vector>

#include "core/pos_manager.h"
#include "core/ticket.h"

namespace viewtouch {

/// Result of a print job attempt.
struct PrintResult {
    bool success = false;
    int job_id = 0;
    std::string error;
};

/// Queries CUPS for the current state of a print job.
struct PrintJobStatus {
    int job_id = 0;
    std::string state;    // "QUEUED", "PRINTING", "COMPLETE", "ERROR"
    std::string message;  // Human-readable detail (e.g. "paper-out")
};

/// Describes a CUPS printer discovered on the system.
struct PrinterInfo {
    std::string name;
    std::string description;
    std::string uri;
    bool is_default = false;
};

/// Handles all receipt printing via the CUPS API + ESC/POS raw commands.
/// Designed for 80mm thermal printers (Epson TM-T88, Star TSP, etc.).
class CupsPrinter {
   public:
    /// @param printer_name  CUPS queue name.  Empty string = use default.
    /// @param store_name    Header line printed at the top of each receipt.
    explicit CupsPrinter(std::string printer_name = "",
                         std::string store_name = "El Mirador Express");

    void set_store_name(const std::string& name);

    /// Enumerate all CUPS printers available on the system.
    static std::vector<PrinterInfo> list_printers();

    /// Build an ESC/POS byte buffer for the given ticket and send it to CUPS.
    PrintResult print_receipt(const Ticket& ticket, const std::string& customer_name = "",
                              const std::string& comment = "");

    /// Build a kitchen-friendly ticket and send to the specified printer.
    PrintResult print_kitchen(const Ticket& ticket, const std::string& printer_name,
                              const std::string& customer_name = "",
                              const std::string& comment = "");

    /// Print a Z-report / daily summary to the receipt printer.
    PrintResult print_report(const std::string& report_text, const std::string& printer_name = "");

    /// Print a nicely ESC/POS-formatted report (bold headers, columns, sections).
    /// For range reports, pass the per-day breakdown in daily_breakdown.
    PrintResult print_formatted_report(const DailyReport& report, const std::string& title,
                                       const std::string& date_range = "",
                                       const std::vector<DailyReport>& daily_breakdown = {},
                                       const std::string& printer_name = "");

    /// Query CUPS for the status of a previously submitted job.
    PrintJobStatus query_job(int job_id);

   private:
    /// Build the raw ESC/POS byte sequence for a receipt (paid modifiers only).
    std::vector<uint8_t> build_receipt_payload(const Ticket& ticket,
                                               const std::string& customer_name = "",
                                               const std::string& comment = "") const;

    /// Build a kitchen-friendly ESC/POS ticket (items + all modifiers, no totals).
    std::vector<uint8_t> build_kitchen_payload(const Ticket& ticket,
                                               const std::string& customer_name = "",
                                               const std::string& comment = "") const;

    /// Build an ESC/POS-formatted report payload (bold headers, sections, columns).
    std::vector<uint8_t> build_report_payload(
        const DailyReport& report, const std::string& title, const std::string& date_range,
        const std::vector<DailyReport>& daily_breakdown) const;

    /// Send a raw byte buffer to a specific CUPS printer queue.
    PrintResult send_raw(const std::vector<uint8_t>& data, const std::string& target_printer = "");

    /// Resolve the effective printer name (default if empty).
    std::string resolve_printer() const;

    std::string printer_name_;
    std::string store_name_;
};

}  // namespace viewtouch
