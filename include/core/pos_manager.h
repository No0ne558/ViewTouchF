#pragma once

#include <cstdint>
#include <mutex>
#include <optional>
#include <string>
#include <unordered_map>
#include <vector>

#include "core/menu_item.h"
#include "core/ticket.h"

namespace viewtouch {

class Database;  // forward declaration

/// Lightweight aggregate for item-level sales data in reports.
struct ItemSalesEntry {
    std::string item_name;
    int32_t quantity_sold = 0;
    int32_t revenue_cents = 0;
};

/// Aggregate daily sales report.
struct DailyReport {
    std::string date;  // "YYYY-MM-DD"
    int32_t total_tickets = 0;
    int32_t total_revenue_cents = 0;
    int32_t total_tax_cents = 0;
    int32_t cash_count = 0;
    int32_t card_count = 0;
    int32_t voided_count = 0;
    int32_t comped_count = 0;
    int32_t refunded_count = 0;
    int32_t cash_total_cents = 0;
    int32_t card_total_cents = 0;
    int32_t comped_total_cents = 0;
    int32_t refunded_total_cents = 0;
    int32_t net_revenue_cents = 0;
    int32_t cc_fee_total_cents = 0;     // total CC fees collected
    int32_t total_collected_cents = 0;  // grand total actually collected (revenue + cc fees)
    int32_t subtotal_cents = 0;         // pre-tax subtotal
    std::vector<ItemSalesEntry> item_sales;
};

/// Thread-safe core POS engine.  All monetary values are in cents.
class PosManager {
   public:
    /// @param tax_rate_bps  Tax rate in basis points (825 = 8.25%).
    explicit PosManager(int32_t tax_rate_bps = 825,
                        std::string restaurant_name = "ViewTouch Restaurant");

    /// Attach a database for persistence.  Called once at startup.
    void set_database(Database* db);

    /// Restore in-memory state from an attached database.
    void load_from_database();

    // ── Settings ─────────────────────────────────────────────
    std::string get_restaurant_name() const;
    int32_t get_tax_rate_bps() const;
    void set_restaurant_name(const std::string& name);
    void set_tax_rate_bps(int32_t bps);

    // ── Printer settings ─────────────────────────────────────
    std::string get_receipt_printer_name() const;
    bool get_receipt_printer_enabled() const;
    std::string get_kitchen_printer_name() const;
    bool get_kitchen_printer_enabled() const;
    void set_receipt_printer_name(const std::string& n);
    void set_receipt_printer_enabled(bool e);
    void set_kitchen_printer_name(const std::string& n);
    void set_kitchen_printer_enabled(bool e);

    // ── Credit card fee ──────────────────────────────────────
    int32_t get_cc_fee_cents() const;
    int32_t get_cc_fee_bps() const;
    void set_cc_fee_cents(int32_t cents);
    void set_cc_fee_bps(int32_t bps);

    // ── Menu ─────────────────────────────────────────────────
    void load_menu(std::vector<MenuItem> items);
    std::vector<MenuItem> get_menu() const;
    std::optional<MenuItem> find_menu_item(const std::string& item_id) const;
    bool add_menu_item(const MenuItem& item);
    bool update_menu_item(const MenuItem& item);
    bool delete_menu_item(const std::string& item_id);

    // ── Tickets ──────────────────────────────────────────────
    Ticket new_ticket();
    std::optional<Ticket> get_ticket(const std::string& ticket_id) const;
    std::optional<Ticket> add_item(const std::string& ticket_id, const std::string& menu_item_id,
                                   int32_t quantity = 1,
                                   const std::vector<AppliedModifier>& modifiers = {},
                                   const std::string& special_instructions = "");
    /// Update an existing item's modifiers and special instructions in-place.
    std::optional<Ticket> update_item(const std::string& ticket_id, const std::string& line_key,
                                      const std::vector<AppliedModifier>& modifiers,
                                      const std::string& special_instructions = "");
    std::optional<Ticket> remove_item(const std::string& ticket_id, const std::string& menu_item_id,
                                      const std::string& line_key = "");
    /// Decrease item quantity by 1. Removes item when qty reaches 0.
    std::optional<Ticket> decrease_item(const std::string& ticket_id,
                                        const std::string& menu_item_id,
                                        const std::string& line_key = "");
    /// Finalise the ticket with split payments.
    std::optional<Ticket> checkout(const std::string& ticket_id,
                                   const std::vector<Payment>& payments, int32_t cc_fee_cents = 0);
    bool void_ticket(const std::string& ticket_id);

    // ── Ticket actions ───────────────────────────────────────
    /// Comp a closed ticket (marks as COMPED).
    std::optional<Ticket> comp_ticket(const std::string& ticket_id);
    /// Refund a closed ticket (marks as REFUNDED).
    std::optional<Ticket> refund_ticket(const std::string& ticket_id);
    /// List tickets for a date, optionally filtered by status.
    std::vector<Ticket> list_tickets(const std::string& date,
                                     const std::string& status_filter = "") const;

    /// Mark the persisted ticket as having had its receipt printed.
    /// If the ticket is present in-memory, update and persist it; otherwise update DB row directly.
    void mark_ticket_printed(const std::string& ticket_id, bool printed = true);

    // ── Reporting ────────────────────────────────────────────
    /// Generate a report for a specific date ("YYYY-MM-DD"). Empty = today.
    DailyReport get_daily_report(const std::string& date) const;
    /// Get reports for the last N days.
    std::vector<DailyReport> get_report_history(int days_back) const;
    /// Get aggregated report for a date range (inclusive).
    DailyReport get_date_range_report(const std::string& start, const std::string& end) const;

    // ── End of Day ───────────────────────────────────────────
    /// Runs end-of-day: generates Z-report, removes non-OPEN tickets.
    DailyReport end_day();

    // ── Phone Orders ─────────────────────────────────────────
    /// Create a phone order from the given ticket (moves it into hold list).
    std::optional<PhoneOrder> create_phone_order(const std::string& ticket_id,
                                                 const std::string& customer_name,
                                                 const std::string& comment);
    /// List all phone orders with HOLDING status.
    std::vector<PhoneOrder> list_phone_orders() const;
    /// Get count of HOLDING phone orders.
    int32_t phone_order_count() const;
    /// Perform an action on a phone order (CHECKOUT or CANCEL).
    /// CHECKOUT: restores ticket as OPEN and returns it; CANCEL: marks cancelled.
    std::optional<PhoneOrder> phone_order_action(const std::string& phone_order_id,
                                                 const std::string& action);

   private:
    std::string generate_ticket_id() const;
    std::string today_str() const;
    static std::string compute_line_key(const std::string& menu_item_id,
                                        const std::vector<AppliedModifier>& modifiers,
                                        const std::string& special_instructions = "");

    mutable std::mutex mu_;
    Database* db_ = nullptr;
    int32_t tax_rate_bps_;
    std::string restaurant_name_;
    std::string receipt_printer_name_;
    bool receipt_printer_enabled_ = false;
    std::string kitchen_printer_name_;
    bool kitchen_printer_enabled_ = false;
    int32_t cc_fee_cents_ = 0;
    int32_t cc_fee_bps_ = 0;
    std::vector<MenuItem> menu_;
    std::unordered_map<std::string, MenuItem> menu_index_;
    std::unordered_map<std::string, Ticket> tickets_;
    std::vector<DailyReport> archived_reports_;
    uint64_t ticket_seq_ = 0;
    std::unordered_map<std::string, PhoneOrder> phone_orders_;
    uint64_t phone_order_seq_ = 0;
};

}  // namespace viewtouch
