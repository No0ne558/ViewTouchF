import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';
import '../utils/money.dart';

class AdminMenuProductivityTab extends StatefulWidget {
  const AdminMenuProductivityTab({super.key});

  @override
  State<AdminMenuProductivityTab> createState() =>
      _AdminMenuProductivityTabState();
}

enum _ProdRange { daily, weekly, monthly, yearly, custom }

class _AdminMenuProductivityTabState extends State<AdminMenuProductivityTab> {
  _ProdRange _range = _ProdRange.daily;
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _customRange;

  List<ItemSalesEntry> _items = [];
  bool _loading = true;
  bool _sortByQty = true; // true = qty desc, false = revenue desc

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _money(int cents) => formatMoney(cents);

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      List<ItemSalesEntry> items;
      if (_range == _ProdRange.daily) {
        final resp = await PosClient.instance.stub.getDailyReport(
          DailyReportRequest()..date = _fmt(_selectedDate),
        );
        items = List.from(resp.report.itemSales);
      } else {
        final dates = _computeDateRange();
        final resp = await PosClient.instance.stub.getDateRangeReport(
          DateRangeReportRequest()
            ..startDate = _fmt(dates.start)
            ..endDate = _fmt(dates.end),
        );
        items = List.from(resp.summary.itemSales);
      }
      _sortItems(items);
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _msg('Failed to load: $e', Colors.red);
    }
  }

  void _sortItems(List<ItemSalesEntry> items) {
    if (_sortByQty) {
      items.sort((a, b) => b.quantitySold.compareTo(a.quantitySold));
    } else {
      items.sort((a, b) => b.revenueCents.compareTo(a.revenueCents));
    }
  }

  DateTimeRange _computeDateRange() {
    final now = DateTime.now();
    switch (_range) {
      case _ProdRange.weekly:
        final start = now.subtract(Duration(days: now.weekday - 1));
        return DateTimeRange(
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ProdRange.monthly:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ProdRange.yearly:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, now.month, now.day),
        );
      case _ProdRange.custom:
        return _customRange ?? DateTimeRange(start: now, end: now);
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
      _load();
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
      _load();
    }
  }

  void _msg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Top bar ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SegmentedButton<_ProdRange>(
                segments: const [
                  ButtonSegment(value: _ProdRange.daily, label: Text('Daily')),
                  ButtonSegment(
                    value: _ProdRange.weekly,
                    label: Text('Weekly'),
                  ),
                  ButtonSegment(
                    value: _ProdRange.monthly,
                    label: Text('Monthly'),
                  ),
                  ButtonSegment(
                    value: _ProdRange.yearly,
                    label: Text('Yearly'),
                  ),
                  ButtonSegment(
                    value: _ProdRange.custom,
                    label: Text('Custom'),
                  ),
                ],
                selected: {_range},
                onSelectionChanged: (sel) {
                  setState(() => _range = sel.first);
                  if (_range == _ProdRange.custom) {
                    _pickCustomRange();
                  } else {
                    _load();
                  }
                },
              ),
              const SizedBox(width: 12),
              if (_range == _ProdRange.daily)
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(_fmt(_selectedDate)),
                ),
              if (_range == _ProdRange.custom && _customRange != null)
                OutlinedButton.icon(
                  onPressed: _pickCustomRange,
                  icon: const Icon(Icons.date_range, size: 16),
                  label: Text(
                    '${_fmt(_customRange!.start)} — ${_fmt(_customRange!.end)}',
                  ),
                ),
              const Spacer(),
              IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: const EdgeInsets.all(12),
                iconSize: 24,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: _load,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // ── Body ──────────────────────────────────────────
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _items.isEmpty
                  ? const Center(
                      child: Text(
                        'No item sales data for this period',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : _buildTable(),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Menu Productivity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(width: 16),
              Text(
                '${_items.length} items',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('By Quantity')),
                  ButtonSegment(value: false, label: Text('By Revenue')),
                ],
                selected: {_sortByQty},
                onSelectionChanged: (sel) {
                  setState(() {
                    _sortByQty = sel.first;
                    _sortItems(_items);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Qty Sold'), numeric: true),
                DataColumn(label: Text('Revenue'), numeric: true),
              ],
              rows: List.generate(_items.length, (i) {
                final e = _items[i];
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        '${i + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(Text(e.itemName)),
                    DataCell(Text('${e.quantitySold}')),
                    DataCell(Text(_money(e.revenueCents))),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
