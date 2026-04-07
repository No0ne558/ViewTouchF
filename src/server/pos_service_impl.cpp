#include "server/pos_service_impl.h"

#include <algorithm>
#include <chrono>
#include <iomanip>
#include <sstream>
#include <thread>

// ── Helpers ──────────────────────────────────────────────────

static std::string ticket_status_str(core::TicketStatus s) {
    switch (s) {
        case core::TicketStatus::OPEN:     return "OPEN";
        case core::TicketStatus::CLOSED:   return "CLOSED";
        case core::TicketStatus::VOIDED:   return "VOIDED";
        case core::TicketStatus::COMPED:   return "COMPED";
        case core::TicketStatus::REFUNDED: return "REFUNDED";
    }
    return "UNKNOWN";
}

static std::string modifier_action_str(core::ModifierAction a) {
    switch (a) {
        case core::ModifierAction::NO:    return "NO";
        case core::ModifierAction::ADD:   return "ADD";
        case core::ModifierAction::EXTRA: return "EXTRA";
        case core::ModifierAction::LIGHT: return "LIGHT";
        default: return "NONE";
    }
}

static core::ModifierAction parse_modifier_action(pb::ModifierAction a) {
    switch (a) {
        case pb::MOD_NO:     return core::ModifierAction::NO;
        case pb::MOD_ADD:    return core::ModifierAction::ADD;
        case pb::MOD_EXTRA:  return core::ModifierAction::EXTRA;
        case pb::MOD_LIGHT:  return core::ModifierAction::LIGHT;
        case pb::MOD_SIDE:   return core::ModifierAction::SIDE;
        case pb::MOD_DOUBLE: return core::ModifierAction::DOUBLE;
        default:             return core::ModifierAction::NONE;
    }
}

static pb::ModifierAction to_proto_action(core::ModifierAction a) {
    switch (a) {
        case core::ModifierAction::NO:     return pb::MOD_NO;
        case core::ModifierAction::ADD:    return pb::MOD_ADD;
        case core::ModifierAction::EXTRA:  return pb::MOD_EXTRA;
        case core::ModifierAction::LIGHT:  return pb::MOD_LIGHT;
        case core::ModifierAction::SIDE:   return pb::MOD_SIDE;
        case core::ModifierAction::DOUBLE: return pb::MOD_DOUBLE;
        default:                           return pb::MOD_NONE;
    }
}

static void fill_proto_menu_item(const core::MenuItem& src, pb::MenuItem* dst) {
    dst->set_id(src.id);
    dst->set_name(src.name);
    dst->set_price_cents(src.price_cents);
    dst->set_category(src.category);
    dst->set_send_to_kitchen(src.send_to_kitchen);
    for (const auto& mg : src.modifier_groups) {
        auto* pg = dst->add_modifier_groups();
        pg->set_id(mg.id);
        pg->set_name(mg.name);
        pg->set_min_select(mg.min_select);
        pg->set_max_select(mg.max_select);
        for (const auto& mod : mg.modifiers) {
            auto* pm = pg->add_modifiers();
            pm->set_id(mod.id);
            pm->set_name(mod.name);
            pm->set_price_cents(mod.price_cents);
            pm->set_is_default(mod.is_default);
        }
    }
}

void PosServiceImpl::fill_proto_ticket(const core::Ticket& src, pb::Ticket* dst) {
    dst->set_id(src.id);
    dst->set_subtotal(src.subtotal_cents);
    dst->set_tax(src.tax_cents);
    dst->set_total(src.total_cents);
    dst->set_status(ticket_status_str(src.status));
    dst->set_created_at(src.created_at_ms);
    dst->set_amount_paid(src.amount_paid_cents);
    dst->set_change_due(src.change_due_cents);
    dst->set_cc_fee(src.cc_fee_cents);
    for (const auto& p : src.payments) {
        auto* pp = dst->add_payments();
        pp->set_payment_type(p.payment_type);
        pp->set_amount_cents(p.amount_cents);
    }
    for (const auto& ti : src.items) {
        auto* proto_item = dst->add_items();
        auto* mi = proto_item->mutable_item();
        mi->set_id(ti.item.id);
        mi->set_name(ti.item.name);
        mi->set_price_cents(ti.item.price_cents);
        mi->set_category(ti.item.category);
        proto_item->set_quantity(ti.quantity);
        proto_item->set_line_key(ti.line_key);
        for (const auto& am : ti.modifiers) {
            auto* pm = proto_item->add_modifiers();
            pm->set_modifier_id(am.modifier_id);
            pm->set_modifier_name(am.modifier_name);
            pm->set_action(to_proto_action(am.action));
            pm->set_price_adjustment_cents(am.price_adjustment_cents);
        }
        if (!ti.special_instructions.empty()) {
            proto_item->set_special_instructions(ti.special_instructions);
        }
    }
}

// ── Constructor ──────────────────────────────────────────────

PosServiceImpl::PosServiceImpl(std::shared_ptr<core::PosManager> mgr,
                               std::shared_ptr<core::CupsPrinter> printer)
    : mgr_(std::move(mgr)), printer_(std::move(printer)) {}

// ── RPC Implementations ──────────────────────────────────────

grpc::Status PosServiceImpl::GetMenu(grpc::ServerContext* /*ctx*/,
                                     const pb::GetMenuRequest* /*req*/,
                                     pb::GetMenuResponse* resp) {
    for (const auto& m : mgr_->get_menu()) {
        fill_proto_menu_item(m, resp->add_items());
    }
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::NewTicket(grpc::ServerContext* /*ctx*/,
                                       const pb::NewTicketRequest* /*req*/,
                                       pb::NewTicketResponse* resp) {
    auto ticket = mgr_->new_ticket();
    fill_proto_ticket(ticket, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::AddItem(grpc::ServerContext* /*ctx*/,
                                     const pb::AddItemRequest* req,
                                     pb::AddItemResponse* resp) {
    std::vector<core::AppliedModifier> mods;
    mods.reserve(req->modifiers_size());
    for (const auto& pm : req->modifiers()) {
        core::AppliedModifier am;
        am.modifier_id            = pm.modifier_id();
        am.modifier_name          = pm.modifier_name();
        am.action                 = parse_modifier_action(pm.action());
        am.price_adjustment_cents = pm.price_adjustment_cents();
        mods.push_back(std::move(am));
    }
    auto result = mgr_->add_item(req->ticket_id(), req->menu_item_id(),
                                  req->quantity(), mods,
                                  req->special_instructions());
    if (!result) {
        return grpc::Status(grpc::INVALID_ARGUMENT, "Ticket or menu item not found, or ticket not open");
    }
    fill_proto_ticket(*result, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::UpdateItem(grpc::ServerContext* /*ctx*/,
                                        const pb::UpdateItemRequest* req,
                                        pb::UpdateItemResponse* resp) {
    std::vector<core::AppliedModifier> mods;
    mods.reserve(req->modifiers_size());
    for (const auto& pm : req->modifiers()) {
        core::AppliedModifier am;
        am.modifier_id            = pm.modifier_id();
        am.modifier_name          = pm.modifier_name();
        am.action                 = parse_modifier_action(pm.action());
        am.price_adjustment_cents = pm.price_adjustment_cents();
        mods.push_back(std::move(am));
    }
    auto result = mgr_->update_item(req->ticket_id(), req->line_key(),
                                     mods, req->special_instructions());
    if (!result) {
        return grpc::Status(grpc::INVALID_ARGUMENT, "Ticket or item not found, or ticket not open");
    }
    fill_proto_ticket(*result, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::RemoveItem(grpc::ServerContext* /*ctx*/,
                                        const pb::RemoveItemRequest* req,
                                        pb::RemoveItemResponse* resp) {
    auto result = mgr_->remove_item(req->ticket_id(), req->menu_item_id(),
                                     req->line_key());
    if (!result) {
        return grpc::Status(grpc::INVALID_ARGUMENT, "Ticket or item not found, or ticket not open");
    }
    fill_proto_ticket(*result, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::DecreaseItem(grpc::ServerContext* /*ctx*/,
                                          const pb::DecreaseItemRequest* req,
                                          pb::DecreaseItemResponse* resp) {
    auto result = mgr_->decrease_item(req->ticket_id(), req->menu_item_id(),
                                       req->line_key());
    if (!result) {
        return grpc::Status(grpc::INVALID_ARGUMENT, "Ticket or item not found, or ticket not open");
    }
    fill_proto_ticket(*result, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::GetTicket(grpc::ServerContext* /*ctx*/,
                                       const pb::GetTicketRequest* req,
                                       pb::GetTicketResponse* resp) {
    auto ticket = mgr_->get_ticket(req->ticket_id());
    if (!ticket) {
        return grpc::Status(grpc::NOT_FOUND, "Ticket not found");
    }
    fill_proto_ticket(*ticket, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::Checkout(grpc::ServerContext* /*ctx*/,
                                      const pb::CheckoutRequest* req,
                                      pb::CheckoutResponse* resp) {
    // Convert proto payments to core payments.
    std::vector<core::Payment> payments;
    payments.reserve(req->payments_size());
    for (const auto& pp : req->payments()) {
        core::Payment p;
        p.payment_type = pp.payment_type();
        p.amount_cents = pp.amount_cents();
        payments.push_back(std::move(p));
    }
    auto result = mgr_->checkout(req->ticket_id(), payments, req->cc_fee_cents());
    if (!result) {
        resp->set_success(false);
        resp->set_error("Ticket not found, already closed, or underpayment");
        return grpc::Status::OK;
    }
    resp->set_success(true);
    fill_proto_ticket(*result, resp->mutable_ticket());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::PrintReceipt(grpc::ServerContext* /*ctx*/,
                                          const pb::PrintReceiptRequest* req,
                                          pb::PrintReceiptResponse* resp) {
    auto ticket = mgr_->get_ticket(req->ticket_id());
    if (!ticket) {
        resp->set_success(false);
        resp->set_error("Ticket not found");
        return grpc::Status::OK;
    }

    auto pr = printer_->print_receipt(*ticket);
    resp->set_success(pr.success);
    resp->set_error(pr.error);
    resp->set_job_id(pr.job_id);
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::WatchPrintStatus(
        grpc::ServerContext* ctx,
        const pb::PrintReceiptRequest* req,
        grpc::ServerWriter<pb::PrintStatusEvent>* writer) {
    // First, trigger the print.
    auto ticket = mgr_->get_ticket(req->ticket_id());
    if (!ticket) {
        return grpc::Status(grpc::NOT_FOUND, "Ticket not found");
    }

    auto pr = printer_->print_receipt(*ticket);
    if (!pr.success) {
        pb::PrintStatusEvent ev;
        ev.set_job_id(0);
        ev.set_status("ERROR");
        ev.set_message(pr.error);
        writer->Write(ev);
        return grpc::Status::OK;
    }

    // Poll CUPS job status and stream updates to the client.
    // In production, replace polling with CUPS subscription API or inotify
    // on /var/spool/cups.
    int job_id = pr.job_id;
    std::string last_state;

    for (int attempt = 0; attempt < 60 && !ctx->IsCancelled(); ++attempt) {
        auto js = printer_->query_job(job_id);

        if (js.state != last_state) {
            pb::PrintStatusEvent ev;
            ev.set_job_id(job_id);
            ev.set_status(js.state);
            ev.set_message(js.message);
            writer->Write(ev);
            last_state = js.state;
        }

        if (js.state == "COMPLETE" || js.state == "ERROR") {
            break;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
    }

    return grpc::Status::OK;
}

// ── Admin: Settings ──────────────────────────────────────────

grpc::Status PosServiceImpl::GetSettings(grpc::ServerContext* /*ctx*/,
                                         const pb::GetSettingsRequest* /*req*/,
                                         pb::GetSettingsResponse* resp) {
    auto* s = resp->mutable_settings();
    s->set_restaurant_name(mgr_->get_restaurant_name());
    s->set_tax_rate_bps(mgr_->get_tax_rate_bps());
    s->set_receipt_printer_name(mgr_->get_receipt_printer_name());
    s->set_receipt_printer_enabled(mgr_->get_receipt_printer_enabled());
    s->set_kitchen_printer_name(mgr_->get_kitchen_printer_name());
    s->set_kitchen_printer_enabled(mgr_->get_kitchen_printer_enabled());
    s->set_cc_fee_cents(mgr_->get_cc_fee_cents());
    s->set_cc_fee_bps(mgr_->get_cc_fee_bps());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::UpdateSettings(grpc::ServerContext* /*ctx*/,
                                            const pb::UpdateSettingsRequest* req,
                                            pb::UpdateSettingsResponse* resp) {
    const auto& s = req->settings();
    if (!s.restaurant_name().empty())
        mgr_->set_restaurant_name(s.restaurant_name());
    if (s.tax_rate_bps() > 0)
        mgr_->set_tax_rate_bps(s.tax_rate_bps());
    // Also update the receipt header on the printer.
    if (!s.restaurant_name().empty())
        printer_->set_store_name(s.restaurant_name());
    // Printer settings — always apply (empty string = cleared).
    mgr_->set_receipt_printer_name(s.receipt_printer_name());
    mgr_->set_receipt_printer_enabled(s.receipt_printer_enabled());
    mgr_->set_kitchen_printer_name(s.kitchen_printer_name());
    mgr_->set_kitchen_printer_enabled(s.kitchen_printer_enabled());
    mgr_->set_cc_fee_cents(s.cc_fee_cents());
    mgr_->set_cc_fee_bps(s.cc_fee_bps());
    // Echo back current settings.
    auto* out = resp->mutable_settings();
    out->set_restaurant_name(mgr_->get_restaurant_name());
    out->set_tax_rate_bps(mgr_->get_tax_rate_bps());
    out->set_receipt_printer_name(mgr_->get_receipt_printer_name());
    out->set_receipt_printer_enabled(mgr_->get_receipt_printer_enabled());
    out->set_kitchen_printer_name(mgr_->get_kitchen_printer_name());
    out->set_kitchen_printer_enabled(mgr_->get_kitchen_printer_enabled());
    out->set_cc_fee_cents(mgr_->get_cc_fee_cents());
    out->set_cc_fee_bps(mgr_->get_cc_fee_bps());
    return grpc::Status::OK;
}

// ── Admin: Menu CRUD ─────────────────────────────────────────

static core::MenuItem parse_proto_menu_item(const pb::MenuItem& src) {
    core::MenuItem mi;
    mi.id              = src.id();
    mi.name            = src.name();
    mi.price_cents     = src.price_cents();
    mi.category        = src.category();
    mi.send_to_kitchen = src.send_to_kitchen();
    for (const auto& pg : src.modifier_groups()) {
        core::ModifierGroup mg;
        mg.id         = pg.id();
        mg.name       = pg.name();
        mg.min_select = pg.min_select();
        mg.max_select = pg.max_select();
        for (const auto& pm : pg.modifiers()) {
            core::Modifier mod;
            mod.id          = pm.id();
            mod.name        = pm.name();
            mod.price_cents = pm.price_cents();
            mod.is_default  = pm.is_default();
            mg.modifiers.push_back(std::move(mod));
        }
        mi.modifier_groups.push_back(std::move(mg));
    }
    return mi;
}

grpc::Status PosServiceImpl::AddMenuItem(grpc::ServerContext* /*ctx*/,
                                         const pb::AddMenuItemRequest* req,
                                         pb::AddMenuItemResponse* resp) {
    auto mi = parse_proto_menu_item(req->item());
    try {
        if (!mgr_->add_menu_item(mi)) {
            return grpc::Status(grpc::ALREADY_EXISTS, "Menu item ID already exists");
        }
    } catch (const std::exception& e) {
        return grpc::Status(grpc::INTERNAL, std::string("Database error: ") + e.what());
    }

    fill_proto_menu_item(mi, resp->mutable_item());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::UpdateMenuItem(grpc::ServerContext* /*ctx*/,
                                            const pb::UpdateMenuItemRequest* req,
                                            pb::UpdateMenuItemResponse* resp) {
    auto mi = parse_proto_menu_item(req->item());
    try {
        if (!mgr_->update_menu_item(mi)) {
            return grpc::Status(grpc::NOT_FOUND, "Menu item not found");
        }
    } catch (const std::exception& e) {
        return grpc::Status(grpc::INTERNAL, std::string("Database error: ") + e.what());
    }

    fill_proto_menu_item(mi, resp->mutable_item());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::DeleteMenuItem(grpc::ServerContext* /*ctx*/,
                                            const pb::DeleteMenuItemRequest* req,
                                            pb::DeleteMenuItemResponse* resp) {
    try {
        resp->set_success(mgr_->delete_menu_item(req->item_id()));
    } catch (const std::exception& e) {
        return grpc::Status(grpc::INTERNAL, std::string("Database error: ") + e.what());
    }
    return grpc::Status::OK;
}

// ── Reporting ────────────────────────────────────────────────

static void fill_proto_report(const core::DailyReport& src, pb::DailyReport* dst) {
    dst->set_date(src.date);
    dst->set_total_tickets(src.total_tickets);
    dst->set_total_revenue_cents(src.total_revenue_cents);
    dst->set_total_tax_cents(src.total_tax_cents);
    dst->set_cash_count(src.cash_count);
    dst->set_card_count(src.card_count);
    dst->set_voided_count(src.voided_count);
    dst->set_comped_count(src.comped_count);
    dst->set_refunded_count(src.refunded_count);
    dst->set_cash_total_cents(src.cash_total_cents);
    dst->set_card_total_cents(src.card_total_cents);
    dst->set_comped_total_cents(src.comped_total_cents);
    dst->set_refunded_total_cents(src.refunded_total_cents);
    dst->set_net_revenue_cents(src.net_revenue_cents);
    dst->set_cc_fee_total_cents(src.cc_fee_total_cents);
    dst->set_total_collected_cents(src.total_collected_cents);
    dst->set_subtotal_cents(src.subtotal_cents);
    for (const auto& e : src.item_sales) {
        auto* pe = dst->add_item_sales();
        pe->set_item_name(e.item_name);
        pe->set_quantity_sold(e.quantity_sold);
        pe->set_revenue_cents(e.revenue_cents);
    }
}

grpc::Status PosServiceImpl::GetDailyReport(grpc::ServerContext* /*ctx*/,
                                            const pb::DailyReportRequest* req,
                                            pb::DailyReportResponse* resp) {
    auto rpt = mgr_->get_daily_report(req->date());
    fill_proto_report(rpt, resp->mutable_report());
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::GetReportHistory(grpc::ServerContext* /*ctx*/,
                                              const pb::ReportHistoryRequest* req,
                                              pb::ReportHistoryResponse* resp) {
    auto reports = mgr_->get_report_history(req->days_back());
    for (const auto& rpt : reports) {
        fill_proto_report(rpt, resp->add_reports());
    }
    return grpc::Status::OK;
}

// ── Printer discovery ────────────────────────────────────────

grpc::Status PosServiceImpl::ListPrinters(grpc::ServerContext* /*ctx*/,
                                          const pb::ListPrintersRequest* /*req*/,
                                          pb::ListPrintersResponse* resp) {
    auto printers = core::CupsPrinter::list_printers();
    for (const auto& p : printers) {
        auto* pi = resp->add_printers();
        pi->set_name(p.name);
        pi->set_description(p.description);
        pi->set_uri(p.uri);
        pi->set_is_default(p.is_default);
    }
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::PrintKitchen(grpc::ServerContext* /*ctx*/,
                                          const pb::PrintKitchenRequest* req,
                                          pb::PrintKitchenResponse* resp) {
    auto ticket = mgr_->get_ticket(req->ticket_id());
    if (!ticket) {
        resp->set_success(false);
        resp->set_error("Ticket not found");
        return grpc::Status::OK;
    }

    std::string kitchen_printer = mgr_->get_kitchen_printer_name();
    if (kitchen_printer.empty()) {
        resp->set_success(false);
        resp->set_error("No kitchen printer configured");
        return grpc::Status::OK;
    }

    auto pr = printer_->print_kitchen(*ticket, kitchen_printer);
    resp->set_success(pr.success);
    resp->set_error(pr.error);
    resp->set_job_id(pr.job_id);
    return grpc::Status::OK;
}

// ── Ticket history & actions ─────────────────────────────────

grpc::Status PosServiceImpl::ListTickets(grpc::ServerContext* /*ctx*/,
                                         const pb::ListTicketsRequest* req,
                                         pb::ListTicketsResponse* resp) {
    auto tickets = mgr_->list_tickets(req->date(), req->status());
    for (const auto& t : tickets) {
        fill_proto_ticket(t, resp->add_tickets());
    }
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::TicketAction(grpc::ServerContext* /*ctx*/,
                                          const pb::TicketActionRequest* req,
                                          pb::TicketActionResponse* resp) {
    std::string action = req->action();
    if (action == "VOID") {
        if (mgr_->void_ticket(req->ticket_id())) {
            auto t = mgr_->get_ticket(req->ticket_id());
            resp->set_success(true);
            if (t) fill_proto_ticket(*t, resp->mutable_ticket());
        } else {
            resp->set_success(false);
            resp->set_error("Cannot void ticket (not found or invalid state)");
        }
    } else if (action == "COMP") {
        auto t = mgr_->comp_ticket(req->ticket_id());
        if (t) {
            resp->set_success(true);
            fill_proto_ticket(*t, resp->mutable_ticket());
        } else {
            resp->set_success(false);
            resp->set_error("Cannot comp ticket (not found or not closed)");
        }
    } else if (action == "REFUND") {
        auto t = mgr_->refund_ticket(req->ticket_id());
        if (t) {
            resp->set_success(true);
            fill_proto_ticket(*t, resp->mutable_ticket());
        } else {
            resp->set_success(false);
            resp->set_error("Cannot refund ticket (not found or not closed)");
        }
    } else {
        resp->set_success(false);
        resp->set_error("Unknown action: " + action);
    }
    return grpc::Status::OK;
}

// ── Extended reporting ───────────────────────────────────────

grpc::Status PosServiceImpl::GetDateRangeReport(
        grpc::ServerContext* /*ctx*/,
        const pb::DateRangeReportRequest* req,
        pb::DateRangeReportResponse* resp) {
    auto summary = mgr_->get_date_range_report(req->start_date(), req->end_date());
    fill_proto_report(summary, resp->mutable_summary());
    // Also return individual daily reports for the range.
    auto history = mgr_->get_report_history(365);
    for (const auto& r : history) {
        if (r.date >= req->start_date() && r.date <= req->end_date()) {
            fill_proto_report(r, resp->add_daily_reports());
        }
    }
    return grpc::Status::OK;
}

// ── Format report as printable text ──────────────────────────

static std::string fmt_money(int32_t cents) {
    bool neg = cents < 0;
    if (neg) cents = -cents;
    std::ostringstream os;
    if (neg) os << '-';
    os << '$' << (cents / 100) << '.' << std::setw(2) << std::setfill('0')
       << (cents % 100);
    return os.str();
}

std::string PosServiceImpl::format_report_text(const core::DailyReport& rpt,
                                                const std::string& title) {
    std::ostringstream os;
    os << "========================================\n";
    os << "  " << title << "\n";
    os << "  " << rpt.date << "\n";
    os << "========================================\n\n";
    os << "Total Tickets:      " << rpt.total_tickets << "\n";
    os << "Gross Revenue:      " << fmt_money(rpt.total_revenue_cents) << "\n";
    os << "Tax Collected:      " << fmt_money(rpt.total_tax_cents) << "\n";
    os << "Net Revenue:        " << fmt_money(rpt.net_revenue_cents) << "\n\n";
    os << "--- Payment Breakdown ---\n";
    os << "Cash:    " << rpt.cash_count << " txns  " << fmt_money(rpt.cash_total_cents) << "\n";
    os << "Card:    " << rpt.card_count << " txns  " << fmt_money(rpt.card_total_cents) << "\n\n";
    os << "--- Adjustments ---\n";
    os << "Voided:   " << rpt.voided_count << "\n";
    os << "Comps:    " << rpt.comped_count << "  " << fmt_money(rpt.comped_total_cents) << "\n";
    os << "Refunds:  " << rpt.refunded_count << "  " << fmt_money(rpt.refunded_total_cents) << "\n\n";
    if (!rpt.item_sales.empty()) {
        os << "--- Item Sales ---\n";
        for (const auto& e : rpt.item_sales) {
            os << "  " << e.item_name << "  x" << e.quantity_sold
               << "  " << fmt_money(e.revenue_cents) << "\n";
        }
        os << "\n";
    }
    os << "========================================\n";
    return os.str();
}

grpc::Status PosServiceImpl::PrintReport(grpc::ServerContext* /*ctx*/,
                                         const pb::PrintReportRequest* req,
                                         pb::PrintReportResponse* resp) {
    std::string receipt_printer = mgr_->get_receipt_printer_name();

    core::DailyReport rpt;
    std::string title;
    std::string date_range;
    std::vector<core::DailyReport> daily_breakdown;

    if (req->report_type() == "DAILY" || req->report_type() == "ZREPORT") {
        rpt = mgr_->get_daily_report(req->date());
        title = req->report_type() == "ZREPORT" ? "Z-REPORT" : "DAILY REPORT";
    } else if (req->report_type() == "CUSTOM" ||
               req->report_type() == "WEEKLY"  ||
               req->report_type() == "MONTHLY" ||
               req->report_type() == "YEARLY"  ||
               req->report_type() == "XREPORT") {
        rpt = mgr_->get_date_range_report(req->start_date(), req->end_date());
        date_range = req->start_date() + " to " + req->end_date();
        // Gather daily breakdown for range reports
        auto history = mgr_->get_report_history(365);
        for (const auto& r : history) {
            if (r.date >= req->start_date() && r.date <= req->end_date()) {
                daily_breakdown.push_back(r);
            }
        }
        // Sort by date ascending
        std::sort(daily_breakdown.begin(), daily_breakdown.end(),
                  [](const auto& a, const auto& b) { return a.date < b.date; });

        if (req->report_type() == "XREPORT") {
            title = "X-REPORT";
        } else if (req->report_type() == "WEEKLY") {
            title = "WEEKLY REPORT";
        } else if (req->report_type() == "MONTHLY") {
            title = "MONTHLY REPORT";
        } else if (req->report_type() == "YEARLY") {
            title = "YEARLY REPORT";
        } else {
            title = "CUSTOM REPORT";
        }
    } else {
        resp->set_success(false);
        resp->set_error("Unknown report type: " + req->report_type());
        return grpc::Status::OK;
    }

    auto pr = printer_->print_formatted_report(rpt, title, date_range,
                                                daily_breakdown, receipt_printer);
    resp->set_success(pr.success);
    resp->set_error(pr.error);
    resp->set_job_id(pr.job_id);
    return grpc::Status::OK;
}

// ── End of Day ───────────────────────────────────────────────

grpc::Status PosServiceImpl::EndDay(grpc::ServerContext* /*ctx*/,
                                    const pb::EndDayRequest* /*req*/,
                                    pb::EndDayResponse* resp) {
    auto zrpt = mgr_->end_day();
    resp->set_success(true);
    fill_proto_report(zrpt, resp->mutable_z_report());

    // Print the Z-report to receipt printer with ESC/POS formatting.
    std::string receipt_printer = mgr_->get_receipt_printer_name();
    if (!receipt_printer.empty() && mgr_->get_receipt_printer_enabled()) {
        printer_->print_formatted_report(zrpt, "Z-REPORT (END OF DAY)",
                                          "", {}, receipt_printer);
    }

    return grpc::Status::OK;
}

// ── Phone Orders ─────────────────────────────────────────────

static std::string phone_order_status_str(core::PhoneOrderStatus s) {
    switch (s) {
        case core::PhoneOrderStatus::HOLDING:   return "HOLDING";
        case core::PhoneOrderStatus::COMPLETED: return "COMPLETED";
        case core::PhoneOrderStatus::CANCELLED: return "CANCELLED";
    }
    return "UNKNOWN";
}

static void fill_proto_phone_order(const core::PhoneOrder& src,
                                    pb::PhoneOrder* dst) {
    dst->set_id(src.id);
    dst->set_customer_name(src.customer_name);
    dst->set_comment(src.comment);
    dst->set_status(phone_order_status_str(src.status));
    dst->set_created_at(src.created_at_ms);
}

grpc::Status PosServiceImpl::CreatePhoneOrder(grpc::ServerContext* /*ctx*/,
                                              const pb::CreatePhoneOrderRequest* req,
                                              pb::CreatePhoneOrderResponse* resp) {
    auto result = mgr_->create_phone_order(
        req->ticket_id(), req->customer_name(), req->comment());
    if (!result) {
        resp->set_success(false);
        resp->set_error("Ticket not found, not open, or empty");
        return grpc::Status::OK;
    }
    resp->set_success(true);
    auto* po = resp->mutable_phone_order();
    fill_proto_phone_order(*result, po);
    fill_proto_ticket(result->ticket, po->mutable_ticket());

    // Print a receipt for the phone order (with customer name/comment).
    if (mgr_->get_receipt_printer_enabled()) {
        printer_->print_receipt(result->ticket,
                                req->customer_name(),
                                req->comment());
    }

    // Send to kitchen like a normal order.
    std::string kitchen_printer = mgr_->get_kitchen_printer_name();
    if (!kitchen_printer.empty() && mgr_->get_kitchen_printer_enabled()) {
        printer_->print_kitchen(result->ticket, kitchen_printer,
                                req->customer_name(),
                                req->comment());
    }

    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::ListPhoneOrders(grpc::ServerContext* /*ctx*/,
                                             const pb::ListPhoneOrdersRequest* /*req*/,
                                             pb::ListPhoneOrdersResponse* resp) {
    auto orders = mgr_->list_phone_orders();
    for (const auto& order : orders) {
        auto* po = resp->add_orders();
        fill_proto_phone_order(order, po);
        fill_proto_ticket(order.ticket, po->mutable_ticket());
    }
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::PhoneOrderAction(grpc::ServerContext* /*ctx*/,
                                              const pb::PhoneOrderActionRequest* req,
                                              pb::PhoneOrderActionResponse* resp) {
    auto result = mgr_->phone_order_action(req->phone_order_id(), req->action());
    if (!result) {
        resp->set_success(false);
        resp->set_error("Phone order not found, not HOLDING, or invalid action");
        return grpc::Status::OK;
    }
    resp->set_success(true);
    auto* po = resp->mutable_phone_order();
    fill_proto_phone_order(*result, po);
    fill_proto_ticket(result->ticket, po->mutable_ticket());
    // On checkout or edit, also return the restored ticket so the UI can use it.
    if (req->action() == "CHECKOUT" || req->action() == "EDIT") {
        auto ticket = mgr_->get_ticket(result->ticket.id);
        if (ticket) {
            fill_proto_ticket(*ticket, resp->mutable_ticket());
        }
    }
    return grpc::Status::OK;
}

grpc::Status PosServiceImpl::GetPhoneOrderCount(grpc::ServerContext* /*ctx*/,
                                                const pb::PhoneOrderCountRequest* /*req*/,
                                                pb::PhoneOrderCountResponse* resp) {
    resp->set_count(mgr_->phone_order_count());
    return grpc::Status::OK;
}

// ── System ───────────────────────────────────────────────────

grpc::Status PosServiceImpl::Shutdown(grpc::ServerContext* /*ctx*/,
                                      const pb::ShutdownRequest* /*req*/,
                                      pb::ShutdownResponse* resp) {
    resp->set_success(true);
    if (shutdown_cb_) {
        // Fire shutdown on a detached thread so the response is sent first.
        std::thread([cb = shutdown_cb_]() {
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
            cb();
        }).detach();
    }
    return grpc::Status::OK;
}
