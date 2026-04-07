#include "core/pos_manager.h"
#include "core/database.h"

#include <algorithm>
#include <chrono>
#include <ctime>
#include <iomanip>
#include <iostream>
#include <sstream>

namespace viewtouch {

PosManager::PosManager(int32_t tax_rate_bps, std::string restaurant_name)
    : tax_rate_bps_(tax_rate_bps),
      restaurant_name_(std::move(restaurant_name)) {}

void PosManager::set_database(Database* db) {
    std::lock_guard lock(mu_);
    db_ = db;
}

void PosManager::load_from_database() {
    if (!db_) return;
    std::lock_guard lock(mu_);

    // Restore sequences.
    ticket_seq_      = db_->load_seq("ticket");
    phone_order_seq_ = db_->load_seq("phone_order");

    // Restore menu.
    auto saved_menu = db_->load_menu();
    if (!saved_menu.empty()) {
        menu_ = std::move(saved_menu);
        menu_index_.clear();
        menu_index_.reserve(menu_.size());
        for (const auto& m : menu_) {
            menu_index_[m.id] = m;
        }
    }

    // Restore tickets.
    auto saved_tickets = db_->load_all_tickets();
    for (auto& t : saved_tickets) {
        tickets_[t.id] = std::move(t);
    }

    // Restore phone orders.
    auto saved_orders = db_->load_all_phone_orders();
    for (auto& po : saved_orders) {
        phone_orders_[po.id] = std::move(po);
    }

    // Restore archived reports.
    archived_reports_ = db_->load_all_reports();

    // Restore settings.
    auto saved_name = db_->load_setting("restaurant_name");
    if (!saved_name.empty()) restaurant_name_ = saved_name;
    auto saved_tax = db_->load_setting("tax_rate_bps");
    if (!saved_tax.empty()) tax_rate_bps_ = std::stoi(saved_tax);
    receipt_printer_name_    = db_->load_setting("receipt_printer_name");
    receipt_printer_enabled_ = db_->load_setting("receipt_printer_enabled") == "1";
    kitchen_printer_name_    = db_->load_setting("kitchen_printer_name");
    kitchen_printer_enabled_ = db_->load_setting("kitchen_printer_enabled") == "1";

    std::cout << "[vt_daemon] restored " << tickets_.size() << " tickets, "
              << phone_orders_.size() << " phone orders, "
              << archived_reports_.size() << " reports from database\n";
}

// ── Settings ─────────────────────────────────────────────────

std::string PosManager::get_restaurant_name() const {
    std::lock_guard lock(mu_);
    return restaurant_name_;
}

int32_t PosManager::get_tax_rate_bps() const {
    std::lock_guard lock(mu_);
    return tax_rate_bps_;
}

void PosManager::set_restaurant_name(const std::string& name) {
    std::lock_guard lock(mu_);
    restaurant_name_ = name;
    if (db_) db_->save_setting("restaurant_name", name);
}

void PosManager::set_tax_rate_bps(int32_t bps) {
    std::lock_guard lock(mu_);
    tax_rate_bps_ = bps;
    if (db_) db_->save_setting("tax_rate_bps", std::to_string(bps));
}

// ── Printer settings ─────────────────────────────────────────

std::string PosManager::get_receipt_printer_name() const {
    std::lock_guard lock(mu_);
    return receipt_printer_name_;
}
bool PosManager::get_receipt_printer_enabled() const {
    std::lock_guard lock(mu_);
    return receipt_printer_enabled_;
}
std::string PosManager::get_kitchen_printer_name() const {
    std::lock_guard lock(mu_);
    return kitchen_printer_name_;
}
bool PosManager::get_kitchen_printer_enabled() const {
    std::lock_guard lock(mu_);
    return kitchen_printer_enabled_;
}
void PosManager::set_receipt_printer_name(const std::string& n) {
    std::lock_guard lock(mu_);
    receipt_printer_name_ = n;
    if (db_) db_->save_setting("receipt_printer_name", n);
}
void PosManager::set_receipt_printer_enabled(bool e) {
    std::lock_guard lock(mu_);
    receipt_printer_enabled_ = e;
    if (db_) db_->save_setting("receipt_printer_enabled", e ? "1" : "0");
}
void PosManager::set_kitchen_printer_name(const std::string& n) {
    std::lock_guard lock(mu_);
    kitchen_printer_name_ = n;
    if (db_) db_->save_setting("kitchen_printer_name", n);
}
void PosManager::set_kitchen_printer_enabled(bool e) {
    std::lock_guard lock(mu_);
    kitchen_printer_enabled_ = e;
    if (db_) db_->save_setting("kitchen_printer_enabled", e ? "1" : "0");
}

// ── Menu ─────────────────────────────────────────────────────

void PosManager::load_menu(std::vector<MenuItem> items) {
    std::lock_guard lock(mu_);
    menu_ = std::move(items);
    menu_index_.clear();
    menu_index_.reserve(menu_.size());
    for (const auto& m : menu_) {
        menu_index_[m.id] = m;
    }
    if (db_) db_->save_menu(menu_);
}

std::vector<MenuItem> PosManager::get_menu() const {
    std::lock_guard lock(mu_);
    return menu_;
}

std::optional<MenuItem> PosManager::find_menu_item(const std::string& item_id) const {
    std::lock_guard lock(mu_);
    if (auto it = menu_index_.find(item_id); it != menu_index_.end()) {
        return it->second;
    }
    return std::nullopt;
}

bool PosManager::add_menu_item(const MenuItem& item) {
    std::lock_guard lock(mu_);
    if (menu_index_.count(item.id)) return false;  // duplicate
    // Save to DB first — if it throws, in-memory state is unchanged.
    auto updated = menu_;
    updated.push_back(item);
    if (db_) db_->save_menu(updated);
    menu_ = std::move(updated);
    menu_index_[item.id] = item;
    return true;
}

bool PosManager::update_menu_item(const MenuItem& item) {
    std::lock_guard lock(mu_);
    auto idx_it = menu_index_.find(item.id);
    if (idx_it == menu_index_.end()) return false;
    // Save to DB first — if it throws, in-memory state is unchanged.
    auto updated = menu_;
    for (auto& m : updated) {
        if (m.id == item.id) { m = item; break; }
    }
    if (db_) db_->save_menu(updated);
    menu_ = std::move(updated);
    idx_it->second = item;
    return true;
}

bool PosManager::delete_menu_item(const std::string& item_id) {
    std::lock_guard lock(mu_);
    if (menu_index_.find(item_id) == menu_index_.end()) return false;
    // Build updated list and save to DB first — if it throws,
    // in-memory state is unchanged.
    std::vector<MenuItem> updated;
    updated.reserve(menu_.size());
    for (const auto& m : menu_) {
        if (m.id != item_id) updated.push_back(m);
    }
    if (db_) db_->save_menu(updated);
    menu_ = std::move(updated);
    menu_index_.erase(item_id);
    return true;
}

// ── Tickets ──────────────────────────────────────────────────

std::string PosManager::compute_line_key(const std::string& menu_item_id,
                                          const std::vector<AppliedModifier>& modifiers,
                                          const std::string& special_instructions) {
    if (modifiers.empty() && special_instructions.empty()) return menu_item_id;

    std::vector<std::string> parts;
    parts.reserve(modifiers.size());
    for (const auto& m : modifiers) {
        std::string act;
        switch (m.action) {
            case ModifierAction::NO:     act = "NO"; break;
            case ModifierAction::ADD:    act = "ADD"; break;
            case ModifierAction::EXTRA:  act = "EXTRA"; break;
            case ModifierAction::LIGHT:  act = "LIGHT"; break;
            case ModifierAction::SIDE:   act = "SIDE"; break;
            case ModifierAction::DOUBLE: act = "DOUBLE"; break;
            default: act = "NONE"; break;
        }
        parts.push_back(act + ":" + m.modifier_id);
    }
    std::sort(parts.begin(), parts.end());

    std::string key = menu_item_id + "#";
    for (size_t i = 0; i < parts.size(); ++i) {
        if (i > 0) key += ",";
        key += parts[i];
    }
    if (!special_instructions.empty()) {
        key += "|SI:" + special_instructions;
    }
    return key;
}

std::string PosManager::generate_ticket_id() const {
    std::ostringstream os;
    os << "T-" << std::setw(6) << std::setfill('0') << (ticket_seq_ + 1);
    return os.str();
}

std::string PosManager::today_str() const {
    auto now = std::chrono::system_clock::now();
    auto tt  = std::chrono::system_clock::to_time_t(now);
    std::tm tm{};
    localtime_r(&tt, &tm);
    std::ostringstream os;
    os << std::put_time(&tm, "%Y-%m-%d");
    return os.str();
}

Ticket PosManager::new_ticket() {
    std::lock_guard lock(mu_);
    ++ticket_seq_;

    Ticket t;
    t.id = generate_ticket_id();
    t.status = TicketStatus::OPEN;
    t.created_at_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::system_clock::now().time_since_epoch()).count();

    tickets_[t.id] = t;
    if (db_) {
        db_->save_ticket(t);
        db_->save_seq("ticket", ticket_seq_);
    }
    return t;
}

std::optional<Ticket> PosManager::get_ticket(const std::string& ticket_id) const {
    std::lock_guard lock(mu_);
    if (auto it = tickets_.find(ticket_id); it != tickets_.end()) {
        return it->second;
    }
    return std::nullopt;
}

std::optional<Ticket> PosManager::add_item(const std::string& ticket_id,
                                            const std::string& menu_item_id,
                                            int32_t quantity,
                                            const std::vector<AppliedModifier>& modifiers,
                                            const std::string& special_instructions) {
    if (quantity <= 0) return std::nullopt;

    std::lock_guard lock(mu_);

    auto tit = tickets_.find(ticket_id);
    if (tit == tickets_.end()) return std::nullopt;
    auto& ticket = tit->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;

    auto mit = menu_index_.find(menu_item_id);
    if (mit == menu_index_.end()) return std::nullopt;

    auto lk = compute_line_key(menu_item_id, modifiers, special_instructions);

    auto existing = std::find_if(ticket.items.begin(), ticket.items.end(),
        [&](const TicketItem& ti) { return ti.line_key == lk; });

    if (existing != ticket.items.end()) {
        existing->quantity += quantity;
    } else {
        TicketItem ti;
        ti.item                 = mit->second;
        ti.quantity             = quantity;
        ti.line_key             = lk;
        ti.modifiers            = modifiers;
        ti.special_instructions = special_instructions;
        ticket.items.push_back(std::move(ti));
    }

    ticket.recalculate(tax_rate_bps_);
    if (db_) db_->save_ticket(ticket);
    return ticket;
}

std::optional<Ticket> PosManager::remove_item(const std::string& ticket_id,
                                               const std::string& menu_item_id,
                                               const std::string& line_key) {
    std::lock_guard lock(mu_);

    auto tit = tickets_.find(ticket_id);
    if (tit == tickets_.end()) return std::nullopt;
    auto& ticket = tit->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;

    auto it = std::find_if(ticket.items.begin(), ticket.items.end(),
        [&](const TicketItem& ti) {
            return !line_key.empty() ? ti.line_key == line_key
                                     : ti.item.id == menu_item_id;
        });
    if (it == ticket.items.end()) return std::nullopt;

    ticket.items.erase(it);
    ticket.recalculate(tax_rate_bps_);
    if (db_) db_->save_ticket(ticket);
    return ticket;
}

std::optional<Ticket> PosManager::decrease_item(const std::string& ticket_id,
                                                 const std::string& menu_item_id,
                                                 const std::string& line_key) {
    std::lock_guard lock(mu_);

    auto tit = tickets_.find(ticket_id);
    if (tit == tickets_.end()) return std::nullopt;
    auto& ticket = tit->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;

    auto it = std::find_if(ticket.items.begin(), ticket.items.end(),
        [&](const TicketItem& ti) {
            return !line_key.empty() ? ti.line_key == line_key
                                     : ti.item.id == menu_item_id;
        });
    if (it == ticket.items.end()) return std::nullopt;

    if (it->quantity > 1) {
        --it->quantity;
    } else {
        ticket.items.erase(it);
    }
    ticket.recalculate(tax_rate_bps_);
    if (db_) db_->save_ticket(ticket);
    return ticket;
}

std::optional<Ticket> PosManager::checkout(const std::string& ticket_id,
                                            const std::vector<Payment>& payments) {
    std::lock_guard lock(mu_);

    auto it = tickets_.find(ticket_id);
    if (it == tickets_.end()) return std::nullopt;
    auto& ticket = it->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;

    // Sum up all payment legs.
    int32_t total_paid = 0;
    for (const auto& p : payments) {
        total_paid += p.amount_cents;
    }
    if (total_paid < ticket.total_cents) return std::nullopt; // underpayment

    ticket.payments = payments;
    ticket.amount_paid_cents = total_paid;
    ticket.change_due_cents = total_paid - ticket.total_cents;
    ticket.status = TicketStatus::CLOSED;
    // Derive primary payment type from first leg.
    if (!payments.empty()) ticket.payment_type = payments[0].payment_type;
    ticket.closed_date = today_str();
    if (db_) db_->save_ticket(ticket);
    return ticket;
}

bool PosManager::void_ticket(const std::string& ticket_id) {
    std::lock_guard lock(mu_);
    auto it = tickets_.find(ticket_id);
    if (it == tickets_.end()) return false;
    auto& t = it->second;
    if (t.status != TicketStatus::OPEN && t.status != TicketStatus::CLOSED)
        return false;
    t.status = TicketStatus::VOIDED;
    if (t.closed_date.empty()) t.closed_date = today_str();
    if (db_) db_->save_ticket(t);
    return true;
}

std::optional<Ticket> PosManager::comp_ticket(const std::string& ticket_id) {
    std::lock_guard lock(mu_);
    auto it = tickets_.find(ticket_id);
    if (it == tickets_.end()) return std::nullopt;
    auto& t = it->second;
    if (t.status != TicketStatus::CLOSED) return std::nullopt;
    t.status = TicketStatus::COMPED;
    if (db_) db_->save_ticket(t);
    return t;
}

std::optional<Ticket> PosManager::refund_ticket(const std::string& ticket_id) {
    std::lock_guard lock(mu_);
    auto it = tickets_.find(ticket_id);
    if (it == tickets_.end()) return std::nullopt;
    auto& t = it->second;
    if (t.status != TicketStatus::CLOSED) return std::nullopt;
    t.status = TicketStatus::REFUNDED;
    if (db_) db_->save_ticket(t);
    return t;
}

std::vector<Ticket> PosManager::list_tickets(const std::string& date,
                                              const std::string& status_filter) const {
    std::lock_guard lock(mu_);
    std::string target = date.empty() ? const_cast<PosManager*>(this)->today_str() : date;
    std::vector<Ticket> result;
    for (const auto& [_, ticket] : tickets_) {
        if (ticket.closed_date != target && ticket.status != TicketStatus::OPEN) continue;
        // For OPEN tickets, include them if target is today.
        if (ticket.status == TicketStatus::OPEN) {
            if (target != const_cast<PosManager*>(this)->today_str()) continue;
        }
        if (!status_filter.empty()) {
            std::string ts;
            switch (ticket.status) {
                case TicketStatus::OPEN: ts = "OPEN"; break;
                case TicketStatus::CLOSED: ts = "CLOSED"; break;
                case TicketStatus::VOIDED: ts = "VOIDED"; break;
                case TicketStatus::COMPED: ts = "COMPED"; break;
                case TicketStatus::REFUNDED: ts = "REFUNDED"; break;
            }
            if (ts != status_filter) continue;
        }
        result.push_back(ticket);
    }
    // Sort by created_at descending (newest first).
    std::sort(result.begin(), result.end(),
        [](const auto& a, const auto& b) { return a.created_at_ms > b.created_at_ms; });
    return result;
}

// ── Reporting ────────────────────────────────────────────────

namespace {
// Internal helper to accumulate a report from tickets for a given date.
void accumulate_report(DailyReport& rpt, const Ticket& ticket,
                       std::unordered_map<std::string, ItemSalesEntry>& item_map) {
    if (ticket.status == TicketStatus::CLOSED) {
        ++rpt.total_tickets;
        rpt.total_revenue_cents += ticket.total_cents;
        rpt.total_tax_cents     += ticket.tax_cents;
        for (const auto& p : ticket.payments) {
            if (p.payment_type == "CASH") {
                ++rpt.cash_count;
                rpt.cash_total_cents += p.amount_cents;
            } else if (p.payment_type == "CARD") {
                ++rpt.card_count;
                rpt.card_total_cents += p.amount_cents;
            }
        }
        // If no payments (legacy), fall back to payment_type.
        if (ticket.payments.empty() && !ticket.payment_type.empty()) {
            if (ticket.payment_type == "CASH") { ++rpt.cash_count; rpt.cash_total_cents += ticket.total_cents; }
            else if (ticket.payment_type == "CARD") { ++rpt.card_count; rpt.card_total_cents += ticket.total_cents; }
        }
        for (const auto& ti : ticket.items) {
            auto& e = item_map[ti.item.id];
            e.item_name      = ti.item.name;
            e.quantity_sold  += ti.quantity;
            e.revenue_cents  += ti.item.price_cents * ti.quantity;
        }
    } else if (ticket.status == TicketStatus::VOIDED) {
        ++rpt.voided_count;
    } else if (ticket.status == TicketStatus::COMPED) {
        ++rpt.comped_count;
        rpt.comped_total_cents += ticket.total_cents;
    } else if (ticket.status == TicketStatus::REFUNDED) {
        ++rpt.refunded_count;
        rpt.refunded_total_cents += ticket.total_cents;
    }
}

void finalize_report(DailyReport& rpt,
                     std::unordered_map<std::string, ItemSalesEntry>& item_map) {
    rpt.net_revenue_cents = rpt.total_revenue_cents
        - rpt.refunded_total_cents - rpt.comped_total_cents;
    rpt.item_sales.reserve(item_map.size());
    for (auto& [_, entry] : item_map) {
        rpt.item_sales.push_back(std::move(entry));
    }
    std::sort(rpt.item_sales.begin(), rpt.item_sales.end(),
        [](const auto& a, const auto& b) { return a.revenue_cents > b.revenue_cents; });
}
}  // namespace

DailyReport PosManager::get_daily_report(const std::string& date) const {
    std::lock_guard lock(mu_);
    std::string target = date.empty() ? const_cast<PosManager*>(this)->today_str() : date;

    // Check archived reports first.
    for (const auto& ar : archived_reports_) {
        if (ar.date == target) return ar;
    }

    DailyReport rpt;
    rpt.date = target;
    std::unordered_map<std::string, ItemSalesEntry> item_map;

    for (const auto& [_, ticket] : tickets_) {
        if (ticket.closed_date != target) continue;
        accumulate_report(rpt, ticket, item_map);
    }
    finalize_report(rpt, item_map);
    return rpt;
}

std::vector<DailyReport> PosManager::get_report_history(int days_back) const {
    if (days_back <= 0) days_back = 30;

    std::lock_guard lock(mu_);

    // Start with archived reports.
    std::vector<DailyReport> reports = archived_reports_;

    // Collect unique dates from live tickets.
    std::unordered_map<std::string, bool> date_set;
    for (const auto& [_, ticket] : tickets_) {
        if (!ticket.closed_date.empty()) {
            date_set[ticket.closed_date] = true;
        }
    }

    for (const auto& [date, _] : date_set) {
        // Skip if we already have an archived report for this date.
        bool have_archived = false;
        for (const auto& ar : archived_reports_) {
            if (ar.date == date) { have_archived = true; break; }
        }
        if (have_archived) continue;

        DailyReport rpt;
        rpt.date = date;
        std::unordered_map<std::string, ItemSalesEntry> item_map;
        for (const auto& [__, ticket] : tickets_) {
            if (ticket.closed_date != date) continue;
            accumulate_report(rpt, ticket, item_map);
        }
        finalize_report(rpt, item_map);
        reports.push_back(std::move(rpt));
    }

    std::sort(reports.begin(), reports.end(),
        [](const auto& a, const auto& b) { return a.date > b.date; });

    if (static_cast<int>(reports.size()) > days_back)
        reports.resize(days_back);

    return reports;
}

DailyReport PosManager::get_date_range_report(const std::string& start,
                                               const std::string& end) const {
    auto all = get_report_history(365);
    DailyReport summary;
    summary.date = start + " to " + end;
    for (const auto& r : all) {
        if (r.date >= start && r.date <= end) {
            summary.total_tickets       += r.total_tickets;
            summary.total_revenue_cents += r.total_revenue_cents;
            summary.total_tax_cents     += r.total_tax_cents;
            summary.cash_count          += r.cash_count;
            summary.card_count          += r.card_count;
            summary.voided_count        += r.voided_count;
            summary.comped_count        += r.comped_count;
            summary.refunded_count      += r.refunded_count;
            summary.cash_total_cents    += r.cash_total_cents;
            summary.card_total_cents    += r.card_total_cents;
            summary.comped_total_cents  += r.comped_total_cents;
            summary.refunded_total_cents += r.refunded_total_cents;
            // Merge item sales.
            for (const auto& e : r.item_sales) {
                bool found = false;
                for (auto& se : summary.item_sales) {
                    if (se.item_name == e.item_name) {
                        se.quantity_sold += e.quantity_sold;
                        se.revenue_cents += e.revenue_cents;
                        found = true;
                        break;
                    }
                }
                if (!found) summary.item_sales.push_back(e);
            }
        }
    }
    summary.net_revenue_cents = summary.total_revenue_cents
        - summary.refunded_total_cents - summary.comped_total_cents;
    std::sort(summary.item_sales.begin(), summary.item_sales.end(),
        [](const auto& a, const auto& b) { return a.revenue_cents > b.revenue_cents; });
    return summary;
}

// ── End of Day ───────────────────────────────────────────────

DailyReport PosManager::end_day() {
    std::lock_guard lock(mu_);

    std::string today = today_str();

    // 1. Build Z-report from today's tickets.
    DailyReport zrpt;
    zrpt.date = today;
    std::unordered_map<std::string, ItemSalesEntry> item_map;
    for (const auto& [_, ticket] : tickets_) {
        if (ticket.closed_date != today) continue;
        accumulate_report(zrpt, ticket, item_map);
    }
    finalize_report(zrpt, item_map);

    // 2. Archive the report.
    // Remove any existing archived report for today (shouldn't happen normally).
    archived_reports_.erase(
        std::remove_if(archived_reports_.begin(), archived_reports_.end(),
            [&](const DailyReport& r) { return r.date == today; }),
        archived_reports_.end());
    archived_reports_.push_back(zrpt);

    // 3. Remove all non-OPEN tickets (clear history).
    for (auto it = tickets_.begin(); it != tickets_.end(); ) {
        if (it->second.status != TicketStatus::OPEN) {
            if (db_) db_->delete_ticket(it->second.id);
            it = tickets_.erase(it);
        } else {
            ++it;
        }
    }

    if (db_) db_->save_report(zrpt);
    return zrpt;
}

// ── Phone Orders ─────────────────────────────────────────────

std::optional<PhoneOrder> PosManager::create_phone_order(
        const std::string& ticket_id,
        const std::string& customer_name,
        const std::string& comment) {
    std::lock_guard lock(mu_);

    auto tit = tickets_.find(ticket_id);
    if (tit == tickets_.end()) return std::nullopt;
    auto& ticket = tit->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;
    if (ticket.items.empty()) return std::nullopt;

    ++phone_order_seq_;
    std::ostringstream os;
    os << "PH-" << std::setw(6) << std::setfill('0') << phone_order_seq_;

    PhoneOrder po;
    po.id            = os.str();
    po.ticket        = ticket;  // snapshot
    po.customer_name = customer_name;
    po.comment       = comment;
    po.status        = PhoneOrderStatus::HOLDING;
    po.created_at_ms = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::system_clock::now().time_since_epoch()).count();

    phone_orders_[po.id] = po;

    // Remove the original ticket (it's now in the hold list).
    if (db_) db_->delete_ticket(ticket.id);
    tickets_.erase(tit);

    if (db_) {
        db_->save_phone_order(po);
        db_->save_seq("phone_order", phone_order_seq_);
    }

    return po;
}

std::vector<PhoneOrder> PosManager::list_phone_orders() const {
    std::lock_guard lock(mu_);
    std::vector<PhoneOrder> result;
    for (const auto& [_, po] : phone_orders_) {
        if (po.status == PhoneOrderStatus::HOLDING) {
            result.push_back(po);
        }
    }
    // Sort by created_at ascending (oldest first — FIFO).
    std::sort(result.begin(), result.end(),
        [](const auto& a, const auto& b) { return a.created_at_ms < b.created_at_ms; });
    return result;
}

int32_t PosManager::phone_order_count() const {
    std::lock_guard lock(mu_);
    int32_t count = 0;
    for (const auto& [_, po] : phone_orders_) {
        if (po.status == PhoneOrderStatus::HOLDING) ++count;
    }
    return count;
}

std::optional<Ticket> PosManager::update_item(const std::string& ticket_id,
                                               const std::string& line_key,
                                               const std::vector<AppliedModifier>& modifiers,
                                               const std::string& special_instructions) {
    std::lock_guard lock(mu_);

    auto tit = tickets_.find(ticket_id);
    if (tit == tickets_.end()) return std::nullopt;
    auto& ticket = tit->second;
    if (ticket.status != TicketStatus::OPEN) return std::nullopt;

    auto it = std::find_if(ticket.items.begin(), ticket.items.end(),
        [&](const TicketItem& ti) { return ti.line_key == line_key; });
    if (it == ticket.items.end()) return std::nullopt;

    // Update modifiers, special instructions, and recompute line key.
    it->modifiers            = modifiers;
    it->special_instructions = special_instructions;
    it->line_key             = compute_line_key(it->item.id, modifiers, special_instructions);

    ticket.recalculate(tax_rate_bps_);
    if (db_) db_->save_ticket(ticket);
    return ticket;
}

std::optional<PhoneOrder> PosManager::phone_order_action(
        const std::string& phone_order_id,
        const std::string& action) {
    std::lock_guard lock(mu_);

    auto it = phone_orders_.find(phone_order_id);
    if (it == phone_orders_.end()) return std::nullopt;
    auto& po = it->second;
    if (po.status != PhoneOrderStatus::HOLDING) return std::nullopt;

    if (action == "CHECKOUT") {
        // Restore the ticket as OPEN so the UI can run a normal checkout flow.
        Ticket t = po.ticket;
        t.status = TicketStatus::OPEN;
        t.recalculate(tax_rate_bps_);
        tickets_[t.id] = t;
        po.status = PhoneOrderStatus::COMPLETED;
        if (db_) {
            db_->save_ticket(t);
            db_->save_phone_order(po);
        }
        return po;
    } else if (action == "CANCEL") {
        po.status = PhoneOrderStatus::CANCELLED;
        if (db_) db_->save_phone_order(po);
        return po;
    } else if (action == "EDIT") {
        // Restore the ticket as OPEN for editing, but keep phone order as HOLDING.
        Ticket t = po.ticket;
        t.status = TicketStatus::OPEN;
        t.recalculate(tax_rate_bps_);
        tickets_[t.id] = t;
        if (db_) db_->save_ticket(t);
        return po;
    }

    return std::nullopt;
}

}  // namespace viewtouch
