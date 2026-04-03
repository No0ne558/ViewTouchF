import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../generated/pos_service.pbgrpc.dart';
import '../services/pos_client.dart';
import 'touchscreen_keyboard.dart';

class AdminSettingsTab extends StatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  State<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends State<AdminSettingsTab> {
  final _nameCtrl = TextEditingController();
  final _taxCtrl = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  // Printer state
  List<PrinterInfo> _availablePrinters = [];
  String _receiptPrinterName = '';
  bool _receiptPrinterEnabled = false;
  String _kitchenPrinterName = '';
  bool _kitchenPrinterEnabled = false;
  bool _loadingPrinters = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadSettings(), _loadPrinters()]);
  }

  Future<void> _loadSettings() async {
    try {
      final resp = await PosClient.instance.stub.getSettings(GetSettingsRequest());
      final s = resp.settings;
      _nameCtrl.text = s.restaurantName;
      _taxCtrl.text = (s.taxRateBps / 100.0).toStringAsFixed(2);
      _receiptPrinterName = s.receiptPrinterName;
      _receiptPrinterEnabled = s.receiptPrinterEnabled;
      _kitchenPrinterName = s.kitchenPrinterName;
      _kitchenPrinterEnabled = s.kitchenPrinterEnabled;
      setState(() => _loading = false);
    } catch (e) {
      setState(() => _loading = false);
      _showSnack('Failed to load settings: $e', error: true);
    }
  }

  Future<void> _loadPrinters() async {
    setState(() => _loadingPrinters = true);
    try {
      final resp = await PosClient.instance.stub.listPrinters(ListPrintersRequest());
      setState(() {
        _availablePrinters = resp.printers.toList();
        _loadingPrinters = false;
      });
    } catch (e) {
      setState(() => _loadingPrinters = false);
      _showSnack('Failed to list printers: $e', error: true);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final taxPercent = double.tryParse(_taxCtrl.text) ?? 0;
      final taxBps = (taxPercent * 100).round();

      final req = UpdateSettingsRequest()
        ..settings = (Settings()
          ..restaurantName = _nameCtrl.text.trim()
          ..taxRateBps = taxBps
          ..receiptPrinterName = _receiptPrinterName
          ..receiptPrinterEnabled = _receiptPrinterEnabled
          ..kitchenPrinterName = _kitchenPrinterName
          ..kitchenPrinterEnabled = _kitchenPrinterEnabled);

      await PosClient.instance.stub.updateSettings(req);
      _showSnack('Settings saved');
    } catch (e) {
      _showSnack('Save failed: $e', error: true);
    } finally {
      setState(() => _saving = false);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  Widget _buildPrinterTarget({
    required String label,
    required IconData icon,
    required bool enabled,
    required String selectedPrinter,
    required ValueChanged<bool> onEnabledChanged,
    required ValueChanged<String> onPrinterChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Switch(
                  value: enabled,
                  onChanged: onEnabledChanged,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _availablePrinters.any((p) => p.name == selectedPrinter)
                  ? selectedPrinter
                  : null,
              decoration: InputDecoration(
                labelText: '$label Name',
                border: const OutlineInputBorder(),
                enabled: enabled,
              ),
              items: _availablePrinters.map((p) {
                return DropdownMenuItem(
                  value: p.name,
                  child: Text(p.description.isNotEmpty
                      ? '${p.name} — ${p.description}'
                      : p.name),
                );
              }).toList(),
              onChanged: enabled
                  ? (val) {
                      if (val != null) onPrinterChanged(val);
                    }
                  : null,
              hint: const Text('Select printer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Restaurant Settings',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TouchTextField(
              controller: _nameCtrl,
              dialogTitle: 'Restaurant Name',
              decoration: const InputDecoration(
                labelText: 'Restaurant Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),
            TouchTextField(
              controller: _taxCtrl,
              dialogTitle: 'Tax Rate (%)',
              numericOnly: true,
              decoration: const InputDecoration(
                labelText: 'Tax Rate (%)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.percent),
                hintText: '8.25',
              ),
            ),
            const SizedBox(height: 32),

            // ── Printer Section ──
            Row(
              children: [
                Text('Printers',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(width: 12),
                if (_loadingPrinters)
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _loadPrinters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_availablePrinters.isEmpty && !_loadingPrinters)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No CUPS printers found on this system.'),
                ),
              ),
            _buildPrinterTarget(
              label: 'Receipt Printer',
              icon: Icons.receipt_long,
              enabled: _receiptPrinterEnabled,
              selectedPrinter: _receiptPrinterName,
              onEnabledChanged: (v) =>
                  setState(() => _receiptPrinterEnabled = v),
              onPrinterChanged: (v) =>
                  setState(() => _receiptPrinterName = v),
            ),
            const SizedBox(height: 12),
            _buildPrinterTarget(
              label: 'Kitchen Printer',
              icon: Icons.restaurant,
              enabled: _kitchenPrinterEnabled,
              selectedPrinter: _kitchenPrinterName,
              onEnabledChanged: (v) =>
                  setState(() => _kitchenPrinterEnabled = v),
              onPrinterChanged: (v) =>
                  setState(() => _kitchenPrinterName = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
