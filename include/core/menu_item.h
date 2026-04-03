#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace viewtouch {

/// Modifier action types matching proto ModifierAction.
enum class ModifierAction { NONE, NO, ADD, EXTRA, LIGHT, SIDE, DOUBLE };

/// A single modifier option within a group (e.g. "Lettuce", "Bacon").
struct Modifier {
    std::string id;
    std::string name;
    int32_t     price_cents = 0;   // extra cost when added
    bool        is_default  = false; // comes on the plate by default
};

/// A group of related modifiers (e.g. "Toppings", "Cooking Temp").
struct ModifierGroup {
    std::string              id;
    std::string              name;
    std::vector<Modifier>    modifiers;
    int32_t                  min_select = 0;  // 0 = optional
    int32_t                  max_select = 0;  // 0 = unlimited
};

/// Represents a single menu item. Prices are always in cents to avoid
/// floating-point rounding issues on financial calculations.
struct MenuItem {
    std::string                   id;
    std::string                   name;
    int32_t                       price_cents = 0;
    std::string                   category;
    std::vector<ModifierGroup>    modifier_groups;
    bool                          send_to_kitchen = true;
};

}  // namespace viewtouch
