#include "core/ticket.h"

#include <cmath>

namespace viewtouch {

void Ticket::recalculate(int32_t tax_rate_bps) {
    subtotal_cents = 0;
    for (const auto& ti : items) {
        int32_t item_price = ti.item.price_cents;
        for (const auto& mod : ti.modifiers) {
            item_price += mod.price_adjustment_cents;
        }
        subtotal_cents += item_price * ti.quantity;
    }
    // tax_rate_bps is in basis points: 825 → 8.25%
    // Compute tax with banker's rounding (round half to even is fine;
    // simple round-half-up is acceptable for POS).
    tax_cents   = static_cast<int32_t>(
        std::llround(static_cast<double>(subtotal_cents) * tax_rate_bps / 10000.0));
    total_cents = subtotal_cents + tax_cents;
}

}  // namespace viewtouch
