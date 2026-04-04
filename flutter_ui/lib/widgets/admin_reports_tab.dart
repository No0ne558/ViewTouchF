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
    final d = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => _SingleDatePickerDialog(
        initialDate: _selectedDate,
        title: 'Select Report Date',
      ),
    );
    if (d != null) {
      _selectedDate = d;
      _loadReport();
    }
  }

  Future<void> _pickCustomRange() async {
    final r = await showDialog<DateTimeRange>(
      context: context,
      builder: (ctx) => _DateRangePickerDialog(
        initialRange: _customRange,
      ),
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
      case _ReportRange.monthly:
      case _ReportRange.yearly:
        type = _range == _ReportRange.weekly
            ? 'WEEKLY'
            : _range == _ReportRange.monthly
                ? 'MONTHLY'
                : 'YEARLY';
        final r = _computeDateRange();
        startDate = _fmt(r.start);
        endDate = _fmt(r.end);
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

// ─────────────────────────────────────────────────────────────
// Reusable calendar grid with year/month navigation
// ─────────────────────────────────────────────────────────────

class _CalendarGrid extends StatefulWidget {
  final DateTime initialMonth;
  final DateTime? selectedStart;
  final DateTime? selectedEnd;
  final bool rangeMode;
  final ValueChanged<DateTime> onDayTap;

  const _CalendarGrid({
    required this.initialMonth,
    this.selectedStart,
    this.selectedEnd,
    this.rangeMode = false,
    required this.onDayTap,
  });

  @override
  State<_CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<_CalendarGrid> {
  late int _year;
  late int _month;

  static const _monthNames = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initialMonth.year;
    _month = widget.initialMonth.month;
  }

  void _prev() {
    setState(() {
      _month--;
      if (_month < 1) { _month = 12; _year--; }
    });
  }

  void _next() {
    final now = DateTime.now();
    final nextMonth = _month == 12 ? 1 : _month + 1;
    final nextYear = _month == 12 ? _year + 1 : _year;
    if (DateTime(nextYear, nextMonth, 1).isAfter(DateTime(now.year, now.month + 1, 0))) return;
    setState(() {
      _month = nextMonth;
      _year = nextYear;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime day) {
    if (!widget.rangeMode || widget.selectedStart == null || widget.selectedEnd == null) {
      return false;
    }
    return day.isAfter(widget.selectedStart!.subtract(const Duration(days: 1))) &&
           day.isBefore(widget.selectedEnd!.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_year, _month, 1);
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0=Sun

    // Year dropdown values
    final years = List.generate(now.year - 2019, (i) => now.year - i);

    final canGoNext = !(_year == now.year && _month == now.month);

    return Column(
      children: [
        // Year + Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              onPressed: _year > 2020 || _month > 1 ? _prev : null,
            ),
            const SizedBox(width: 4),
            DropdownButton<int>(
              value: _year,
              underline: const SizedBox.shrink(),
              style: Theme.of(context).textTheme.titleMedium,
              items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
              onChanged: (y) {
                if (y == null) return;
                setState(() {
                  _year = y;
                  if (_year == now.year && _month > now.month) _month = now.month;
                });
              },
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: _month,
              underline: const SizedBox.shrink(),
              style: Theme.of(context).textTheme.titleMedium,
              items: List.generate(
                _year == now.year ? now.month : 12,
                (i) => DropdownMenuItem(value: i + 1, child: Text(_monthNames[i + 1])),
              ),
              onChanged: (m) {
                if (m != null) setState(() => _month = m);
              },
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 28),
              onPressed: canGoNext ? _next : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Weekday headers
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        // Day grid
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 2, crossAxisSpacing: 2,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (ctx, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final date = DateTime(_year, _month, day);
              final isToday = _isSameDay(date, now);
              final isFuture = date.isAfter(now);

              final isStart = widget.selectedStart != null && _isSameDay(date, widget.selectedStart!);
              final isEnd = widget.selectedEnd != null && _isSameDay(date, widget.selectedEnd!);
              final inRange = _isInRange(date);

              Color? bg;
              Color? fg;
              if (isStart || isEnd) {
                bg = Theme.of(context).colorScheme.primary;
                fg = Theme.of(context).colorScheme.onPrimary;
              } else if (inRange) {
                bg = Theme.of(context).colorScheme.primary.withOpacity(0.15);
              }

              return Material(
                color: bg ?? Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: isFuture ? null : () => widget.onDayTap(date),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: (isStart || isEnd || isToday)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isFuture
                            ? Colors.grey.shade500
                            : fg ?? (isToday
                                ? Theme.of(context).colorScheme.primary
                                : null),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Single date picker dialog (for Daily report)
// ─────────────────────────────────────────────────────────────

class _SingleDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final String title;
  const _SingleDatePickerDialog({required this.initialDate, required this.title});
  @override
  State<_SingleDatePickerDialog> createState() => _SingleDatePickerDialogState();
}

class _SingleDatePickerDialogState extends State<_SingleDatePickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Expanded(
                child: _CalendarGrid(
                  initialMonth: widget.initialDate,
                  selectedStart: widget.initialDate,
                  onDayTap: (date) => Navigator.pop(context, date),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Date range picker dialog (for Custom report)
// ─────────────────────────────────────────────────────────────

class _DateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;
  const _DateRangePickerDialog({this.initialRange});
  @override
  State<_DateRangePickerDialog> createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<_DateRangePickerDialog> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
  }

  String _fmtShort(DateTime? d) {
    if (d == null) return '—';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _onDayTap(DateTime date) {
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        // Start new selection
        _start = date;
        _end = null;
      } else {
        // Complete selection
        if (date.isBefore(_start!)) {
          _end = _start;
          _start = date;
        } else {
          _end = date;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Select Date Range',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              // Show selected range
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_fmtShort(_start),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_forward, size: 20),
                    ),
                    Text(_fmtShort(_end),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              if (_start != null && _end == null)
                const Text('Tap the end date',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              Expanded(
                child: _CalendarGrid(
                  initialMonth: _start ?? DateTime.now(),
                  selectedStart: _start,
                  selectedEnd: _end,
                  rangeMode: true,
                  onDayTap: _onDayTap,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: (_start != null && _end != null)
                        ? () => Navigator.pop(
                              context,
                              DateTimeRange(start: _start!, end: _end!),
                            )
                        : null,
                    child: const Text('Apply', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
