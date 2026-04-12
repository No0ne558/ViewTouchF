#pragma once

#include <chrono>
#include <cstdint>
#include <string>
#include <vector>

#include "core/menu_item.h"

namespace viewtouch {

/// A modifier applied to a specific ticket line item.
struct AppliedModifier {
    std::string modifier_id;
    std::string modifier_name;
    ModifierAction action = ModifierAction::NONE;
    int32_t price_adjustment_cents = 0;
};

struct TicketItem {
    MenuItem item;
    int32_t quantity = 1;
    std::string line_key;  // identifies unique item+modifier combo
    std::vector<AppliedModifier> modifiers;
    std::string special_instructions;
};

enum class TicketStatus { OPEN, CLOSED, VOIDED, COMPED, REFUNDED };

struct Payment {
    std::string payment_type;  // "CASH" or "CARD"
    int32_t amount_cents = 0;
};

struct Ticket {
    std::string id;
    std::vector<TicketItem> items;
    int32_t subtotal_cents = 0;
    int32_t tax_cents = 0;
    int32_t total_cents = 0;
    TicketStatus status = TicketStatus::OPEN;
    std::string payment_type;       // legacy / primary type
    int64_t created_at_ms = 0;      // unix epoch in ms
    std::string closed_date;        // "YYYY-MM-DD" set on checkout
    std::vector<Payment> payments;  // split payment legs
    int32_t amount_paid_cents = 0;  // sum of all payment legs
    int32_t change_due_cents = 0;   // overpayment returned
    int32_t cc_fee_cents = 0;       // credit card fee applied

    /// Recalculate subtotal, tax, total.
    /// @param tax_rate_bps  Tax rate in basis points (e.g. 825 = 8.25%)
    void recalculate(int32_t tax_rate_bps);
};

// ── Phone Order ──────────────────────────────────────────────

enum class PhoneOrderStatus { HOLDING, COMPLETED, CANCELLED };

struct PhoneOrder {
    std::string id;  // e.g. "PH-000001"
    Ticket ticket;   // snapshot at creation
    std::string customer_name;
    std::string comment;
    PhoneOrderStatus status = PhoneOrderStatus::HOLDING;
    int64_t created_at_ms = 0;
};

}  // namespace viewtouch
