#pragma once

#include <sqlite3.h>

#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <vector>

#include "core/menu_item.h"
#include "core/pos_manager.h"
#include "core/ticket.h"

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
    // Set the persisted receipt_printed flag for a ticket (0/1).
    void set_ticket_printed(const std::string& ticket_id, bool printed);

    // ── Phone‑order persistence ──────────────────────────────
    void save_phone_order(const PhoneOrder& po);
    void delete_phone_order(const std::string& po_id);
    std::vector<PhoneOrder> load_all_phone_orders();

    // ── Archived reports ─────────────────────────────────────
    void save_report(const DailyReport& rpt);
    std::vector<DailyReport> load_all_reports();

    // ── Sequence counters ────────────────────────────────────
    uint64_t load_seq(const std::string& name);
    void save_seq(const std::string& name, uint64_t val);

    // ── Settings (key/value) ─────────────────────────────────
    std::string load_setting(const std::string& key, const std::string& default_val = "") const;
    void save_setting(const std::string& key, const std::string& val);

   private:
    void migrate();       ///< Run pending schema migrations.
    void migrate_to_1();  ///< v2.6.0 — initial 12-table schema.
    void migrate_to_2();  ///< v2.7.3 — add cc_fee_cents to tickets.
    void migrate_to_3();  ///< v2.8.0 — add report accounting fields.
    void migrate_to_4();  ///< v2.9.0 — add group_id to ticket_item_modifiers
    void migrate_to_5();  ///< v2.10.0 — add receipt_printed to tickets
    void exec(const char* sql);
    int get_user_version();
    void set_user_version(int v);
    sqlite3* db_ = nullptr;

    /// RAII transaction guard — automatically rolls back if not committed.
    class Transaction {
       public:
        explicit Transaction(Database& db) : db_(db) { db_.exec("BEGIN TRANSACTION"); }
        ~Transaction() {
            if (!committed_) try {
                    db_.exec("ROLLBACK");
                } catch (...) {
                }
        }
        void commit() {
            db_.exec("COMMIT");
            committed_ = true;
        }
        Transaction(const Transaction&) = delete;
        Transaction& operator=(const Transaction&) = delete;

       private:
        Database& db_;
        bool committed_ = false;
    };
};

}  // namespace viewtouch
