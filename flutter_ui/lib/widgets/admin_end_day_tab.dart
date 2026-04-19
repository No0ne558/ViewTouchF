import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';
import '../utils/money.dart';

class AdminEndDayTab extends StatefulWidget {
  const AdminEndDayTab({super.key});

  @override
  State<AdminEndDayTab> createState() => _AdminEndDayTabState();
}

class _AdminEndDayTabState extends State<AdminEndDayTab> {
  bool _processing = false;
  DailyReport? _zReport;
  bool _xPrinting = false;

  String _money(int cents) => formatMoney(cents);

  Future<void> _endDay() async {
    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          size: 48,
          color: Colors.orange,
        ),
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('End Day'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _processing = true;
      _zReport = null;
    });
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

  Future<void> _xReport() async {
    final now = DateTime.now();

    final selected = await showDialog<_MonthOption>(
      context: context,
      builder: (ctx) =>
          _XReportMonthPicker(currentYear: now.year, currentMonth: now.month),
    );
    if (selected == null) return;

    // Calculate start/end dates for the selected month
    final startDate = DateTime(selected.year, selected.month, 1);
    final endDate = (selected.year == now.year && selected.month == now.month)
        ? now
        : DateTime(selected.year, selected.month + 1, 0); // last day of month

    setState(() => _xPrinting = true);
    try {
      final resp = await PosClient.instance.stub.printReport(
        PrintReportRequest()
          ..reportType = 'XREPORT'
          ..startDate = _fmt(startDate)
          ..endDate = _fmt(endDate),
      );
      if (resp.success) {
        _msg(
          'X-Report for ${selected.label} sent to printer (Job #${resp.jobId})',
          Colors.green,
        );
      } else {
        _msg('Print error: ${resp.error}', Colors.red);
      }
    } catch (e) {
      _msg('X-Report error: $e', Colors.red);
    }
    if (mounted) setState(() => _xPrinting = false);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _msg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            Icons.nightlight_round,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text('End of Day', style: Theme.of(context).textTheme.headlineMedium),
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
              label: const Text(
                'End Day & Print Z-Report',
                style: TextStyle(fontSize: 18),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          const SizedBox(height: 24),
          // ── X Report button ──
          if (_xPrinting)
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          else
            OutlinedButton.icon(
              onPressed: _xReport,
              icon: const Icon(Icons.summarize, size: 22),
              label: const Text(
                'X Report (Monthly)',
                style: TextStyle(fontSize: 18),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                side: BorderSide(color: Colors.blue.shade700),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          if (_zReport != null) ...[
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Z-Report — ${_zReport!.date}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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
            _row('Subtotal', _money(r.subtotalCents)),
            _row('Tax Collected', _money(r.totalTaxCents)),
            _row('Gross Revenue', _money(r.totalRevenueCents)),
            _row('CC Fees', _money(r.ccFeeTotalCents)),
            _row('Net Revenue', _money(r.netRevenueCents)),
            _row('Total Collected', _money(r.totalCollectedCents)),
            const Divider(),
            _row('Cash Payments', '${r.cashCount}'),
            _row('Cash Total', _money(r.cashTotalCents)),
            _row('Card Payments', '${r.cardCount}'),
            _row('Card Total', _money(r.cardTotalCents)),
            const Divider(),
            _row('Voided', '${r.voidedCount}'),
            _row('Comped', '${r.compedCount} — ${_money(r.compedTotalCents)}'),
            _row(
              'Refunded',
              '${r.refundedCount} — ${_money(r.refundedTotalCents)}',
            ),
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
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MonthOption {
  final int year;
  final int month;
  final String label;
  const _MonthOption({
    required this.year,
    required this.month,
    required this.label,
  });
}

/// Dialog that lets the user pick a year, then a month within that year.
class _XReportMonthPicker extends StatefulWidget {
  final int currentYear;
  final int currentMonth;
  const _XReportMonthPicker({
    required this.currentYear,
    required this.currentMonth,
  });
  @override
  State<_XReportMonthPicker> createState() => _XReportMonthPickerState();
}

class _XReportMonthPickerState extends State<_XReportMonthPicker> {
  late int _selectedYear;

  static const _monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.currentYear;
  }

  int get _maxMonth =>
      _selectedYear == widget.currentYear ? widget.currentMonth : 12;

  @override
  Widget build(BuildContext context) {
    // Years from 2020 up to current year
    final years = List.generate(
      widget.currentYear - 2019,
      (i) => widget.currentYear - i,
    );

    return AlertDialog(
      icon: const Icon(Icons.summarize, size: 48, color: Colors.blue),
      title: const Text('X Report — Select Month'),
      content: SizedBox(
        width: 400,
        height: 520,
        child: Column(
          children: [
            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _selectedYear > 2020
                      ? () => setState(() => _selectedYear--)
                      : null,
                ),
                DropdownButton<int>(
                  value: _selectedYear,
                  style: Theme.of(context).textTheme.titleLarge,
                  underline: const SizedBox.shrink(),
                  items: years
                      .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                      .toList(),
                  onChanged: (y) {
                    if (y != null) setState(() => _selectedYear = y);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _selectedYear < widget.currentYear
                      ? () => setState(() => _selectedYear++)
                      : null,
                ),
              ],
            ),
            const Divider(),
            // Month grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(12, (i) {
                  final month = i + 1;
                  final enabled = month <= _maxMonth;
                  final isCurrent = _selectedYear == widget.currentYear &&
                      month == widget.currentMonth;
                  return Material(
                    color: isCurrent
                        ? Colors.blue.shade100
                        : enabled
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: enabled
                          ? () => Navigator.pop(
                                context,
                                _MonthOption(
                                  year: _selectedYear,
                                  month: month,
                                  label: '${_monthNames[month]} $_selectedYear',
                                ),
                              )
                          : null,
                      child: Center(
                        child: Text(
                          _monthNames[month].substring(0, 3),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: enabled
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
