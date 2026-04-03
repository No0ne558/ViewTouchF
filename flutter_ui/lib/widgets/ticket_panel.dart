import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';

/// Right-side panel showing the current ticket's line items,
/// subtotal, tax, total, and a checkout button.
class TicketPanel extends StatelessWidget {
  final Ticket? ticket;
  final VoidCallback onCheckout;
  final ValueChanged<TicketItem> onDecreaseItem;
  final ValueChanged<TicketItem> onIncreaseItem;

  const TicketPanel({
    super.key,
    required this.ticket,
    required this.onCheckout,
    required this.onDecreaseItem,
    required this.onIncreaseItem,
  });

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  String _actionLabel(ModifierAction a) {
    switch (a) {
      case ModifierAction.MOD_NO:     return 'NO';
      case ModifierAction.MOD_ADD:    return 'ADD';
      case ModifierAction.MOD_EXTRA:  return 'EXTRA';
      case ModifierAction.MOD_LIGHT:  return 'LIGHT';
      case ModifierAction.MOD_SIDE:   return 'ON SIDE';
      case ModifierAction.MOD_DOUBLE: return 'DOUBLE';
      default: return '';
    }
  }

  Color _actionColor(ModifierAction a) {
    switch (a) {
      case ModifierAction.MOD_NO:     return Colors.red;
      case ModifierAction.MOD_ADD:    return Colors.green;
      case ModifierAction.MOD_EXTRA:  return Colors.orange;
      case ModifierAction.MOD_LIGHT:  return Colors.blue;
      case ModifierAction.MOD_SIDE:   return Colors.purple;
      case ModifierAction.MOD_DOUBLE: return Colors.deepOrange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    if (t == null) {
      return const Center(child: Text('No active ticket'));
    }

    return Column(
      children: [
        // ── Line items ────────────────────────────────────────
        Expanded(
          child: t.items.isEmpty
              ? const Center(
                  child: Text('Tap a menu item to begin',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
              : ListView.separated(
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
                    final adjLineTotal = (ti.item.priceCents + modAdj) * ti.quantity;
                    return Dismissible(
                      key: ValueKey('${ti.lineKey}-${ti.quantity}'),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        color: Colors.green.shade700,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('+1', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.orange.shade700,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('-1', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                            SizedBox(width: 8),
                            Icon(Icons.remove_circle, color: Colors.white),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          onIncreaseItem(ti);
                        } else {
                          onDecreaseItem(ti);
                        }
                        return false; // never dismiss — state drives UI
                      },
                      child: ListTile(
                        dense: true,
                        title: Text(ti.item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('x${ti.quantity}  @  ${_money(ti.item.priceCents)}'),
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
                          ],
                        ),
                        trailing: Text(
                          _money(adjLineTotal),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // ── Totals + Checkout ─────────────────────────────────
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _TotalRow(label: 'Subtotal', value: _money(t.subtotal)),
              _TotalRow(label: 'Tax', value: _money(t.tax)),
              const Divider(),
              _TotalRow(
                label: 'TOTAL',
                value: _money(t.total),
                bold: true,
                fontSize: 22,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: t.items.isEmpty ? null : onCheckout,
                  icon: const Icon(Icons.payment),
                  label: const Text('CHECKOUT', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ],
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
