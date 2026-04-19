import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewtouch_ui/generated/app_localizations.dart';
import '../generated/pos_service.pb.dart';
import '../generated/pos_service.pbgrpc.dart';
import '../services/pos_client.dart';
import '../services/locale_provider.dart';
import 'touchscreen_keyboard.dart';
// Touch mode is always enabled on touchscreen-first devices; no provider.

class AdminSettingsTab extends StatefulWidget {
  const AdminSettingsTab({super.key});

  @override
  State<AdminSettingsTab> createState() => _AdminSettingsTabState();
}

class _AdminSettingsTabState extends State<AdminSettingsTab> {
  final _nameCtrl = TextEditingController();
  final _taxCtrl = TextEditingController();
  final _ccFeeCentsCtrl = TextEditingController();
  final _ccFeePctCtrl = TextEditingController();
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
    _ccFeeCentsCtrl.dispose();
    _ccFeePctCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadSettings(), _loadPrinters()]);
  }

  Future<void> _loadSettings() async {
    try {
      final resp = await PosClient.instance.stub.getSettings(
        GetSettingsRequest(),
      );
      final s = resp.settings;
      _nameCtrl.text = s.restaurantName;
      _taxCtrl.text = (s.taxRateBps / 100.0).toStringAsFixed(2);
      _receiptPrinterName = s.receiptPrinterName;
      _receiptPrinterEnabled = s.receiptPrinterEnabled;
      _kitchenPrinterName = s.kitchenPrinterName;
      _kitchenPrinterEnabled = s.kitchenPrinterEnabled;
      _ccFeeCentsCtrl.text =
          s.ccFeeCents > 0 ? (s.ccFeeCents / 100.0).toStringAsFixed(2) : '';
      _ccFeePctCtrl.text =
          s.ccFeeBps > 0 ? (s.ccFeeBps / 100.0).toStringAsFixed(2) : '';
      setState(() => _loading = false);
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      _showSnack(
        AppLocalizations.of(context)!.cannotConnectToDaemon,
        error: true,
      );
    }
  }

  Future<void> _loadPrinters() async {
    setState(() => _loadingPrinters = true);
    try {
      final resp = await PosClient.instance.stub.listPrinters(
        ListPrintersRequest(),
      );
      setState(() {
        _availablePrinters = resp.printers.toList();
        _loadingPrinters = false;
      });
    } catch (e) {
      setState(() => _loadingPrinters = false);
      if (!mounted) return;
      _showSnack(
        AppLocalizations.of(context)!.cannotConnectToDaemon,
        error: true,
      );
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final taxPercent = double.tryParse(_taxCtrl.text) ?? 0;
      final taxBps = (taxPercent * 100).round();
      final ccDollars = double.tryParse(_ccFeeCentsCtrl.text) ?? 0;
      final ccCents = (ccDollars * 100).round();
      final ccPct = double.tryParse(_ccFeePctCtrl.text) ?? 0;
      final ccBps = (ccPct * 100).round();

      final req = UpdateSettingsRequest()
        ..settings = (Settings()
          ..restaurantName = _nameCtrl.text.trim()
          ..taxRateBps = taxBps
          ..receiptPrinterName = _receiptPrinterName
          ..receiptPrinterEnabled = _receiptPrinterEnabled
          ..kitchenPrinterName = _kitchenPrinterName
          ..kitchenPrinterEnabled = _kitchenPrinterEnabled
          ..ccFeeCents = ccCents
          ..ccFeeBps = ccBps);

      await PosClient.instance.stub.updateSettings(req);
      if (!mounted) return;
      _showSnack(AppLocalizations.of(context)!.saveSettings);
    } catch (e) {
      if (!mounted) return;
      _showSnack(AppLocalizations.of(context)!.saveFailed, error: true);
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

  Future<void> _shutdown() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.shutdownSystem),
        content: Text(
          '${AppLocalizations.of(ctx)!.shutdownSystem}\n\n${AppLocalizations.of(ctx)!.retry}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.power_settings_new),
            label: Text(AppLocalizations.of(ctx)!.shutdown),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await PosClient.instance.stub.shutdown(ShutdownRequest());
    } catch (_) {
      // The daemon may close the connection before responding — that's OK.
    }
    // Close the Flutter UI.
    exit(0);
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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(value: enabled, onChanged: onEnabledChanged),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue:
                  _availablePrinters.any((p) => p.name == selectedPrinter)
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
                  child: Text(
                    p.description.isNotEmpty
                        ? '${p.name} — ${p.description}'
                        : p.name,
                  ),
                );
              }).toList(),
              onChanged: enabled
                  ? (val) {
                      if (val != null) onPrinterChanged(val);
                    }
                  : null,
              hint: Text(AppLocalizations.of(context)!.selectPrinter),
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
            Text(
              AppLocalizations.of(context)!.restaurantSettings,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue:
                  Provider.of<LocaleProvider>(context).locale?.languageCode ??
                      'en',
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.language,
                border: const OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
              ],
              onChanged: (val) {
                if (val != null) {
                  Provider.of<LocaleProvider>(
                    context,
                    listen: false,
                  ).setLocale(Locale(val));
                }
              },
            ),
            const SizedBox(height: 16),
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

            // ── Credit Card Fee Section ──
            Text(
              'Credit Card Fee',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Set a flat dollar amount, a percentage, or both. '
              'The fee is added to the total when the customer pays by card.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TouchTextField(
                    controller: _ccFeeCentsCtrl,
                    dialogTitle: 'CC Fee (\$)',
                    numericOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Flat Fee (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: '0.50',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TouchTextField(
                    controller: _ccFeePctCtrl,
                    dialogTitle: 'CC Fee (%)',
                    numericOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Percentage (%)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent),
                      hintText: '3.00',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Printer Section ──
            Row(
              children: [
                Text(
                  'Printers',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 12),
                if (_loadingPrinters)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _loadPrinters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(AppLocalizations.of(context)!.refresh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_availablePrinters.isEmpty && !_loadingPrinters)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context)!.noCupsPrinters),
                ),
              ),
            _buildPrinterTarget(
              label: AppLocalizations.of(context)!.receiptPrinter,
              icon: Icons.receipt_long,
              enabled: _receiptPrinterEnabled,
              selectedPrinter: _receiptPrinterName,
              onEnabledChanged: (v) =>
                  setState(() => _receiptPrinterEnabled = v),
              onPrinterChanged: (v) => setState(() => _receiptPrinterName = v),
            ),
            const SizedBox(height: 12),
            _buildPrinterTarget(
              label: AppLocalizations.of(context)!.kitchenPrinter,
              icon: Icons.restaurant,
              enabled: _kitchenPrinterEnabled,
              selectedPrinter: _kitchenPrinterName,
              onEnabledChanged: (v) =>
                  setState(() => _kitchenPrinterEnabled = v),
              onPrinterChanged: (v) => setState(() => _kitchenPrinterName = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(AppLocalizations.of(context)!.saveSettings),
              ),
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: _shutdown,
                icon: const Icon(Icons.power_settings_new),
                label: Text(AppLocalizations.of(context)!.shutdownSystem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
