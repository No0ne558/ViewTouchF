import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:viewtouch_ui/generated/app_localizations.dart';
import '../generated/pos_service.pb.dart';
import '../utils/money.dart';
import 'touchscreen_keyboard.dart';

/// Right-side panel showing the current ticket's line items,
/// subtotal, tax, total, and a checkout button.
class TicketPanel extends StatefulWidget {
  final Ticket? ticket;
  final VoidCallback onCheckout;
  final VoidCallback onPhoneOrder;
  final ValueChanged<TicketItem> onDecreaseItem;
  final ValueChanged<TicketItem> onIncreaseItem;
  final ValueChanged<TicketItem> onRemoveItem;
  final void Function(TicketItem ti, int qty) onSetQuantity;
  final ValueChanged<TicketItem>? onItemTap;

  const TicketPanel({
    super.key,
    required this.ticket,
    required this.onCheckout,
    required this.onPhoneOrder,
    required this.onDecreaseItem,
    required this.onIncreaseItem,
    required this.onRemoveItem,
    required this.onSetQuantity,
    this.onItemTap,
  });

  @override
  State<TicketPanel> createState() => _TicketPanelState();
}

class _TicketPanelState extends State<TicketPanel> {
  final ScrollController _scrollCtrl = ScrollController();
  int _prevItemCount = 0;

  @override
  void didUpdateWidget(covariant TicketPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newCount = widget.ticket?.items.length ?? 0;
    if (newCount > _prevItemCount) {
      // New item added — scroll to bottom after the frame renders.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
    _prevItemCount = newCount;
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _money(int cents) => formatMoney(cents);

  String _actionLabel(ModifierAction a) {
    final loc = AppLocalizations.of(context)!;
    switch (a) {
      case ModifierAction.MOD_NO:
        return loc.modNo;
      case ModifierAction.MOD_ADD:
        return loc.modAdd;
      case ModifierAction.MOD_EXTRA:
        return loc.modExtra;
      case ModifierAction.MOD_LIGHT:
        return loc.modLight;
      case ModifierAction.MOD_SIDE:
        return loc.modSide;
      case ModifierAction.MOD_DOUBLE:
        return loc.modDouble;
      default:
        return '';
    }
  }

  Color _actionColor(ModifierAction a) {
    switch (a) {
      case ModifierAction.MOD_NO:
        return Colors.red;
      case ModifierAction.MOD_ADD:
        return Colors.green;
      case ModifierAction.MOD_EXTRA:
        return Colors.orange;
      case ModifierAction.MOD_LIGHT:
        return Colors.blue;
      case ModifierAction.MOD_SIDE:
        return Colors.purple;
      case ModifierAction.MOD_DOUBLE:
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.ticket;
    if (t == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noActiveTicket));
    }

    return Column(
      children: [
        // ── Line items ────────────────────────────────────────
        Expanded(
          child: t.items.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!.tapMenuToBegin,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                )
              : ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: ListView.separated(
                    controller: _scrollCtrl,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: t.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final ti = t.items[i];
                      // Calculate line total including modifier adjustments.
                      int modAdj = 0;
                      for (final m in ti.modifiers) {
                        modAdj += m.priceAdjustmentCents;
                      }
                      final adjLineTotal =
                          (ti.item.priceCents + modAdj) * ti.quantity;
                      return Padding(
                        key: ValueKey('${ti.lineKey}-${ti.quantity}'),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Top row: item name (tappable) ──
                            GestureDetector(
                              onTap: widget.onItemTap != null
                                  ? () => widget.onItemTap!(ti)
                                  : null,
                              child: Text(ti.item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                            ),
                            // ── Modifiers + special instructions ──
                            if (ti.modifiers.isNotEmpty)
                              ...ti.modifiers.map((m) {
                                final label = _actionLabel(m.action);
                                final price = m.priceAdjustmentCents > 0
                                    ? ' +${_money(m.priceAdjustmentCents)}'
                                    : '';
                                return Text(
                                  '  $label ${m.modifierName}$price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _actionColor(m.action),
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              }),
                            if (ti.specialInstructions.isNotEmpty)
                              Text(
                                '  \u{1F4DD} ${ti.specialInstructions}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(height: 4),
                            // ── Bottom row: [-] qty [+]  🗑  price ──
                            Row(
                              children: [
                                // Minus button
                                _QuantityButton(
                                  icon: Icons.remove,
                                  color: Colors.orange.shade700,
                                  onTap: () => widget.onDecreaseItem(ti),
                                ),
                                // Quantity counter (tappable for custom input)
                                GestureDetector(
                                  onTap: () => _showQuantityPad(ctx, ti),
                                  child: Container(
                                    width: 44,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: Text(
                                      '${ti.quantity}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // Plus button
                                _QuantityButton(
                                  icon: Icons.add,
                                  color: Colors.green.shade700,
                                  onTap: () => widget.onIncreaseItem(ti),
                                ),
                                const SizedBox(width: 8),
                                // Trash button
                                _QuantityButton(
                                  icon: Icons.delete_outline,
                                  color: Colors.red.shade700,
                                  onTap: () => _confirmRemove(ctx, ti),
                                ),
                                const Spacer(),
                                // Price
                                Text(
                                  _money(adjLineTotal),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
        // ── Totals + Checkout ─────────────────────────────────
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _TotalRow(
                  label: AppLocalizations.of(context)!.subtotal,
                  value: _money(t.subtotal)),
              _TotalRow(
                  label: AppLocalizations.of(context)!.tax,
                  value: _money(t.tax)),
              const Divider(),
              _TotalRow(
                label: 'TOTAL',
                value: _money(t.total),
                bold: true,
                fontSize: 22,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: t.items.isEmpty ? null : widget.onPhoneOrder,
                        icon: const Icon(Icons.phone),
                        label: Text(AppLocalizations.of(context)!.phoneOrder,
                            style: const TextStyle(fontSize: 16)),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: t.items.isEmpty ? null : widget.onCheckout,
                        icon: const Icon(Icons.payment),
                        label: Text(AppLocalizations.of(context)!.checkout,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Open numeric keypad to set custom quantity ───────────
  void _showQuantityPad(BuildContext context, TicketItem ti) {
    showDialog<String>(
      context: context,
      builder: (_) => TouchKeyboardDialog(
        title: AppLocalizations.of(context)!.enterQuantity,
        numericOnly: true,
      ),
    ).then((val) {
      if (val != null && val.isNotEmpty) {
        final qty = int.tryParse(val);
        if (qty != null && qty > 0) {
          widget.onSetQuantity(ti, qty);
        }
      }
    });
  }

  // ── Confirm before removing item with qty > 2 ───────────
  void _confirmRemove(BuildContext context, TicketItem ti) {
    if (ti.quantity > 2) {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.removeItemTitle),
          content: Text(AppLocalizations.of(context)!
              .removeItemConfirm(ti.item.name, ti.quantity)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(AppLocalizations.of(context)!.remove),
            ),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true) widget.onRemoveItem(ti);
      });
    } else {
      widget.onRemoveItem(ti);
    }
  }
}

// ── Small square icon button used for +/−/trash ─────────────
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final double fontSize;

  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
