import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';
import '../widgets/menu_grid.dart';
import '../widgets/ticket_panel.dart';
import 'admin_screen.dart';

/// The main register screen — split into a menu grid (left) and the
/// current ticket (right).  Landscape-oriented for POS terminals.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<MenuItem> _menu = [];
  Ticket? _ticket;
  bool _loading = true;
  String? _error;
  String _restaurantName = 'ViewTouch POS';
  bool _isFullscreen = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final menuResp = await PosClient.instance.stub.getMenu(GetMenuRequest());
      final ticketResp = await PosClient.instance.stub.newTicket(NewTicketRequest());
      final settingsResp = await PosClient.instance.stub.getSettings(GetSettingsRequest());
      if (!mounted) return;
      setState(() {
        _menu = menuResp.items;
        _ticket = ticketResp.ticket;
        _restaurantName = settingsResp.settings.restaurantName.isNotEmpty
            ? settingsResp.settings.restaurantName
            : 'ViewTouchF';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _refreshMenu() async {
    try {
      final menuResp = await PosClient.instance.stub.getMenu(GetMenuRequest());
      final settingsResp = await PosClient.instance.stub.getSettings(GetSettingsRequest());
      if (!mounted) return;
      setState(() {
        _menu = menuResp.items;
        _restaurantName = settingsResp.settings.restaurantName.isNotEmpty
            ? settingsResp.settings.restaurantName
            : 'ViewTouchF';
      });
    } catch (_) {}
  }

  Future<void> _openAdmin() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AdminScreen()),
    );
    _refreshMenu();
  }

  Future<void> _addItem(MenuItem item) async {
    if (_ticket == null) return;

    // If the item has modifier groups, show the modifier dialog first.
    List<AppliedModifier> mods = [];
    if (item.modifierGroups.isNotEmpty) {
      final result = await _showModifierDialog(item);
      if (result == null) return; // user cancelled
      mods = result;
    }

    try {
      final req = AddItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = item.id
        ..quantity = 1;
      req.modifiers.addAll(mods);
      final resp = await PosClient.instance.stub.addItem(req);
      setState(() => _ticket = resp.ticket);
    } catch (e) {
      _showError('Failed to add item: $e');
    }
  }

  Future<void> _increaseItem(TicketItem ti) async {
    if (_ticket == null) return;
    try {
      final req = AddItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = ti.item.id
        ..quantity = 1;
      // Pass same modifiers so it matches the same line_key.
      req.modifiers.addAll(ti.modifiers);
      final resp = await PosClient.instance.stub.addItem(req);
      setState(() => _ticket = resp.ticket);
    } catch (e) {
      _showError('Failed to increase item: $e');
    }
  }

  Future<List<AppliedModifier>?> _showModifierDialog(MenuItem item) async {
    return showDialog<List<AppliedModifier>>(
      context: context,
      builder: (ctx) => _ModifierDialog(item: item),
    );
  }

  Future<void> _decreaseItem(TicketItem ti) async {
    if (_ticket == null) return;
    try {
      final req = DecreaseItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = ti.item.id
        ..lineKey = ti.lineKey;
      final resp = await PosClient.instance.stub.decreaseItem(req);
      setState(() => _ticket = resp.ticket);
    } catch (e) {
      _showError('Failed to decrease item: $e');
    }
  }

  Future<void> _checkout() async {
    if (_ticket == null || _ticket!.items.isEmpty) return;
    final result = await showDialog<_CheckoutResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CheckoutDialog(ticket: _ticket!),
    );
    if (result == null) return; // cancelled

    try {
      final req = CheckoutRequest()..ticketId = _ticket!.id;
      for (final p in result.payments) {
        req.payments.add(Payment()
          ..paymentType = p.type
          ..amountCents = p.amount);
      }
      final resp = await PosClient.instance.stub.checkout(req);
      if (!resp.success) {
        _showError(resp.error);
        return;
      }
      // Show change due if any.
      if (resp.ticket.changeDue > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Change due: \$${(resp.ticket.changeDue / 100).toStringAsFixed(2)}'),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
      // Print receipt
      _printReceipt(resp.ticket);
      // Print kitchen ticket (if enabled)
      _printKitchen(resp.ticket);
      // Open a new ticket for the next customer.
      final newT = await PosClient.instance.stub.newTicket(NewTicketRequest());
      setState(() => _ticket = newT.ticket);
    } catch (e) {
      _showError('Checkout failed: $e');
    }
  }

  Future<void> _printReceipt(Ticket ticket) async {
    try {
      final req = PrintReceiptRequest()..ticketId = ticket.id;
      final resp = await PosClient.instance.stub.printReceipt(req);
      if (!resp.success) {
        _showError('Print error: ${resp.error}');
      }
    } catch (e) {
      _showError('Print error: $e');
    }
  }

  Future<void> _printKitchen(Ticket ticket) async {
    try {
      // Check if kitchen printer is enabled via settings
      final settings = await PosClient.instance.stub.getSettings(GetSettingsRequest());
      if (!settings.settings.kitchenPrinterEnabled) return;
      final req = PrintKitchenRequest()..ticketId = ticket.id;
      final resp = await PosClient.instance.stub.printKitchen(req);
      if (!resp.success) {
        _showError('Kitchen print error: ${resp.error}');
      }
    } catch (e) {
      _showError('Kitchen print error: $e');
    }
  }

  Future<void> _showPastOrders() async {
    await showDialog(
      context: context,
      builder: (ctx) => const _PastOrdersDialog(),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Cannot connect to POS daemon',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SelectableText(_error!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  setState(() { _loading = true; _error = null; });
                  _bootstrap();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_restaurantName),
        centerTitle: false,
        actions: [
          Text('Ticket: ${_ticket?.id ?? "—"}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Past Orders',
            onPressed: _showPastOrders,
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin',
            onPressed: _openAdmin,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // ── Left: Menu grid (≈65% width) ──────────────────
          Expanded(
            flex: 65,
            child: MenuGrid(
              items: _menu,
              onItemTap: _addItem,
            ),
          ),
          const VerticalDivider(width: 1),
          // ── Right: Current ticket (≈35% width) ────────────
          Expanded(
            flex: 35,
            child: TicketPanel(
              ticket: _ticket,
              onCheckout: _checkout,
              onDecreaseItem: _decreaseItem,
              onIncreaseItem: _increaseItem,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Modifier Selection Dialog ─────────────────────────────────

class _ModifierDialog extends StatefulWidget {
  final MenuItem item;
  const _ModifierDialog({required this.item});

  @override
  State<_ModifierDialog> createState() => _ModifierDialogState();
}

class _ModifierDialogState extends State<_ModifierDialog> {
  // Tracks the chosen action for each modifier by modifier id.
  // null / absent = no action (keep default as-is, skip non-default).
  final Map<String, ModifierAction> _selections = {};

  @override
  void initState() {
    super.initState();
    // Pre-select defaults: for single-select groups with a default,
    // set the default modifier to MOD_ADD so the user sees it selected.
    for (final group in widget.item.modifierGroups) {
      if (group.maxSelect == 1) {
        for (final mod in group.modifiers) {
          if (mod.isDefault) {
            _selections[mod.id] = ModifierAction.MOD_ADD;
          }
        }
      }
    }
  }

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

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  List<AppliedModifier> _buildModifiers() {
    final result = <AppliedModifier>[];
    for (final group in widget.item.modifierGroups) {
      for (final mod in group.modifiers) {
        final action = _selections[mod.id];
        if (action == null) continue;

        // Skip "ADD" on defaults — they're already included.
        if (mod.isDefault && action == ModifierAction.MOD_ADD) continue;

        int priceAdj = 0;
        if (action == ModifierAction.MOD_ADD) {
          priceAdj = mod.priceCents;
        } else if (action == ModifierAction.MOD_EXTRA) {
          priceAdj = mod.priceCents; // one extra charge
        } else if (action == ModifierAction.MOD_DOUBLE) {
          priceAdj = mod.priceCents * 2; // 2× the modifier price
        } else if (action == ModifierAction.MOD_SIDE && !mod.isDefault) {
          priceAdj = mod.priceCents; // adding it on the side still costs
        }
        // NO, LIGHT, SIDE-on-default are free.

        result.add(AppliedModifier()
          ..modifierId = mod.id
          ..modifierName = mod.name
          ..action = action
          ..priceAdjustmentCents = priceAdj);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.name,
          style: Theme.of(context).textTheme.headlineSmall),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final group in widget.item.modifierGroups) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    group.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold),
                  ),
                ),
                if (group.maxSelect == 1)
                  _buildSingleSelect(group)
                else
                  _buildMultiSelect(group),
              ],
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
        ),
        SizedBox(
          height: 48,
          width: 180,
          child: FilledButton(
            onPressed: () => Navigator.pop(context, _buildModifiers()),
            child: const Text('Add to Order', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  /// Single-select group (e.g. Cooking Temp) — radio buttons.
  Widget _buildSingleSelect(ModifierGroup group) {
    return Column(
      children: [
        for (final mod in group.modifiers)
          RadioListTile<String>(
            title: Text(mod.name, style: const TextStyle(fontSize: 16)),
            subtitle: mod.priceCents > 0
                ? Text('+${_money(mod.priceCents)}',
                    style: const TextStyle(color: Colors.green, fontSize: 14))
                : null,
            secondary: mod.isDefault
                ? const Chip(label: Text('Default', style: TextStyle(fontSize: 12)))
                : null,
            value: mod.id,
            groupValue: _getRadioValue(group),
            dense: false,
            onChanged: (val) {
              setState(() {
                // Clear all in group, set selected one.
                for (final m in group.modifiers) {
                  _selections.remove(m.id);
                }
                if (val != null) {
                  _selections[val] = ModifierAction.MOD_ADD;
                }
              });
            },
          ),
      ],
    );
  }

  String? _getRadioValue(ModifierGroup group) {
    for (final mod in group.modifiers) {
      if (_selections[mod.id] == ModifierAction.MOD_ADD) return mod.id;
    }
    return null;
  }

  /// Multi-select group (e.g. Toppings) — each modifier gets action chips.
  Widget _buildMultiSelect(ModifierGroup group) {
    return Column(
      children: [
        for (final mod in group.modifiers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mod.name,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                      if (mod.isDefault)
                        const Text('Included',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      if (!mod.isDefault && mod.priceCents > 0)
                        Text('+${_money(mod.priceCents)}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.green)),
                    ],
                  ),
                ),
                if (mod.isDefault)
                  _actionChip(mod, ModifierAction.MOD_NO, 'NO', Colors.red),
                if (!mod.isDefault)
                  _actionChip(mod, ModifierAction.MOD_ADD, 'ADD', Colors.green),
                _actionChip(mod, ModifierAction.MOD_EXTRA, 'EXTRA', Colors.orange),
                if (mod.isDefault)
                  _actionChip(mod, ModifierAction.MOD_LIGHT, 'LIGHT', Colors.blue),
                _actionChip(mod, ModifierAction.MOD_SIDE, 'SIDE', Colors.purple),
                _actionChip(mod, ModifierAction.MOD_DOUBLE, 'DBL', Colors.deepOrange),
              ],
            ),
          ),
      ],
    );
  }

  Widget _actionChip(
      Modifier mod, ModifierAction action, String label, Color color) {
    final isSelected = _selections[mod.id] == action;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 14,
            color: isSelected ? Colors.white : color)),
        selected: isSelected,
        selectedColor: color,
        visualDensity: VisualDensity.standard,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selections[mod.id] = action;
            } else {
              _selections.remove(mod.id);
            }
          });
        },
      ),
    );
  }
}

// ── Checkout Dialog ── Split payment with keypad ──────────────

class _PaymentLeg {
  final String type;
  final int amount;
  _PaymentLeg(this.type, this.amount);
}

class _CheckoutResult {
  final List<_PaymentLeg> payments;
  _CheckoutResult(this.payments);
}

class _CheckoutDialog extends StatefulWidget {
  final Ticket ticket;
  const _CheckoutDialog({required this.ticket});

  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  String _input = '';
  final List<_PaymentLeg> _payments = [];

  int get _totalDue => widget.ticket.total;
  int get _paidSoFar => _payments.fold(0, (s, p) => s + p.amount);
  int get _remaining => _totalDue - _paidSoFar;

  int get _inputCents {
    if (_input.isEmpty) return 0;
    final d = double.tryParse(_input);
    if (d == null) return 0;
    return (d * 100).round();
  }

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  void _appendDigit(String d) {
    setState(() {
      // Limit to 2 decimal places.
      if (_input.contains('.') && _input.split('.').last.length >= 2) return;
      _input += d;
    });
  }

  void _appendDot() {
    if (_input.contains('.')) return;
    setState(() => _input += _input.isEmpty ? '0.' : '.');
  }

  void _backspace() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _clear() => setState(() => _input = '');

  void _payExact() {
    setState(() => _input = (_remaining / 100).toStringAsFixed(2));
  }

  void _addPayment(String type) {
    int amount = _inputCents;
    if (amount <= 0) {
      // If nothing entered, assume paying the remaining balance.
      amount = _remaining;
    }
    if (amount <= 0) return;
    setState(() {
      _payments.add(_PaymentLeg(type, amount));
      _input = '';
    });
    // If fully paid, finalize.
    if (_paidSoFar >= _totalDue) {
      Navigator.pop(context, _CheckoutResult(_payments));
    }
  }

  void _undoLastPayment() {
    if (_payments.isEmpty) return;
    setState(() => _payments.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 820),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text('Checkout', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              // Amount due
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 22)),
                  Text(_money(_totalDue),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
              if (_payments.isNotEmpty) ...[
                const Divider(),
                // Show partial payments made.
                for (final p in _payments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${p.type} payment',
                          style: const TextStyle(fontSize: 14)),
                      Text(_money(p.amount),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.green)),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remaining:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Text(_money(_remaining > 0 ? _remaining : 0),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _remaining > 0
                                ? Colors.red.shade700
                                : Colors.green.shade700)),
                  ],
                ),
                TextButton.icon(
                  onPressed: _undoLastPayment,
                  icon: const Icon(Icons.undo, size: 16),
                  label: const Text('Undo last payment'),
                ),
              ],
              const SizedBox(height: 8),
              // Input display
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _input.isEmpty ? '0.00' : _input,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 40, fontFamily: 'RobotoMono'),
                ),
              ),
              const SizedBox(height: 8),
              // Keypad
              Expanded(
                child: _buildKeypad(),
              ),
              const SizedBox(height: 8),
              // Pay buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: FilledButton.icon(
                        onPressed: _remaining > 0
                            ? () => _addPayment('CASH')
                            : null,
                        icon: const Icon(Icons.payments, size: 28),
                        label: const Text('CASH',
                            style: TextStyle(fontSize: 20)),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.green.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: FilledButton.icon(
                        onPressed: _remaining > 0
                            ? () => _addPayment('CARD')
                            : null,
                        icon: const Icon(Icons.credit_card, size: 28),
                        label: const Text('CARD',
                            style: TextStyle(fontSize: 20)),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue.shade700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
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

  Widget _buildKeypad() {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];
    return Column(
      children: [
        // Quick-amount row
        Row(
          children: [
            _quickBtn('Exact', _payExact),
            const SizedBox(width: 6),
            _quickBtn('Clear', _clear),
          ],
        ),
        const SizedBox(height: 6),
        ...buttons.map((row) {
          return Expanded(
            child: Row(
              children: row.map((label) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          if (label == '⌫') {
                            _backspace();
                          } else if (label == '.') {
                            _appendDot();
                          } else {
                            _appendDigit(label);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(label,
                            style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _quickBtn(String label, VoidCallback onPressed) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

// ── Past Orders Dialog ────────────────────────────────────────

class _PastOrdersDialog extends StatefulWidget {
  const _PastOrdersDialog();

  @override
  State<_PastOrdersDialog> createState() => _PastOrdersDialogState();
}

class _PastOrdersDialogState extends State<_PastOrdersDialog> {
  List<Ticket> _tickets = [];
  bool _loading = true;
  String? _error;
  String _statusFilter = ''; // all

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() { _loading = true; _error = null; });
    try {
      final resp = await PosClient.instance.stub.listTickets(
        ListTicketsRequest()
          ..date = '' // today
          ..status = _statusFilter,
      );
      setState(() {
        _tickets = resp.tickets;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  String _time(dynamic epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
        epochMs is int ? epochMs : (epochMs as dynamic).toInt());
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${h.toString()}:${dt.minute.toString().padLeft(2, '0')} $ampm';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'CLOSED': return Colors.green;
      case 'VOIDED': return Colors.red;
      case 'COMPED': return Colors.orange;
      case 'REFUNDED': return Colors.purple;
      default: return Colors.blue;
    }
  }

  Future<void> _reprintTicket(Ticket t) async {
    try {
      final resp = await PosClient.instance.stub.printReceipt(
        PrintReceiptRequest()..ticketId = t.id,
      );
      if (!resp.success) {
        _showMsg('Print error: ${resp.error}', Colors.red);
      } else {
        _showMsg('Receipt reprinted (Job #${resp.jobId})', Colors.green);
      }
    } catch (e) {
      _showMsg('Print error: $e', Colors.red);
    }
  }

  Future<void> _ticketAction(Ticket t, String action) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => _ReasonDialog(action: action, ticketId: t.id),
    );
    if (reason == null) return; // cancelled

    try {
      final resp = await PosClient.instance.stub.ticketAction(
        TicketActionRequest()
          ..ticketId = t.id
          ..action = action
          ..reason = reason,
      );
      if (!resp.success) {
        _showMsg('${action} failed: ${resp.error}', Colors.red);
      } else {
        _showMsg('Ticket ${t.id} ${action.toLowerCase()}ed', Colors.green);
        _loadTickets(); // refresh
      }
    } catch (e) {
      _showMsg('$action failed: $e', Colors.red);
    }
  }

  void _showMsg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text("Today's Orders",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadTickets,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Filter chips
              Wrap(
                spacing: 8,
                children: [
                  _filterChip('All', ''),
                  _filterChip('Closed', 'CLOSED'),
                  _filterChip('Voided', 'VOIDED'),
                  _filterChip('Comped', 'COMPED'),
                  _filterChip('Refunded', 'REFUNDED'),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              // Ticket list
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text('Error: $_error'))
                        : _tickets.isEmpty
                            ? const Center(
                                child: Text('No orders found',
                                    style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                itemCount: _tickets.length,
                                itemBuilder: (ctx, i) =>
                                    _buildTicketTile(_tickets[i]),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _statusFilter == value,
      onSelected: (_) {
        setState(() => _statusFilter = value);
        _loadTickets();
      },
    );
  }

  Widget _buildTicketTile(Ticket t) {
    final itemSummary = t.items
        .map((i) => '${i.quantity}x ${i.item.name}')
        .join(', ');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Chip(
          label: Text(t.status,
              style: const TextStyle(fontSize: 11, color: Colors.white)),
          backgroundColor: _statusColor(t.status),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
        title: Text('#${t.id}  ${_money(t.total)}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${_time(t.createdAt)}  $itemSummary',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          // Item details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in t.items) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            '${item.quantity}x ${item.item.name}'),
                      ),
                      Text(_money(item.item.priceCents * item.quantity +
                          item.modifiers.fold(0, (s, m) => s + m.priceAdjustmentCents))),
                    ],
                  ),
                  for (final m in item.modifiers)
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        '${m.action.name.replaceFirst("MOD_", "")} ${m.modifierName}'
                        '${m.priceAdjustmentCents != 0 ? "  ${_money(m.priceAdjustmentCents)}" : ""}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
                if (t.payments.isNotEmpty) ...[
                  const Divider(),
                  for (final p in t.payments)
                    Row(
                      children: [
                        Text('${p.paymentType} payment'),
                        const Spacer(),
                        Text(_money(p.amountCents)),
                      ],
                    ),
                  if (t.changeDue > 0)
                    Row(
                      children: [
                        const Text('Change',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        const Spacer(),
                        Text(_money(t.changeDue),
                            style: const TextStyle(
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                ],
              ],
            ),
          ),
          const Divider(),
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 12),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _reprintTicket(t),
                  icon: const Icon(Icons.print, size: 18),
                  label: const Text('Reprint'),
                ),
                const SizedBox(width: 8),
                if (t.status == 'CLOSED') ...[
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'VOID'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red),
                    child: const Text('VOID'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'COMP'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange),
                    child: const Text('COMP'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'REFUND'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple),
                    child: const Text('REFUND'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reason Dialog (for VOID / COMP / REFUND) ──────────────────

class _ReasonDialog extends StatefulWidget {
  final String action;
  final String ticketId;
  const _ReasonDialog({required this.action, required this.ticketId});

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.action} Ticket #${widget.ticketId}'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Reason (optional)',
          hintText: 'e.g. Customer complaint',
        ),
        autofocus: true,
        onSubmitted: (_) => Navigator.pop(context, _controller.text),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.action),
        ),
      ],
    );
  }
}
