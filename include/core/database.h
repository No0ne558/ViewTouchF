#pragma once

#include "core/menu_item.h"
#include "core/pos_manager.h"
#include "core/ticket.h"

#include <sqlite3.h>

#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace viewtouch {

/// RAII wrapper around sqlite3* with schema init and typed helpers.
class Database {
public:
    /// Open (or create) the database at @p path.  Tables are created
    /// automatically on first run.
    explicit Database(const std::string& path);
    ~Database();

    Database(const Database&) = delete;
    Database& operator=(const Database&) = delete;

    // ── Menu persistence ─────────────────────────────────────
    void save_menu(const std::vector<MenuItem>& items);
    std::vector<MenuItem> load_menu();

    // ── Ticket persistence ───────────────────────────────────
    void save_ticket(const Ticket& t);
    void delete_ticket(const std::string& ticket_id);
    std::vector<Ticket> load_all_tickets();

    // ── Phone‑order persistence ──────────────────────────────
    void save_phone_order(const PhoneOrder& po);
    void delete_phone_order(const std::string& po_id);
    std::vector<PhoneOrder> load_all_phone_orders();

    // ── Archived reports ─────────────────────────────────────
    void save_report(const DailyReport& rpt);
    std::vector<DailyReport> load_all_reports();

    // ── Sequence counters ────────────────────────────────────
    uint64_t load_seq(const std::string& name);
    void     save_seq(const std::string& name, uint64_t val);

    // ── Settings (key/value) ─────────────────────────────────
    std::string load_setting(const std::string& key,
                             const std::string& default_val = "") const;
    void        save_setting(const std::string& key, const std::string& val);

private:
    void create_tables();
    void exec(const char* sql);
    sqlite3* db_ = nullptr;
};

}  // namespace viewtouch
