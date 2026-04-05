#include "core/database.h"

#include <iostream>
#include <sstream>
#include <stdexcept>

namespace viewtouch {

// ── Helpers ──────────────────────────────────────────────────

namespace {

std::string status_to_str(TicketStatus s) {
    switch (s) {
        case TicketStatus::OPEN:     return "OPEN";
        case TicketStatus::CLOSED:   return "CLOSED";
        case TicketStatus::VOIDED:   return "VOIDED";
        case TicketStatus::COMPED:   return "COMPED";
        case TicketStatus::REFUNDED: return "REFUNDED";
    }
    return "OPEN";
}

TicketStatus str_to_status(const std::string& s) {
    if (s == "CLOSED")   return TicketStatus::CLOSED;
    if (s == "VOIDED")   return TicketStatus::VOIDED;
    if (s == "COMPED")   return TicketStatus::COMPED;
    if (s == "REFUNDED") return TicketStatus::REFUNDED;
    return TicketStatus::OPEN;
}

std::string po_status_to_str(PhoneOrderStatus s) {
    switch (s) {
        case PhoneOrderStatus::HOLDING:   return "HOLDING";
        case PhoneOrderStatus::COMPLETED: return "COMPLETED";
        case PhoneOrderStatus::CANCELLED: return "CANCELLED";
    }
    return "HOLDING";
}

PhoneOrderStatus str_to_po_status(const std::string& s) {
    if (s == "COMPLETED") return PhoneOrderStatus::COMPLETED;
    if (s == "CANCELLED") return PhoneOrderStatus::CANCELLED;
    return PhoneOrderStatus::HOLDING;
}

std::string mod_action_to_str(ModifierAction a) {
    switch (a) {
        case ModifierAction::NO:     return "NO";
        case ModifierAction::ADD:    return "ADD";
        case ModifierAction::EXTRA:  return "EXTRA";
        case ModifierAction::LIGHT:  return "LIGHT";
        case ModifierAction::SIDE:   return "SIDE";
        case ModifierAction::DOUBLE: return "DOUBLE";
        default: return "NONE";
    }
}

ModifierAction str_to_mod_action(const std::string& s) {
    if (s == "NO")     return ModifierAction::NO;
    if (s == "ADD")    return ModifierAction::ADD;
    if (s == "EXTRA")  return ModifierAction::EXTRA;
    if (s == "LIGHT")  return ModifierAction::LIGHT;
    if (s == "SIDE")   return ModifierAction::SIDE;
    if (s == "DOUBLE") return ModifierAction::DOUBLE;
    return ModifierAction::NONE;
}

// Safe column text helper (handles NULL).
std::string col_text(sqlite3_stmt* stmt, int col) {
    auto p = sqlite3_column_text(stmt, col);
    return p ? reinterpret_cast<const char*>(p) : "";
}

}  // namespace

// ── Construction / destruction ───────────────────────────────

Database::Database(const std::string& path) {
    int rc = sqlite3_open(path.c_str(), &db_);
    if (rc != SQLITE_OK) {
        std::string err = sqlite3_errmsg(db_);
        sqlite3_close(db_);
        db_ = nullptr;
        throw std::runtime_error("Cannot open database: " + err);
    }
    // Enable WAL mode for better concurrent read/write.
    exec("PRAGMA journal_mode=WAL");
    exec("PRAGMA foreign_keys=ON");
    create_tables();
}

Database::~Database() {
    if (db_) sqlite3_close(db_);
}

void Database::exec(const char* sql) {
    char* err = nullptr;
    if (sqlite3_exec(db_, sql, nullptr, nullptr, &err) != SQLITE_OK) {
        std::string msg = err ? err : "unknown error";
        sqlite3_free(err);
        throw std::runtime_error("SQL exec error: " + msg);
    }
}

// ── Schema ───────────────────────────────────────────────────

void Database::create_tables() {
    exec(R"(
        CREATE TABLE IF NOT EXISTS settings (
            key   TEXT PRIMARY KEY,
            value TEXT NOT NULL
        );
        CREATE TABLE IF NOT EXISTS sequences (
            name  TEXT PRIMARY KEY,
            value INTEGER NOT NULL DEFAULT 0
        );

        -- Menu
        CREATE TABLE IF NOT EXISTS menu_items (
            id              TEXT PRIMARY KEY,
            name            TEXT NOT NULL,
            price_cents     INTEGER NOT NULL,
            category        TEXT NOT NULL DEFAULT '',
            send_to_kitchen INTEGER NOT NULL DEFAULT 1
        );
        CREATE TABLE IF NOT EXISTS modifier_groups (
            id            TEXT PRIMARY KEY,
            menu_item_id  TEXT NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
            name          TEXT NOT NULL,
            min_select    INTEGER NOT NULL DEFAULT 0,
            max_select    INTEGER NOT NULL DEFAULT 0
        );
        CREATE TABLE IF NOT EXISTS modifiers (
            id            TEXT PRIMARY KEY,
            group_id      TEXT NOT NULL REFERENCES modifier_groups(id) ON DELETE CASCADE,
            name          TEXT NOT NULL,
            price_cents   INTEGER NOT NULL DEFAULT 0,
            is_default    INTEGER NOT NULL DEFAULT 0
        );

        -- Tickets
        CREATE TABLE IF NOT EXISTS tickets (
            id                TEXT PRIMARY KEY,
            status            TEXT NOT NULL DEFAULT 'OPEN',
            payment_type      TEXT NOT NULL DEFAULT '',
            created_at_ms     INTEGER NOT NULL DEFAULT 0,
            closed_date       TEXT NOT NULL DEFAULT '',
            subtotal_cents    INTEGER NOT NULL DEFAULT 0,
            tax_cents         INTEGER NOT NULL DEFAULT 0,
            total_cents       INTEGER NOT NULL DEFAULT 0,
            amount_paid_cents INTEGER NOT NULL DEFAULT 0,
            change_due_cents  INTEGER NOT NULL DEFAULT 0
        );
        CREATE TABLE IF NOT EXISTS ticket_items (
            ticket_id            TEXT NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
            line_key             TEXT NOT NULL,
            menu_item_id         TEXT NOT NULL,
            menu_item_name       TEXT NOT NULL,
            menu_item_price      INTEGER NOT NULL,
            menu_item_category   TEXT NOT NULL DEFAULT '',
            send_to_kitchen      INTEGER NOT NULL DEFAULT 1,
            quantity             INTEGER NOT NULL DEFAULT 1,
            special_instructions TEXT NOT NULL DEFAULT '',
            PRIMARY KEY (ticket_id, line_key)
        );
        CREATE TABLE IF NOT EXISTS ticket_item_modifiers (
            ticket_id      TEXT NOT NULL,
            line_key       TEXT NOT NULL,
            modifier_id    TEXT NOT NULL,
            modifier_name  TEXT NOT NULL,
            action         TEXT NOT NULL DEFAULT 'NONE',
            price_adj      INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (ticket_id, line_key, modifier_id),
            FOREIGN KEY (ticket_id, line_key) REFERENCES ticket_items(ticket_id, line_key) ON DELETE CASCADE
        );
        CREATE TABLE IF NOT EXISTS payments (
            ticket_id    TEXT NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
            payment_type TEXT NOT NULL,
            amount_cents INTEGER NOT NULL,
            seq          INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (ticket_id, seq)
        );

        -- Phone orders
        CREATE TABLE IF NOT EXISTS phone_orders (
            id             TEXT PRIMARY KEY,
            ticket_id      TEXT NOT NULL,
            customer_name  TEXT NOT NULL DEFAULT '',
            comment        TEXT NOT NULL DEFAULT '',
            status         TEXT NOT NULL DEFAULT 'HOLDING',
            created_at_ms  INTEGER NOT NULL DEFAULT 0
        );

        -- Archived reports
        CREATE TABLE IF NOT EXISTS archived_reports (
            date                   TEXT PRIMARY KEY,
            total_tickets          INTEGER NOT NULL DEFAULT 0,
            total_revenue_cents    INTEGER NOT NULL DEFAULT 0,
            total_tax_cents        INTEGER NOT NULL DEFAULT 0,
            cash_count             INTEGER NOT NULL DEFAULT 0,
            card_count             INTEGER NOT NULL DEFAULT 0,
            voided_count           INTEGER NOT NULL DEFAULT 0,
            comped_count           INTEGER NOT NULL DEFAULT 0,
            refunded_count         INTEGER NOT NULL DEFAULT 0,
            cash_total_cents       INTEGER NOT NULL DEFAULT 0,
            card_total_cents       INTEGER NOT NULL DEFAULT 0,
            comped_total_cents     INTEGER NOT NULL DEFAULT 0,
            refunded_total_cents   INTEGER NOT NULL DEFAULT 0,
            net_revenue_cents      INTEGER NOT NULL DEFAULT 0
        );
        CREATE TABLE IF NOT EXISTS report_item_sales (
            report_date   TEXT NOT NULL REFERENCES archived_reports(date) ON DELETE CASCADE,
            item_name     TEXT NOT NULL,
            quantity_sold INTEGER NOT NULL DEFAULT 0,
            revenue_cents INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY (report_date, item_name)
        );
    )");
}

// ── Sequences ────────────────────────────────────────────────

uint64_t Database::load_seq(const std::string& name) {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_, "SELECT value FROM sequences WHERE name=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, name.c_str(), -1, SQLITE_TRANSIENT);
    uint64_t val = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        val = static_cast<uint64_t>(sqlite3_column_int64(stmt, 0));
    }
    sqlite3_finalize(stmt);
    return val;
}

void Database::save_seq(const std::string& name, uint64_t val) {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO sequences(name,value) VALUES(?,?) "
        "ON CONFLICT(name) DO UPDATE SET value=excluded.value",
        -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, name.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(stmt, 2, static_cast<int64_t>(val));
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

// ── Settings ─────────────────────────────────────────────────

std::string Database::load_setting(const std::string& key,
                                    const std::string& default_val) const {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_, "SELECT value FROM settings WHERE key=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, key.c_str(), -1, SQLITE_TRANSIENT);
    std::string result = default_val;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        result = col_text(stmt, 0);
    }
    sqlite3_finalize(stmt);
    return result;
}

void Database::save_setting(const std::string& key, const std::string& val) {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO settings(key,value) VALUES(?,?) "
        "ON CONFLICT(key) DO UPDATE SET value=excluded.value",
        -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, key.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, val.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

// ── Menu ─────────────────────────────────────────────────────

void Database::save_menu(const std::vector<MenuItem>& items) {
    exec("BEGIN TRANSACTION");
    // Clear existing menu data.
    exec("DELETE FROM modifiers");
    exec("DELETE FROM modifier_groups");
    exec("DELETE FROM menu_items");

    sqlite3_stmt* item_stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO menu_items(id,name,price_cents,category,send_to_kitchen) "
        "VALUES(?,?,?,?,?)", -1, &item_stmt, nullptr);

    sqlite3_stmt* grp_stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO modifier_groups(id,menu_item_id,name,min_select,max_select) "
        "VALUES(?,?,?,?,?)", -1, &grp_stmt, nullptr);

    sqlite3_stmt* mod_stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO modifiers(id,group_id,name,price_cents,is_default) "
        "VALUES(?,?,?,?,?)", -1, &mod_stmt, nullptr);

    for (const auto& mi : items) {
        sqlite3_reset(item_stmt);
        sqlite3_bind_text(item_stmt,  1, mi.id.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(item_stmt,  2, mi.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(item_stmt,   3, mi.price_cents);
        sqlite3_bind_text(item_stmt,  4, mi.category.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(item_stmt,   5, mi.send_to_kitchen ? 1 : 0);
        sqlite3_step(item_stmt);

        for (const auto& g : mi.modifier_groups) {
            sqlite3_reset(grp_stmt);
            sqlite3_bind_text(grp_stmt, 1, g.id.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(grp_stmt, 2, mi.id.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(grp_stmt, 3, g.name.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(grp_stmt,  4, g.min_select);
            sqlite3_bind_int(grp_stmt,  5, g.max_select);
            sqlite3_step(grp_stmt);

            for (const auto& m : g.modifiers) {
                sqlite3_reset(mod_stmt);
                sqlite3_bind_text(mod_stmt, 1, m.id.c_str(), -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(mod_stmt, 2, g.id.c_str(), -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(mod_stmt, 3, m.name.c_str(), -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(mod_stmt,  4, m.price_cents);
                sqlite3_bind_int(mod_stmt,  5, m.is_default ? 1 : 0);
                sqlite3_step(mod_stmt);
            }
        }
    }

    sqlite3_finalize(item_stmt);
    sqlite3_finalize(grp_stmt);
    sqlite3_finalize(mod_stmt);
    exec("COMMIT");
}

std::vector<MenuItem> Database::load_menu() {
    std::vector<MenuItem> items;

    // 1. Load items.
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "SELECT id,name,price_cents,category,send_to_kitchen FROM menu_items ORDER BY category,name",
        -1, &stmt, nullptr);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        MenuItem mi;
        mi.id              = col_text(stmt, 0);
        mi.name            = col_text(stmt, 1);
        mi.price_cents     = sqlite3_column_int(stmt, 2);
        mi.category        = col_text(stmt, 3);
        mi.send_to_kitchen = sqlite3_column_int(stmt, 4) != 0;
        items.push_back(std::move(mi));
    }
    sqlite3_finalize(stmt);

    // 2. Load groups per item.
    for (auto& mi : items) {
        sqlite3_prepare_v2(db_,
            "SELECT id,name,min_select,max_select FROM modifier_groups WHERE menu_item_id=?",
            -1, &stmt, nullptr);
        sqlite3_bind_text(stmt, 1, mi.id.c_str(), -1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ModifierGroup g;
            g.id         = col_text(stmt, 0);
            g.name       = col_text(stmt, 1);
            g.min_select = sqlite3_column_int(stmt, 2);
            g.max_select = sqlite3_column_int(stmt, 3);
            mi.modifier_groups.push_back(std::move(g));
        }
        sqlite3_finalize(stmt);
        stmt = nullptr;

        // 3. Load modifiers per group.
        for (auto& g : mi.modifier_groups) {
            sqlite3_prepare_v2(db_,
                "SELECT id,name,price_cents,is_default FROM modifiers WHERE group_id=?",
                -1, &stmt, nullptr);
            sqlite3_bind_text(stmt, 1, g.id.c_str(), -1, SQLITE_TRANSIENT);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                Modifier m;
                m.id          = col_text(stmt, 0);
                m.name        = col_text(stmt, 1);
                m.price_cents = sqlite3_column_int(stmt, 2);
                m.is_default  = sqlite3_column_int(stmt, 3) != 0;
                g.modifiers.push_back(std::move(m));
            }
            sqlite3_finalize(stmt);
            stmt = nullptr;
        }
    }

    return items;
}

// ── Tickets ──────────────────────────────────────────────────

void Database::save_ticket(const Ticket& t) {
    exec("BEGIN TRANSACTION");

    // Upsert ticket header.
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO tickets(id,status,payment_type,created_at_ms,closed_date,"
        "subtotal_cents,tax_cents,total_cents,amount_paid_cents,change_due_cents) "
        "VALUES(?,?,?,?,?,?,?,?,?,?) "
        "ON CONFLICT(id) DO UPDATE SET "
        "status=excluded.status, payment_type=excluded.payment_type, "
        "closed_date=excluded.closed_date, subtotal_cents=excluded.subtotal_cents, "
        "tax_cents=excluded.tax_cents, total_cents=excluded.total_cents, "
        "amount_paid_cents=excluded.amount_paid_cents, change_due_cents=excluded.change_due_cents",
        -1, &stmt, nullptr);
    sqlite3_bind_text(stmt,  1, t.id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  2, status_to_str(t.status).c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  3, t.payment_type.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(stmt, 4, t.created_at_ms);
    sqlite3_bind_text(stmt,  5, t.closed_date.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt,   6, t.subtotal_cents);
    sqlite3_bind_int(stmt,   7, t.tax_cents);
    sqlite3_bind_int(stmt,   8, t.total_cents);
    sqlite3_bind_int(stmt,   9, t.amount_paid_cents);
    sqlite3_bind_int(stmt,  10, t.change_due_cents);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    // Replace items: delete old, insert new.
    stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "DELETE FROM ticket_items WHERE ticket_id=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    sqlite3_stmt* ins_item = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO ticket_items(ticket_id,line_key,menu_item_id,menu_item_name,"
        "menu_item_price,menu_item_category,send_to_kitchen,quantity,special_instructions) "
        "VALUES(?,?,?,?,?,?,?,?,?)", -1, &ins_item, nullptr);

    sqlite3_stmt* ins_mod = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO ticket_item_modifiers(ticket_id,line_key,modifier_id,modifier_name,action,price_adj) "
        "VALUES(?,?,?,?,?,?)", -1, &ins_mod, nullptr);

    for (const auto& ti : t.items) {
        sqlite3_reset(ins_item);
        sqlite3_bind_text(ins_item, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(ins_item, 2, ti.line_key.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(ins_item, 3, ti.item.id.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(ins_item, 4, ti.item.name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(ins_item,  5, ti.item.price_cents);
        sqlite3_bind_text(ins_item, 6, ti.item.category.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(ins_item,  7, ti.item.send_to_kitchen ? 1 : 0);
        sqlite3_bind_int(ins_item,  8, ti.quantity);
        sqlite3_bind_text(ins_item, 9, ti.special_instructions.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_step(ins_item);

        for (const auto& m : ti.modifiers) {
            sqlite3_reset(ins_mod);
            sqlite3_bind_text(ins_mod, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(ins_mod, 2, ti.line_key.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(ins_mod, 3, m.modifier_id.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(ins_mod, 4, m.modifier_name.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(ins_mod, 5, mod_action_to_str(m.action).c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(ins_mod,  6, m.price_adjustment_cents);
            sqlite3_step(ins_mod);
        }
    }
    sqlite3_finalize(ins_item);
    sqlite3_finalize(ins_mod);

    // Replace payments.
    stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "DELETE FROM payments WHERE ticket_id=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    sqlite3_stmt* ins_pay = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO payments(ticket_id,payment_type,amount_cents,seq) VALUES(?,?,?,?)",
        -1, &ins_pay, nullptr);
    for (int i = 0; i < static_cast<int>(t.payments.size()); ++i) {
        sqlite3_reset(ins_pay);
        sqlite3_bind_text(ins_pay, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(ins_pay, 2, t.payments[i].payment_type.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(ins_pay,  3, t.payments[i].amount_cents);
        sqlite3_bind_int(ins_pay,  4, i);
        sqlite3_step(ins_pay);
    }
    sqlite3_finalize(ins_pay);

    exec("COMMIT");
}

void Database::delete_ticket(const std::string& ticket_id) {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_, "DELETE FROM tickets WHERE id=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, ticket_id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

std::vector<Ticket> Database::load_all_tickets() {
    std::vector<Ticket> tickets;

    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "SELECT id,status,payment_type,created_at_ms,closed_date,"
        "subtotal_cents,tax_cents,total_cents,amount_paid_cents,change_due_cents "
        "FROM tickets", -1, &stmt, nullptr);

    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Ticket t;
        t.id                = col_text(stmt, 0);
        t.status            = str_to_status(col_text(stmt, 1));
        t.payment_type      = col_text(stmt, 2);
        t.created_at_ms     = sqlite3_column_int64(stmt, 3);
        t.closed_date       = col_text(stmt, 4);
        t.subtotal_cents    = sqlite3_column_int(stmt, 5);
        t.tax_cents         = sqlite3_column_int(stmt, 6);
        t.total_cents       = sqlite3_column_int(stmt, 7);
        t.amount_paid_cents = sqlite3_column_int(stmt, 8);
        t.change_due_cents  = sqlite3_column_int(stmt, 9);
        tickets.push_back(std::move(t));
    }
    sqlite3_finalize(stmt);

    // Load items + modifiers + payments for each ticket.
    for (auto& t : tickets) {
        // Items.
        stmt = nullptr;
        sqlite3_prepare_v2(db_,
            "SELECT line_key,menu_item_id,menu_item_name,menu_item_price,"
            "menu_item_category,send_to_kitchen,quantity,special_instructions "
            "FROM ticket_items WHERE ticket_id=?",
            -1, &stmt, nullptr);
        sqlite3_bind_text(stmt, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            TicketItem ti;
            ti.line_key             = col_text(stmt, 0);
            ti.item.id              = col_text(stmt, 1);
            ti.item.name            = col_text(stmt, 2);
            ti.item.price_cents     = sqlite3_column_int(stmt, 3);
            ti.item.category        = col_text(stmt, 4);
            ti.item.send_to_kitchen = sqlite3_column_int(stmt, 5) != 0;
            ti.quantity             = sqlite3_column_int(stmt, 6);
            ti.special_instructions = col_text(stmt, 7);
            t.items.push_back(std::move(ti));
        }
        sqlite3_finalize(stmt);

        // Modifiers for each item.
        for (auto& ti : t.items) {
            stmt = nullptr;
            sqlite3_prepare_v2(db_,
                "SELECT modifier_id,modifier_name,action,price_adj "
                "FROM ticket_item_modifiers WHERE ticket_id=? AND line_key=?",
                -1, &stmt, nullptr);
            sqlite3_bind_text(stmt, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 2, ti.line_key.c_str(), -1, SQLITE_TRANSIENT);
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                AppliedModifier m;
                m.modifier_id             = col_text(stmt, 0);
                m.modifier_name           = col_text(stmt, 1);
                m.action                  = str_to_mod_action(col_text(stmt, 2));
                m.price_adjustment_cents  = sqlite3_column_int(stmt, 3);
                ti.modifiers.push_back(std::move(m));
            }
            sqlite3_finalize(stmt);
            stmt = nullptr;
        }

        // Payments.
        stmt = nullptr;
        sqlite3_prepare_v2(db_,
            "SELECT payment_type,amount_cents FROM payments WHERE ticket_id=? ORDER BY seq",
            -1, &stmt, nullptr);
        sqlite3_bind_text(stmt, 1, t.id.c_str(), -1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            Payment p;
            p.payment_type = col_text(stmt, 0);
            p.amount_cents = sqlite3_column_int(stmt, 1);
            t.payments.push_back(std::move(p));
        }
        sqlite3_finalize(stmt);
    }

    return tickets;
}

// ── Phone Orders ─────────────────────────────────────────────

void Database::save_phone_order(const PhoneOrder& po) {
    // Save the snapshot ticket first.
    save_ticket(po.ticket);

    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO phone_orders(id,ticket_id,customer_name,comment,status,created_at_ms) "
        "VALUES(?,?,?,?,?,?) "
        "ON CONFLICT(id) DO UPDATE SET "
        "status=excluded.status, customer_name=excluded.customer_name, comment=excluded.comment",
        -1, &stmt, nullptr);
    sqlite3_bind_text(stmt,  1, po.id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  2, po.ticket.id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  3, po.customer_name.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  4, po.comment.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt,  5, po_status_to_str(po.status).c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(stmt, 6, po.created_at_ms);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void Database::delete_phone_order(const std::string& po_id) {
    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_, "DELETE FROM phone_orders WHERE id=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, po_id.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

std::vector<PhoneOrder> Database::load_all_phone_orders() {
    std::vector<PhoneOrder> orders;
    auto all_tickets = load_all_tickets();

    // Build a ticket lookup.
    std::unordered_map<std::string, Ticket> tmap;
    for (auto& t : all_tickets) {
        tmap[t.id] = std::move(t);
    }

    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "SELECT id,ticket_id,customer_name,comment,status,created_at_ms FROM phone_orders",
        -1, &stmt, nullptr);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        PhoneOrder po;
        po.id            = col_text(stmt, 0);
        auto tid         = col_text(stmt, 1);
        po.customer_name = col_text(stmt, 2);
        po.comment       = col_text(stmt, 3);
        po.status        = str_to_po_status(col_text(stmt, 4));
        po.created_at_ms = sqlite3_column_int64(stmt, 5);
        if (auto it = tmap.find(tid); it != tmap.end()) {
            po.ticket = it->second;
        }
        orders.push_back(std::move(po));
    }
    sqlite3_finalize(stmt);
    return orders;
}

// ── Archived Reports ─────────────────────────────────────────

void Database::save_report(const DailyReport& rpt) {
    exec("BEGIN TRANSACTION");

    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO archived_reports(date,total_tickets,total_revenue_cents,"
        "total_tax_cents,cash_count,card_count,voided_count,comped_count,"
        "refunded_count,cash_total_cents,card_total_cents,comped_total_cents,"
        "refunded_total_cents,net_revenue_cents) "
        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
        "ON CONFLICT(date) DO UPDATE SET "
        "total_tickets=excluded.total_tickets, total_revenue_cents=excluded.total_revenue_cents, "
        "total_tax_cents=excluded.total_tax_cents, cash_count=excluded.cash_count, "
        "card_count=excluded.card_count, voided_count=excluded.voided_count, "
        "comped_count=excluded.comped_count, refunded_count=excluded.refunded_count, "
        "cash_total_cents=excluded.cash_total_cents, card_total_cents=excluded.card_total_cents, "
        "comped_total_cents=excluded.comped_total_cents, refunded_total_cents=excluded.refunded_total_cents, "
        "net_revenue_cents=excluded.net_revenue_cents",
        -1, &stmt, nullptr);
    sqlite3_bind_text(stmt,  1, rpt.date.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt,   2, rpt.total_tickets);
    sqlite3_bind_int(stmt,   3, rpt.total_revenue_cents);
    sqlite3_bind_int(stmt,   4, rpt.total_tax_cents);
    sqlite3_bind_int(stmt,   5, rpt.cash_count);
    sqlite3_bind_int(stmt,   6, rpt.card_count);
    sqlite3_bind_int(stmt,   7, rpt.voided_count);
    sqlite3_bind_int(stmt,   8, rpt.comped_count);
    sqlite3_bind_int(stmt,   9, rpt.refunded_count);
    sqlite3_bind_int(stmt,  10, rpt.cash_total_cents);
    sqlite3_bind_int(stmt,  11, rpt.card_total_cents);
    sqlite3_bind_int(stmt,  12, rpt.comped_total_cents);
    sqlite3_bind_int(stmt,  13, rpt.refunded_total_cents);
    sqlite3_bind_int(stmt,  14, rpt.net_revenue_cents);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    // Replace item sales.
    stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "DELETE FROM report_item_sales WHERE report_date=?", -1, &stmt, nullptr);
    sqlite3_bind_text(stmt, 1, rpt.date.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    sqlite3_stmt* ins = nullptr;
    sqlite3_prepare_v2(db_,
        "INSERT INTO report_item_sales(report_date,item_name,quantity_sold,revenue_cents) "
        "VALUES(?,?,?,?)", -1, &ins, nullptr);
    for (const auto& e : rpt.item_sales) {
        sqlite3_reset(ins);
        sqlite3_bind_text(ins, 1, rpt.date.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(ins, 2, e.item_name.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(ins,  3, e.quantity_sold);
        sqlite3_bind_int(ins,  4, e.revenue_cents);
        sqlite3_step(ins);
    }
    sqlite3_finalize(ins);

    exec("COMMIT");
}

std::vector<DailyReport> Database::load_all_reports() {
    std::vector<DailyReport> reports;

    sqlite3_stmt* stmt = nullptr;
    sqlite3_prepare_v2(db_,
        "SELECT date,total_tickets,total_revenue_cents,total_tax_cents,"
        "cash_count,card_count,voided_count,comped_count,refunded_count,"
        "cash_total_cents,card_total_cents,comped_total_cents,"
        "refunded_total_cents,net_revenue_cents "
        "FROM archived_reports ORDER BY date DESC", -1, &stmt, nullptr);

    while (sqlite3_step(stmt) == SQLITE_ROW) {
        DailyReport r;
        r.date                  = col_text(stmt, 0);
        r.total_tickets         = sqlite3_column_int(stmt, 1);
        r.total_revenue_cents   = sqlite3_column_int(stmt, 2);
        r.total_tax_cents       = sqlite3_column_int(stmt, 3);
        r.cash_count            = sqlite3_column_int(stmt, 4);
        r.card_count            = sqlite3_column_int(stmt, 5);
        r.voided_count          = sqlite3_column_int(stmt, 6);
        r.comped_count          = sqlite3_column_int(stmt, 7);
        r.refunded_count        = sqlite3_column_int(stmt, 8);
        r.cash_total_cents      = sqlite3_column_int(stmt, 9);
        r.card_total_cents      = sqlite3_column_int(stmt, 10);
        r.comped_total_cents    = sqlite3_column_int(stmt, 11);
        r.refunded_total_cents  = sqlite3_column_int(stmt, 12);
        r.net_revenue_cents     = sqlite3_column_int(stmt, 13);

        reports.push_back(std::move(r));
    }
    sqlite3_finalize(stmt);

    // Load item sales for each report.
    for (auto& r : reports) {
        stmt = nullptr;
        sqlite3_prepare_v2(db_,
            "SELECT item_name,quantity_sold,revenue_cents "
            "FROM report_item_sales WHERE report_date=?",
            -1, &stmt, nullptr);
        sqlite3_bind_text(stmt, 1, r.date.c_str(), -1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ItemSalesEntry e;
            e.item_name     = col_text(stmt, 0);
            e.quantity_sold = sqlite3_column_int(stmt, 1);
            e.revenue_cents = sqlite3_column_int(stmt, 2);
            r.item_sales.push_back(std::move(e));
        }
        sqlite3_finalize(stmt);
        stmt = nullptr;
    }

    return reports;
}

}  // namespace viewtouch
