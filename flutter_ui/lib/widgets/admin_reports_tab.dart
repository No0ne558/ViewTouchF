import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';

class AdminReportsTab extends StatefulWidget {
  const AdminReportsTab({super.key});

  @override
  State<AdminReportsTab> createState() => _AdminReportsTabState();
}

enum _ReportRange { daily, weekly, monthly, yearly, custom }

class _AdminReportsTabState extends State<AdminReportsTab> {
  _ReportRange _range = _ReportRange.daily;
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _customRange;

  DailyReport? _report; // single-day or aggregated summary
  List<DailyReport> _dailyBreakdown = []; // for ranges
  bool _loading = true;
  DailyReport? _detailReport; // expanded day within range

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  Future<void> _loadReport() async {
    setState(() { _loading = true; _detailReport = null; });
    try {
      if (_range == _ReportRange.daily) {
        final resp = await PosClient.instance.stub.getDailyReport(
          DailyReportRequest()..date = _fmt(_selectedDate),
        );
        setState(() {
          _report = resp.report;
          _dailyBreakdown = [];
          _loading = false;
        });
      } else {
        final dates = _computeDateRange();
        final resp = await PosClient.instance.stub.getDateRangeReport(
          DateRangeReportRequest()
            ..startDate = _fmt(dates.start)
            ..endDate = _fmt(dates.end),
        );
        setState(() {
          _report = resp.summary;
          _dailyBreakdown = List.from(resp.dailyReports);
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
      _msg('Failed to load report: $e', Colors.red);
    }
  }

  DateTimeRange _computeDateRange() {
    final now = DateTime.now();
    switch (_range) {
      case _ReportRange.weekly:
        final start = now.subtract(Duration(days: now.weekday - 1));
        return DateTimeRange(
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ReportRange.monthly:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ReportRange.yearly:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ReportRange.custom:
        return _customRange ??
            DateTimeRange(start: now, end: now);
      default:
        return DateTimeRange(start: now, end: now);
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      _selectedDate = d;
      _loadReport();
    }
  }

  Future<void> _pickCustomRange() async {
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customRange,
    );
    if (r != null) {
      _customRange = r;
      _loadReport();
    }
  }

  Future<void> _printReport() async {
    String type;
    String date = '';
    String startDate = '';
    String endDate = '';
    switch (_range) {
      case _ReportRange.daily:
        type = 'DAILY';
        date = _fmt(_selectedDate);
        break;
      case _ReportRange.weekly:
        type = 'WEEKLY';
        break;
      case _ReportRange.monthly:
        type = 'MONTHLY';
        break;
      case _ReportRange.yearly:
        type = 'YEARLY';
        break;
      case _ReportRange.custom:
        type = 'CUSTOM';
        final r = _computeDateRange();
        startDate = _fmt(r.start);
        endDate = _fmt(r.end);
        break;
    }
    try {
      final resp = await PosClient.instance.stub.printReport(
        PrintReportRequest()
          ..reportType = type
          ..date = date
          ..startDate = startDate
          ..endDate = endDate,
      );
      if (resp.success) {
        _msg('Report sent to printer (Job #${resp.jobId})', Colors.green);
      } else {
        _msg('Print error: ${resp.error}', Colors.red);
      }
    } catch (e) {
      _msg('Print error: $e', Colors.red);
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
    return Column(
      children: [
        // ── Top bar: range selector + actions ─────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SegmentedButton<_ReportRange>(
                segments: const [
                  ButtonSegment(value: _ReportRange.daily, label: Text('Daily')),
                  ButtonSegment(value: _ReportRange.weekly, label: Text('Weekly')),
                  ButtonSegment(value: _ReportRange.monthly, label: Text('Monthly')),
                  ButtonSegment(value: _ReportRange.yearly, label: Text('Yearly')),
                  ButtonSegment(value: _ReportRange.custom, label: Text('Custom')),
                ],
                selected: {_range},
                onSelectionChanged: (sel) {
                  setState(() => _range = sel.first);
                  if (_range == _ReportRange.custom) {
                    _pickCustomRange();
                  } else {
                    _loadReport();
                  }
                },
              ),
              const SizedBox(width: 12),
              if (_range == _ReportRange.daily)
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(_fmt(_selectedDate)),
                ),
              if (_range == _ReportRange.custom && _customRange != null)
                OutlinedButton.icon(
                  onPressed: _pickCustomRange,
                  icon: const Icon(Icons.date_range, size: 16),
                  label: Text(
                      '${_fmt(_customRange!.start)} — ${_fmt(_customRange!.end)}'),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: _loadReport,
              ),
              const SizedBox(width: 4),
              FilledButton.icon(
                onPressed: _report != null ? _printReport : null,
                icon: const Icon(Icons.print, size: 18),
                label: const Text('Print'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // ── Body ─────────────────────────────────────────
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _report == null
                  ? const Center(child: Text('No data'))
                  : _range == _ReportRange.daily
                      ? _buildSingleReport(_report!)
                      : _buildRangeReport(),
        ),
      ],
    );
  }

  Widget _buildSingleReport(DailyReport r) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report — ${r.date}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          _buildSummaryCards(r),
          const SizedBox(height: 28),
          _buildItemTable(r),
        ],
      ),
    );
  }

  Widget _buildRangeReport() {
    return Row(
      children: [
        // Left: daily breakdown list
        SizedBox(
          width: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Daily Breakdown',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: _dailyBreakdown.isEmpty
                    ? const Center(child: Text('No data'))
                    : ListView.builder(
                        itemCount: _dailyBreakdown.length,
                        itemBuilder: (ctx, i) {
                          final r = _dailyBreakdown[i];
                          final isSel = _detailReport?.date == r.date;
                          return ListTile(
                            selected: isSel,
                            title: Text(r.date),
                            subtitle: Text(
                                '${r.totalTickets} tickets • ${_money(r.netRevenueCents)}'),
                            dense: true,
                            onTap: () =>
                                setState(() => _detailReport = r),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Right: summary (or selected day detail)
        Expanded(
          child: _detailReport != null
              ? _buildSingleReport(_detailReport!)
              : _buildSingleReport(_report!),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(DailyReport r) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _SummaryCard(
            label: 'Net Revenue', value: _money(r.netRevenueCents),
            icon: Icons.attach_money),
        _SummaryCard(
            label: 'Gross Revenue', value: _money(r.totalRevenueCents),
            icon: Icons.monetization_on_outlined),
        _SummaryCard(
            label: 'Tax', value: _money(r.totalTaxCents),
            icon: Icons.receipt_long),
        _SummaryCard(
            label: 'Cash', value: _money(r.cashTotalCents),
            icon: Icons.payments),
        _SummaryCard(
            label: 'Card', value: _money(r.cardTotalCents),
            icon: Icons.credit_card),
        _SummaryCard(
            label: 'Tickets', value: '${r.totalTickets}',
            icon: Icons.confirmation_number),
        _SummaryCard(
            label: 'Voided', value: '${r.voidedCount}',
            icon: Icons.cancel,
            color: r.voidedCount > 0 ? Colors.red : null),
        _SummaryCard(
            label: 'Comped', value: '${r.compedCount} (${_money(r.compedTotalCents)})',
            icon: Icons.card_giftcard,
            color: r.compedCount > 0 ? Colors.orange : null),
        _SummaryCard(
            label: 'Refunded', value: '${r.refundedCount} (${_money(r.refundedTotalCents)})',
            icon: Icons.undo,
            color: r.refundedCount > 0 ? Colors.purple : null),
      ],
    );
  }

  Widget _buildItemTable(DailyReport r) {
    if (r.itemSales.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Sales',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        DataTable(
          columns: const [
            DataColumn(label: Text('Item')),
            DataColumn(label: Text('Qty'), numeric: true),
            DataColumn(label: Text('Revenue'), numeric: true),
          ],
          rows: r.itemSales.map((e) {
            return DataRow(cells: [
              DataCell(Text(e.itemName)),
              DataCell(Text('${e.quantitySold}')),
              DataCell(Text(_money(e.revenueCents))),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primaryContainer;
    return Card(
      color: cardColor.withOpacity(0.3),
      child: SizedBox(
        width: 175,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(label,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const Spacer(),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
