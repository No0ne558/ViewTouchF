import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';

class AdminEndDayTab extends StatefulWidget {
  const AdminEndDayTab({super.key});

  @override
  State<AdminEndDayTab> createState() => _AdminEndDayTabState();
}

class _AdminEndDayTabState extends State<AdminEndDayTab> {
  bool _processing = false;
  DailyReport? _zReport;

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  Future<void> _endDay() async {
    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            size: 48, color: Colors.orange),
        title: const Text('End Day'),
        content: const Text(
          'This will:\n\n'
          '• Generate and print a Z-Report for today\n'
          '• Clear all closed ticket history\n'
          '• Reports will be preserved for future viewing\n\n'
          'This action cannot be undone. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            child: const Text('End Day'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() { _processing = true; _zReport = null; });
    try {
      final resp = await PosClient.instance.stub.endDay(EndDayRequest());
      if (!resp.success) {
        _msg('End Day failed: ${resp.error}', Colors.red);
        setState(() => _processing = false);
        return;
      }
      setState(() {
        _zReport = resp.zReport;
        _processing = false;
      });
      _msg('Day ended — Z-Report printed', Colors.green);
    } catch (e) {
      _msg('End Day error: $e', Colors.red);
      setState(() => _processing = false);
    }
  }

  void _msg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(Icons.nightlight_round,
              size: 80, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text('End of Day',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text(
            'Close out the current business day.\n'
            'A Z-Report will be generated and automatically printed to the receipt printer.\n'
            'All closed tickets will be cleared, but reports are kept for future reference.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          if (_processing)
            const CircularProgressIndicator()
          else
            FilledButton.icon(
              onPressed: _endDay,
              icon: const Icon(Icons.nightlight_round),
              label: const Text('End Day & Print Z-Report',
                  style: TextStyle(fontSize: 18)),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
              ),
            ),
          if (_zReport != null) ...[
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),
            Text('Z-Report — ${_zReport!.date}',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            _buildZReport(_zReport!),
          ],
        ],
      ),
    );
  }

  Widget _buildZReport(DailyReport r) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Total Tickets', '${r.totalTickets}'),
            _row('Gross Revenue', _money(r.totalRevenueCents)),
            _row('Tax Collected', _money(r.totalTaxCents)),
            _row('Net Revenue', _money(r.netRevenueCents)),
            const Divider(),
            _row('Cash Payments', '${r.cashCount}'),
            _row('Cash Total', _money(r.cashTotalCents)),
            _row('Card Payments', '${r.cardCount}'),
            _row('Card Total', _money(r.cardTotalCents)),
            const Divider(),
            _row('Voided', '${r.voidedCount}'),
            _row('Comped', '${r.compedCount} — ${_money(r.compedTotalCents)}'),
            _row('Refunded',
                '${r.refundedCount} — ${_money(r.refundedTotalCents)}'),
            if (r.itemSales.isNotEmpty) ...[
              const Divider(),
              Text('Item Sales',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final item in r.itemSales)
                _row(item.itemName,
                    '${item.quantitySold} qty — ${_money(item.revenueCents)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
