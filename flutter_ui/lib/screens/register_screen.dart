import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:viewtouch_ui/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';
import '../utils/money.dart';
import '../widgets/menu_grid.dart';
import '../widgets/ticket_panel.dart';
import '../widgets/touchscreen_keyboard.dart';
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
  // Use a ValueNotifier for the ticket so we can update only the ticket
  // subtree when it changes, avoiding full-screen rebuilds on every update.
  final ValueNotifier<Ticket?> _ticketNotifier = ValueNotifier<Ticket?>(null);
  Ticket? get _ticket => _ticketNotifier.value;
  bool _loading = true;
  String? _error;
  String _restaurantName = '';
  int _phoneOrderCount = 0;
  // Category switching
  List<String> _categories = [];
  int _selectedCategoryIndex = 0; // 0 == All

  @override
  void initState() {
    super.initState();
    _categoryController = ScrollController();
    _bootstrap();
  }

  late ScrollController _categoryController;
  PointerDeviceKind? _categoryPointerKind;

  Future<void> _bootstrap() async {
    try {
      final menuResp = await PosClient.instance.stub.getMenu(GetMenuRequest());
      final ticketResp = await PosClient.instance.stub.newTicket(
        NewTicketRequest(),
      );
      final settingsResp = await PosClient.instance.stub.getSettings(
        GetSettingsRequest(),
      );
      final phoneCountResp = await PosClient.instance.stub.getPhoneOrderCount(
        PhoneOrderCountRequest(),
      );
      if (!mounted) return;
      // Update menu and ticket separately; ticket is assigned to the
      // ValueNotifier so only widgets listening to it rebuild.
      setState(() {
        _menu = menuResp.items;
        _restaurantName = settingsResp.settings.restaurantName.isNotEmpty
            ? settingsResp.settings.restaurantName
            : (mounted ? AppLocalizations.of(context)!.appTitle : '');
        _phoneOrderCount = phoneCountResp.count;
        _loading = false;
      });
      _ticketNotifier.value = ticketResp.ticket;
      _updateCategories();
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
      final settingsResp = await PosClient.instance.stub.getSettings(
        GetSettingsRequest(),
      );
      final phoneCountResp = await PosClient.instance.stub.getPhoneOrderCount(
        PhoneOrderCountRequest(),
      );
      if (!mounted) return;
      setState(() {
        _menu = menuResp.items;
        _restaurantName = settingsResp.settings.restaurantName.isNotEmpty
            ? settingsResp.settings.restaurantName
            : (mounted ? AppLocalizations.of(context)!.appTitle : '');
        _phoneOrderCount = phoneCountResp.count;
      });
      _updateCategories();
    } catch (_) {}
  }

  void _updateCategories() {
    final seen = <String>{};
    final cats = <String>[];
    for (final item in _menu) {
      final c = item.category.trim();
      if (c.isEmpty) continue;
      if (!seen.contains(c)) {
        seen.add(c);
        cats.add(c);
      }
    }
    setState(() {
      _categories = cats;
      if (_selectedCategoryIndex > _categories.length) {
        _selectedCategoryIndex = 0;
      }
    });
  }

  Future<void> _refreshPhoneOrderCount() async {
    try {
      final resp = await PosClient.instance.stub.getPhoneOrderCount(
        PhoneOrderCountRequest(),
      );
      if (!mounted) return;
      setState(() => _phoneOrderCount = resp.count);
    } catch (_) {}
  }

  Future<void> _openAdmin() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
    _refreshMenu();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _ticketNotifier.dispose();
    super.dispose();
  }

  Future<void> _addItem(MenuItem item) async {
    if (_ticket == null) return;

    // If the item has modifier groups, show the modifier dialog first.
    List<AppliedModifier> mods = [];
    String specialInstructions = '';
    if (item.modifierGroups.isNotEmpty) {
      final result = await _showModifierDialog(item);
      if (result == null) return; // user cancelled
      mods = result.modifiers;
      specialInstructions = result.specialInstructions;
    }

    try {
      final req = AddItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = item.id
        ..quantity = 1
        ..specialInstructions = specialInstructions;
      req.modifiers.addAll(mods);
      final resp = await PosClient.instance.stub.addItem(req);
      _ticketNotifier.value = resp.ticket;
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.addItemFailed, error: true);
      // ignore: avoid_print
      print('addItem error: $e');
    }
  }

  Future<void> _increaseItem(TicketItem ti) async {
    if (_ticket == null) return;
    try {
      final req = AddItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = ti.item.id
        ..quantity = 1
        ..specialInstructions = ti.specialInstructions;
      // Pass same modifiers so it matches the same line_key.
      req.modifiers.addAll(ti.modifiers);
      final resp = await PosClient.instance.stub.addItem(req);
      _ticketNotifier.value = resp.ticket;
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.increaseItemFailed, error: true);
      // ignore: avoid_print
      print('increaseItem error: $e');
    }
  }

  Future<_ModifierResult?> _showModifierDialog(
    MenuItem item, {
    Map<String, ModifierAction>? initialSelections,
    String? initialSpecialInstructions,
    String confirmLabel = '',
  }) async {
    return showDialog<_ModifierResult>(
      context: context,
      builder: (ctx) => _ModifierDialog(
        item: item,
        initialSelections: initialSelections,
        initialSpecialInstructions: initialSpecialInstructions,
        confirmLabel: confirmLabel,
      ),
    );
  }

  Future<void> _editItem(TicketItem ti) async {
    if (_ticket == null) return;

    // Look up the full menu item (with modifier groups) from the loaded menu.
    final fullItem = _menu.cast<MenuItem?>().firstWhere(
          (m) => m!.id == ti.item.id,
          orElse: () => null,
        );
    if (fullItem == null || fullItem.modifierGroups.isEmpty) return;

    // Build initial selections from current modifiers.
    final initialSelections = <String, ModifierAction>{};
    for (final m in ti.modifiers) {
      initialSelections[m.modifierId] = m.action;
    }
    // Also restore default selections for single-select groups.
    for (final group in fullItem.modifierGroups) {
      if (group.maxSelect == 1) {
        for (final mod in group.modifiers) {
          if (mod.isDefault && !initialSelections.containsKey(mod.id)) {
            initialSelections[mod.id] = ModifierAction.MOD_ADD;
          }
        }
      }
    }

    final result = await _showModifierDialog(
      fullItem,
      initialSelections: initialSelections,
      initialSpecialInstructions: ti.specialInstructions,
      confirmLabel: AppLocalizations.of(context)!.updateItem,
    );
    if (result == null) return; // cancelled

    try {
      final req = UpdateItemRequest()
        ..ticketId = _ticket!.id
        ..lineKey = ti.lineKey
        ..specialInstructions = result.specialInstructions;
      req.modifiers.addAll(result.modifiers);
      final resp = await PosClient.instance.stub.updateItem(req);
      _ticketNotifier.value = resp.ticket;
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.updateItemFailed, error: true);
      // ignore: avoid_print
      print('updateItem error: $e');
    }
  }

  Future<void> _decreaseItem(TicketItem ti) async {
    if (_ticket == null) return;
    try {
      final req = DecreaseItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = ti.item.id
        ..lineKey = ti.lineKey;
      final resp = await PosClient.instance.stub.decreaseItem(req);
      _ticketNotifier.value = resp.ticket;
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.decreaseItemFailed, error: true);
      // ignore: avoid_print
      print('decreaseItem error: $e');
    }
  }

  Future<void> _removeItem(TicketItem ti) async {
    if (_ticket == null) return;
    try {
      final req = RemoveItemRequest()
        ..ticketId = _ticket!.id
        ..menuItemId = ti.item.id
        ..lineKey = ti.lineKey;
      final resp = await PosClient.instance.stub.removeItem(req);
      _ticketNotifier.value = resp.ticket;
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.removeItemFailed, error: true);
      // ignore: avoid_print
      print('removeItem error: $e');
    }
  }

  Future<void> _setItemQuantity(TicketItem ti, int newQty) async {
    if (_ticket == null) return;
    if (newQty <= 0) {
      _removeItem(ti);
      return;
    }
    final delta = newQty - ti.quantity;
    if (delta == 0) return;
    try {
      if (delta > 0) {
        // Add the difference.
        final req = AddItemRequest()
          ..ticketId = _ticket!.id
          ..menuItemId = ti.item.id
          ..quantity = delta
          ..specialInstructions = ti.specialInstructions;
        req.modifiers.addAll(ti.modifiers);
        final resp = await PosClient.instance.stub.addItem(req);
        _ticketNotifier.value = resp.ticket;
      } else {
        // Remove then re-add with the new quantity.
        final removeReq = RemoveItemRequest()
          ..ticketId = _ticket!.id
          ..menuItemId = ti.item.id
          ..lineKey = ti.lineKey;
        await PosClient.instance.stub.removeItem(removeReq);
        final addReq = AddItemRequest()
          ..ticketId = _ticket!.id
          ..menuItemId = ti.item.id
          ..quantity = newQty
          ..specialInstructions = ti.specialInstructions;
        addReq.modifiers.addAll(ti.modifiers);
        final resp = await PosClient.instance.stub.addItem(addReq);
        _ticketNotifier.value = resp.ticket;
      }
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.setQuantityFailed, error: true);
      // ignore: avoid_print
      print('setQuantity error: $e');
    }
  }

  Future<void> _checkout({bool skipPrint = false}) async {
    if (_ticket == null || _ticket!.items.isEmpty) return;
    final currentTicket = _ticketNotifier.value;
    if (currentTicket == null) return;
    final result = await showDialog<_CheckoutResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CheckoutDialog(ticket: currentTicket),
    );
    if (result == null) return; // cancelled

    try {
      final req = CheckoutRequest()
        ..ticketId = _ticket!.id
        ..ccFeeCents = result.ccFeeAmount;
      for (final p in result.payments) {
        req.payments.add(
          Payment()
            ..paymentType = p.type
            ..amountCents = p.amount,
        );
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
                '${AppLocalizations.of(context)!.changeDueLabel} ${formatMoney(resp.ticket.changeDue)}',
              ),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
      if (!skipPrint) {
        // Print receipt
        _printReceipt(resp.ticket);
        // Print kitchen ticket (if enabled)
        _printKitchen(resp.ticket);
      }
      // Open a new ticket for the next customer.
      final newT = await PosClient.instance.stub.newTicket(NewTicketRequest());
      if (!mounted) return;
      _ticketNotifier.value = newT.ticket;
      await _refreshPhoneOrderCount();
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.checkoutFailed, error: true);
      // ignore: avoid_print
      print('checkout error: $e');
    }
  }

  Future<void> _printReceipt(Ticket ticket) async {
    try {
      final req = PrintReceiptRequest()..ticketId = ticket.id;
      final resp = await PosClient.instance.stub.printReceipt(req);
      if (!resp.success) {
        if (!mounted) return;
        _showError(AppLocalizations.of(context)!.printError);
        // Log raw error for debugging
        // ignore: avoid_print
        print('printReceipt error: ${resp.error}');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.printError);
      // ignore: avoid_print
      print('printReceipt exception: $e');
    }
  }

  Future<void> _printKitchen(Ticket ticket) async {
    try {
      // Check if kitchen printer is enabled via settings
      final settings = await PosClient.instance.stub.getSettings(
        GetSettingsRequest(),
      );
      if (!settings.settings.kitchenPrinterEnabled) return;
      final req = PrintKitchenRequest()..ticketId = ticket.id;
      final resp = await PosClient.instance.stub.printKitchen(req);
      if (!resp.success) {
        if (!mounted) return;
        _showError(AppLocalizations.of(context)!.kitchenPrintError);
        // ignore: avoid_print
        print('printKitchen error: ${resp.error}');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.kitchenPrintError);
      // ignore: avoid_print
      print('printKitchen exception: $e');
    }
  }

  Future<void> _showPastOrders() async {
    await showDialog(
      context: context,
      builder: (ctx) => const _PastOrdersDialog(),
    );
  }

  Future<void> _showPhoneOrderDialog() async {
    if (_ticket == null || _ticket!.items.isEmpty) return;
    final result = await showDialog<_PhoneOrderInput>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _PhoneOrderDialog(),
    );
    if (result == null) return; // cancelled

    try {
      final req = CreatePhoneOrderRequest()
        ..ticketId = _ticket!.id
        ..customerName = result.name
        ..comment = result.comment;
      final resp = await PosClient.instance.stub.createPhoneOrder(req);
      if (!resp.success) {
        _showError(resp.error);
        return;
      }
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        final name = result.name.isNotEmpty ? result.name : loc.customerLabel;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.phoneOrderCreatedForName(name)),
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      // Open a new ticket for the next customer.
      final newT = await PosClient.instance.stub.newTicket(NewTicketRequest());
      if (!mounted) return;
      _ticketNotifier.value = newT.ticket;
      _refreshPhoneOrderCount();
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _showError(loc.operationFailed(loc.phoneOrderTitle), error: true);
      // ignore: avoid_print
      print('phoneOrder error: $e');
    }
  }

  Future<void> _showPhoneOrderList() async {
    final result = await showDialog<_PhoneOrderListResult>(
      context: context,
      builder: (ctx) => const _PhoneOrderListDialog(),
    );
    if (result == null) return;

    if (result.action == 'CHECKOUT') {
      // The ticket was restored as OPEN — load it and run checkout.
      try {
        final ticketResp = await PosClient.instance.stub.getTicket(
          GetTicketRequest()..ticketId = result.ticketId,
        );
        if (!mounted) return;
        _ticketNotifier.value = ticketResp.ticket;
        // Skip printing — receipt was already printed when the phone order was created.
        await _checkout(skipPrint: true);
        await _refreshPhoneOrderCount();
      } catch (e) {
        if (!mounted) return;
        _showError(
          AppLocalizations.of(context)!.loadPhoneOrderFailed,
          error: true,
        );
        // ignore: avoid_print
        print('loadPhoneOrder error: $e');
      }
    } else if (result.action == 'EDIT') {
      // The ticket was restored as OPEN — load it for editing.
      try {
        final ticketResp = await PosClient.instance.stub.getTicket(
          GetTicketRequest()..ticketId = result.ticketId,
        );
        if (!mounted) return;
        _ticketNotifier.value = ticketResp.ticket;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.phoneOrderLoadedForEditing,
              ),
              backgroundColor: Colors.blue.shade700,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        _showError(
          AppLocalizations.of(context)!.loadPhoneOrderFailed,
          error: true,
        );
        // ignore: avoid_print
        print('loadPhoneOrder error: $e');
      }
    } else {
      await _refreshPhoneOrderCount();
    }
  }

  void _showError(String msg, {bool error = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : Colors.blue.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.cannotConnectToDaemon,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              SelectableText(_error!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _bootstrap();
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _restaurantName.isNotEmpty
              ? _restaurantName
              : AppLocalizations.of(context)!.appTitle,
        ),
        centerTitle: false,
        actions: [
          ValueListenableBuilder<Ticket?>(
            valueListenable: _ticketNotifier,
            builder: (ctx, ticket, _) => Text(
              '${AppLocalizations.of(context)!.ticketLabel} ${ticket?.id ?? "—"}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppLocalizations.of(context)!.pastOrders,
            onPressed: _showPastOrders,
          ),
          Badge(
            isLabelVisible: _phoneOrderCount > 0,
            label: Text(
              '$_phoneOrderCount',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.orange,
            child: IconButton(
              icon: const Icon(Icons.phone),
              tooltip: AppLocalizations.of(context)!.phoneOrders,
              onPressed: _showPhoneOrderList,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: AppLocalizations.of(context)!.admin,
            onPressed: _openAdmin,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // ── Left: Menu grid with category selector (≈65% width) ───
          Expanded(
            flex: 65,
            child: Column(
              children: [
                // Category selector bar
                SizedBox(
                  height: 64,
                  child: Listener(
                    onPointerDown: (e) => _categoryPointerKind = e.kind,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (details) {
                        if (!_categoryController.hasClients) return;
                        final newOffset =
                            _categoryController.offset - details.delta.dx;
                        final max =
                            _categoryController.position.hasContentDimensions
                                ? _categoryController.position.maxScrollExtent
                                : 0.0;
                        final target = (newOffset).clamp(0.0, max).toDouble();
                        _categoryController.jumpTo(target);
                      },
                      onHorizontalDragEnd: (details) {
                        if (!_categoryController.hasClients) return;
                        final v = details.velocity.pixelsPerSecond.dx;
                        if (v.abs() < 50) return;
                        final multiplier =
                            _categoryPointerKind == PointerDeviceKind.mouse
                                ? 0.25
                                : 0.6;
                        final projected = v * multiplier;
                        final max =
                            _categoryController.position.hasContentDimensions
                                ? _categoryController.position.maxScrollExtent
                                : 0.0;
                        final target = (_categoryController.offset - projected)
                            .clamp(
                              0.0,
                              max,
                            )
                            .toDouble();
                        int durationMs = (v.abs() * 0.2).round();
                        if (durationMs < 200) durationMs = 200;
                        if (durationMs > 1000) durationMs = 1000;
                        _categoryController.animateTo(
                          target,
                          duration: Duration(milliseconds: durationMs),
                          curve: Curves.decelerate,
                        );
                      },
                      child: SingleChildScrollView(
                        controller: _categoryController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: const Text('All'),
                                selected: _selectedCategoryIndex == 0,
                                onSelected: (_) =>
                                    setState(() => _selectedCategoryIndex = 0),
                              ),
                            ),
                            for (var ci = 0; ci < _categories.length; ci++) ...[
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(_categories[ci]),
                                  selected: _selectedCategoryIndex == ci + 1,
                                  onSelected: (v) => setState(
                                    () =>
                                        _selectedCategoryIndex = v ? ci + 1 : 0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Filtered menu grid
                Expanded(
                  child: MenuGrid(
                    items: _selectedCategoryIndex == 0
                        ? _menu
                        : _menu
                            .where(
                              (it) =>
                                  it.category ==
                                  _categories[_selectedCategoryIndex - 1],
                            )
                            .toList(),
                    onItemTap: _addItem,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // ── Right: Current ticket (≈35% width) ────────────
          Expanded(
            flex: 35,
            child: ValueListenableBuilder<Ticket?>(
              valueListenable: _ticketNotifier,
              builder: (ctx, ticket, _) => RepaintBoundary(
                child: TicketPanel(
                  ticket: ticket,
                  onCheckout: _checkout,
                  onPhoneOrder: _showPhoneOrderDialog,
                  onDecreaseItem: _decreaseItem,
                  onIncreaseItem: _increaseItem,
                  onRemoveItem: _removeItem,
                  onSetQuantity: _setItemQuantity,
                  onItemTap: _editItem,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Modifier Selection Dialog ─────────────────────────────────

class _ModifierResult {
  final List<AppliedModifier> modifiers;
  final String specialInstructions;
  _ModifierResult({required this.modifiers, this.specialInstructions = ''});
}

class _ModifierDialog extends StatefulWidget {
  final MenuItem item;
  final Map<String, ModifierAction>? initialSelections;
  final String? initialSpecialInstructions;
  final String confirmLabel;
  const _ModifierDialog({
    required this.item,
    this.initialSelections,
    this.initialSpecialInstructions,
    this.confirmLabel = '',
  });

  @override
  State<_ModifierDialog> createState() => _ModifierDialogState();
}

class _ModifierDialogState extends State<_ModifierDialog> {
  // Tracks the chosen action for each modifier by modifier id.
  // null / absent = no action (keep default as-is, skip non-default).
  final Map<String, ModifierAction> _selections = {};
  String _specialInstructions = '';
  late int _currentGroupIndex;

  int _selectedCountForGroup(ModifierGroup group) {
    var c = 0;
    for (final m in group.modifiers) {
      if (_selections.containsKey(m.id)) c++;
    }
    return c;
  }

  bool _isGroupValid(int gi) {
    final group = widget.item.modifierGroups[gi];
    final sel = _selectedCountForGroup(group);
    if (sel < group.minSelect) return false;
    if (group.maxSelect > 0 && sel > group.maxSelect) return false;
    return true;
  }

  bool _transitionForward = true;

  void _setCurrentGroupIndex(int next) {
    if (next < 0 || next >= widget.item.modifierGroups.length) return;
    _transitionForward = next > _currentGroupIndex;
    setState(() {
      _currentGroupIndex = next;
    });
  }

  Widget _buildStepperRow() {
    final groups = widget.item.modifierGroups;
    return SizedBox(
      height: 72,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var gi = 0; gi < groups.length; gi++) ...[
              GestureDetector(
                onTap: () => _setCurrentGroupIndex(gi),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: gi == _currentGroupIndex
                            ? Theme.of(context).colorScheme.primary
                            : (_isGroupValid(gi)
                                ? Colors.green.shade600
                                : Colors.grey.shade300),
                        child: Text(
                          '${gi + 1}',
                          style: TextStyle(
                            color: gi == _currentGroupIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 120,
                      child: Text(
                        groups[gi].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: gi == _currentGroupIndex
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (gi < groups.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.chevron_right, color: Colors.grey),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _specialInstructions = widget.initialSpecialInstructions ?? '';
    if (widget.initialSelections != null) {
      _selections.addAll(widget.initialSelections!);
    } else {
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
    _currentGroupIndex = 0;
    for (var gi = 0; gi < widget.item.modifierGroups.length; gi++) {
      final g = widget.item.modifierGroups[gi];
      final sel = _selectedCountForGroup(g);
      if (sel < g.minSelect) {
        _currentGroupIndex = gi;
        break;
      }
    }
    _transitionForward = true;
  }

  String _money(int cents) => formatMoney(cents);

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

        result.add(
          AppliedModifier()
            ..modifierId = mod.id
            ..modifierName = mod.name
            ..groupId = group.id
            ..action = action
            ..priceAdjustmentCents = priceAdj,
        );
      }
    }
    return result;
  }

  Future<void> _showSpecialInstructions() async {
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => TouchKeyboardDialog(
        title: AppLocalizations.of(ctx)!.specialInstructions,
        initialValue: _specialInstructions,
      ),
    );
    if (text != null) {
      setState(() => _specialInstructions = text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.item.name,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SizedBox(
        width: 700,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Visual stepper showing progress across modifier groups
              _buildStepperRow(),
              // Animated group content — clip overflow and use a small slide + fade
              ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation) {
                    final offsetBegin = _transitionForward
                        ? const Offset(0.22, 0)
                        : const Offset(-0.22, 0);
                    final tween = Tween<Offset>(
                      begin: offsetBegin,
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_currentGroupIndex),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Text(
                            widget.item.modifierGroups[_currentGroupIndex].name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.item.modifierGroups[_currentGroupIndex]
                                .maxSelect ==
                            1)
                          _buildSingleSelect(
                            widget.item.modifierGroups[_currentGroupIndex],
                            _currentGroupIndex,
                          )
                        else
                          _buildMultiSelect(
                            widget.item.modifierGroups[_currentGroupIndex],
                            _currentGroupIndex,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          width: 200,
          child: OutlinedButton.icon(
            onPressed: _showSpecialInstructions,
            icon: Icon(
              _specialInstructions.isEmpty
                  ? Icons.edit_note
                  : Icons.check_circle,
              size: 20,
              color: _specialInstructions.isEmpty ? null : Colors.green,
            ),
            label: Text(
              _specialInstructions.isEmpty
                  ? AppLocalizations.of(context)!.specialInstructions
                  : AppLocalizations.of(context)!.instructionsChecked,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        if (_currentGroupIndex > 0)
          SizedBox(
            height: 48,
            width: 120,
            child: OutlinedButton.icon(
              onPressed: () => _setCurrentGroupIndex(_currentGroupIndex - 1),
              icon: const Icon(Icons.arrow_back),
              label: Text('Back', style: const TextStyle(fontSize: 14)),
            ),
          ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          width: _currentGroupIndex < widget.item.modifierGroups.length - 1
              ? 120
              : 180,
          child: FilledButton(
            onPressed: !_isGroupValid(_currentGroupIndex)
                ? null
                : () {
                    if (_currentGroupIndex <
                        widget.item.modifierGroups.length - 1) {
                      _setCurrentGroupIndex(_currentGroupIndex + 1);
                    } else {
                      Navigator.pop(
                        context,
                        _ModifierResult(
                          modifiers: _buildModifiers(),
                          specialInstructions: _specialInstructions,
                        ),
                      );
                    }
                  },
            child: Text(
              _currentGroupIndex < widget.item.modifierGroups.length - 1
                  ? 'Next'
                  : (widget.confirmLabel.isNotEmpty
                      ? widget.confirmLabel
                      : AppLocalizations.of(context)!.addToOrder),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// Single-select group (e.g. Cooking Temp) — radio buttons.
  Widget _buildSingleSelect(ModifierGroup group, int gi) {
    // Use a chip/row-based selection UI instead of the deprecated Radio API.
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
                      Text(mod.name, style: const TextStyle(fontSize: 16)),
                      if (mod.priceCents > 0)
                        Text(
                          '+${_money(mod.priceCents)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                if (mod.isDefault)
                  Chip(
                    label: Text(
                      AppLocalizations.of(context)!.defaultLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    _getRadioValue(group) == mod.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  onPressed: () {
                    setState(() {
                      for (final m in group.modifiers) {
                        _selections.remove(m.id);
                      }
                      _selections[mod.id] = ModifierAction.MOD_ADD;
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final nextIndex = gi + 1;
                      if (nextIndex < widget.item.modifierGroups.length) {
                        _setCurrentGroupIndex(nextIndex);
                      }
                    });
                  },
                ),
              ],
            ),
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
  Widget _buildMultiSelect(ModifierGroup group, int gi) {
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
                      Text(
                        mod.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      if (mod.isDefault)
                        Text(
                          AppLocalizations.of(context)!.included,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      if (!mod.isDefault && mod.priceCents > 0)
                        Text(
                          '+${_money(mod.priceCents)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
                if (mod.isDefault)
                  _actionChip(
                    mod,
                    ModifierAction.MOD_NO,
                    AppLocalizations.of(context)!.modNo,
                    Colors.red,
                    group,
                  ),
                if (!mod.isDefault)
                  _actionChip(
                    mod,
                    ModifierAction.MOD_ADD,
                    AppLocalizations.of(context)!.modAdd,
                    Colors.green,
                    group,
                  ),
                _actionChip(
                  mod,
                  ModifierAction.MOD_EXTRA,
                  AppLocalizations.of(context)!.modExtra,
                  Colors.orange,
                  group,
                ),
                if (mod.isDefault)
                  _actionChip(
                    mod,
                    ModifierAction.MOD_LIGHT,
                    AppLocalizations.of(context)!.modLight,
                    Colors.blue,
                    group,
                  ),
                _actionChip(
                  mod,
                  ModifierAction.MOD_SIDE,
                  AppLocalizations.of(context)!.modSide,
                  Colors.purple,
                  group,
                ),
                _actionChip(
                  mod,
                  ModifierAction.MOD_DOUBLE,
                  AppLocalizations.of(context)!.modDouble,
                  Colors.deepOrange,
                  group,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _actionChip(
    Modifier mod,
    ModifierAction action,
    String label,
    Color color,
    ModifierGroup group,
  ) {
    final isSelected = _selections[mod.id] == action;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : color,
          ),
        ),
        selected: isSelected,
        selectedColor: color,
        visualDensity: VisualDensity.standard,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              final cur = _selectedCountForGroup(group);
              if (group.maxSelect > 0 &&
                  !isSelected &&
                  cur >= group.maxSelect) {
                // Can't select more than maxSelect — ignore the tap.
                return;
              }
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
  final int ccFeeAmount;
  _CheckoutResult(this.payments, {this.ccFeeAmount = 0});
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
  bool _ccFeeApplied = false;
  int _ccFeeCents = 0; // flat amount
  int _ccFeeBps = 0; // percentage in basis points
  int _taxRateBps = 0; // tax rate to apply to CC fee
  int _ccFeeAmount = 0; // fee + tax (added to total, sent to backend)
  int _ccFeeDisplay = 0; // raw fee (shown in UI)

  @override
  void initState() {
    super.initState();
    _loadCcFee();
  }

  Future<void> _loadCcFee() async {
    try {
      final resp = await PosClient.instance.stub.getSettings(
        GetSettingsRequest(),
      );
      if (!mounted) return;
      setState(() {
        _ccFeeCents = resp.settings.ccFeeCents;
        _ccFeeBps = resp.settings.ccFeeBps;
        _taxRateBps = resp.settings.taxRateBps;
      });
    } catch (_) {}
  }

  bool get _hasCcFee => _ccFeeCents > 0 || _ccFeeBps > 0;

  int _computeCcFee() {
    int fee = _ccFeeCents;
    if (_ccFeeBps > 0) {
      fee += (_totalBase * _ccFeeBps / 10000).round();
    }
    return fee;
  }

  int _computeCcFeeWithTax() {
    final fee = _computeCcFee();
    if (_taxRateBps > 0) {
      return fee + (fee * _taxRateBps / 10000).round();
    }
    return fee;
  }

  int get _totalBase => widget.ticket.total;
  int get _totalDue => _totalBase + _ccFeeAmount;
  int get _paidSoFar => _payments.fold(0, (s, p) => s + p.amount);
  int get _remaining => _totalDue - _paidSoFar;

  int get _inputCents {
    if (_input.isEmpty) return 0;
    final d = double.tryParse(_input);
    if (d == null) return 0;
    return (d * 100).round();
  }

  String _money(int cents) => formatMoney(cents);

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
      Navigator.pop(
        context,
        _CheckoutResult(_payments, ccFeeAmount: _ccFeeAmount),
      );
    }
  }

  void _applyCcFee() {
    if (_ccFeeApplied) return;
    setState(() {
      _ccFeeApplied = true;
      _ccFeeDisplay = _computeCcFee();
      _ccFeeAmount = _computeCcFeeWithTax();
    });
  }

  void _removeCcFee() {
    if (!_ccFeeApplied) return;
    setState(() {
      _ccFeeApplied = false;
      _ccFeeAmount = 0;
      _ccFeeDisplay = 0;
    });
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
              Text(
                AppLocalizations.of(context)!.checkout,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              // Amount due
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.total}:',
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    _money(_totalBase),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_ccFeeApplied) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.ccFee}:',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_payments.isEmpty)
                          InkWell(
                            onTap: _removeCcFee,
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '+${_money(_ccFeeDisplay)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.newTotal}:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _money(_totalDue),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
              if (_payments.isNotEmpty) ...[
                const Divider(),
                // Show partial payments made.
                for (final p in _payments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.paymentLabel(p.type),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        _money(p.amount),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.remaining}:',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _money(_remaining > 0 ? _remaining : 0),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _remaining > 0
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _undoLastPayment,
                  icon: const Icon(Icons.undo, size: 16),
                  label: Text(AppLocalizations.of(context)!.undoLastPayment),
                ),
              ],
              const SizedBox(height: 8),
              // Input display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _input.isEmpty ? '0.00' : _input,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Keypad
              Expanded(child: _buildKeypad()),
              const SizedBox(height: 8),
              // Pay buttons
              if (_hasCcFee && !_ccFeeApplied)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _remaining > 0 ? _applyCcFee : null,
                      icon: const Icon(Icons.credit_score, size: 24),
                      label: Text(
                        '${AppLocalizations.of(context)!.addCreditCardFee} (+${_money(_computeCcFee())})',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: FilledButton.icon(
                        onPressed:
                            _remaining > 0 ? () => _addPayment('CASH') : null,
                        icon: const Icon(Icons.payments, size: 28),
                        label: Text(
                          AppLocalizations.of(context)!.cash,
                          style: const TextStyle(fontSize: 20),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: FilledButton.icon(
                        onPressed:
                            _remaining > 0 ? () => _addPayment('CARD') : null,
                        icon: const Icon(Icons.credit_card, size: 28),
                        label: Text(
                          AppLocalizations.of(context)!.card,
                          style: const TextStyle(fontSize: 20),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                        ),
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
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(fontSize: 16),
                  ),
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
            _quickBtn(AppLocalizations.of(context)!.exact, _payExact),
            const SizedBox(width: 6),
            _quickBtn(AppLocalizations.of(context)!.clear, _clear),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 28),
                        ),
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
    setState(() {
      _loading = true;
      _error = null;
    });
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

  String _money(int cents) => formatMoney(cents);

  String _time(dynamic epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      epochMs is int ? epochMs : (epochMs as dynamic).toInt(),
    );
    try {
      return DateFormat.jm(Intl.defaultLocale).format(dt);
    } catch (_) {
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${h.toString()}:${dt.minute.toString().padLeft(2, '0')} $ampm';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'CLOSED':
        return Colors.green;
      case 'VOIDED':
        return Colors.red;
      case 'COMPED':
        return Colors.orange;
      case 'REFUNDED':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Future<void> _reprintTicket(Ticket t) async {
    try {
      final resp = await PosClient.instance.stub.printReceipt(
        PrintReceiptRequest()..ticketId = t.id,
      );
      if (!resp.success) {
        if (!mounted) return;
        _showMsg(AppLocalizations.of(context)!.printError, Colors.red);
      } else {
        if (!mounted) return;
        _showMsg(
          AppLocalizations.of(context)!.receiptReprinted(resp.jobId),
          Colors.green,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showMsg(AppLocalizations.of(context)!.printError, Colors.red);
      // ignore: avoid_print
      print('reprintTicket exception: $e');
    }
  }

  Future<void> _ticketAction(Ticket t, String action) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => TouchKeyboardDialog(
        title: '${AppLocalizations.of(ctx)!.ticketLabel} ${t.id}',
        hintText: AppLocalizations.of(ctx)!.reasonOptional,
      ),
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
        _showMsg('$action failed: ${resp.error}', Colors.red);
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
                  Text(
                    AppLocalizations.of(context)!.todaysOrders,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
                  _filterChip(AppLocalizations.of(context)!.all, ''),
                  _filterChip(AppLocalizations.of(context)!.closed, 'CLOSED'),
                  _filterChip(AppLocalizations.of(context)!.voided, 'VOIDED'),
                  _filterChip(AppLocalizations.of(context)!.comped, 'COMPED'),
                  _filterChip(
                    AppLocalizations.of(context)!.refunded,
                    'REFUNDED',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              // Ticket list
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .errorOccurred(_error!),
                            ),
                          )
                        : _tickets.isEmpty
                            ? Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noOrdersFound,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
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
    final itemSummary =
        t.items.map((i) => '${i.quantity}x ${i.item.name}').join(', ');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Chip(
          label: Text(
            t.status,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          backgroundColor: _statusColor(t.status),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
        title: Text(
          '#${t.id}  ${_money(t.total + t.ccFee)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
                        child: Text('${item.quantity}x ${item.item.name}'),
                      ),
                      Text(
                        _money(
                          item.item.priceCents * item.quantity +
                              item.modifiers.fold(
                                0,
                                (s, m) => s + m.priceAdjustmentCents,
                              ),
                        ),
                      ),
                    ],
                  ),
                  for (final m in item.modifiers)
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        '${m.action.name.replaceFirst("MOD_", "")} ${m.modifierName}'
                        '${m.priceAdjustmentCents != 0 ? "  ${_money(m.priceAdjustmentCents)}" : ""}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
                if (t.payments.isNotEmpty) ...[
                  const Divider(),
                  if (t.ccFee > 0)
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.ccFee,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.orange,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _money(t.ccFee),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  for (final p in t.payments)
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!
                              .paymentLabel(p.paymentType),
                        ),
                        const Spacer(),
                        Text(_money(p.amountCents)),
                      ],
                    ),
                  if (t.changeDue > 0)
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.changeLabel,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const Spacer(),
                        Text(
                          _money(t.changeDue),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
          const Divider(),
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _reprintTicket(t),
                  icon: const Icon(Icons.print, size: 18),
                  label: Text(AppLocalizations.of(context)!.reprint),
                ),
                const SizedBox(width: 8),
                if (t.status == 'CLOSED') ...[
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'VOID'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text(AppLocalizations.of(context)!.voidLabel),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'COMP'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                    child: Text(AppLocalizations.of(context)!.comp),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _ticketAction(t, 'REFUND'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                    ),
                    child: Text(AppLocalizations.of(context)!.refund),
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
// Now uses TouchKeyboardDialog directly — see _ticketAction().

// ── Phone Order Input Dialog ──────────────────────────────────

class _PhoneOrderInput {
  final String name;
  final String comment;
  _PhoneOrderInput(this.name, this.comment);
}

class _PhoneOrderDialog extends StatefulWidget {
  const _PhoneOrderDialog();

  @override
  State<_PhoneOrderDialog> createState() => _PhoneOrderDialogState();
}

class _PhoneOrderDialogState extends State<_PhoneOrderDialog> {
  String _name = '';
  String _comment = '';

  Future<void> _editField(
    String title,
    String current,
    ValueChanged<String> onDone,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) =>
          TouchKeyboardDialog(title: title, initialValue: current),
    );
    if (result != null) {
      setState(() => onDone(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 380),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.phoneOrderTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              // Name field — tap to open keyboard
              ListTile(
                leading: const Icon(Icons.person, size: 28),
                title: Text(
                  _name.isEmpty
                      ? AppLocalizations.of(context)!.nameLabel
                      : _name,
                  style: TextStyle(
                    fontSize: 20,
                    color: _name.isEmpty ? Colors.grey : null,
                  ),
                ),
                trailing: const Icon(Icons.edit),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                onTap: () => _editField(
                  AppLocalizations.of(context)!.nameLabel,
                  _name,
                  (v) => _name = v,
                ),
              ),
              const SizedBox(height: 12),
              // Comment field — tap to open keyboard
              ListTile(
                leading: const Icon(Icons.comment, size: 28),
                title: Text(
                  _comment.isEmpty
                      ? AppLocalizations.of(context)!.commentLabel
                      : _comment,
                  style: TextStyle(
                    fontSize: 20,
                    color: _comment.isEmpty ? Colors.grey : null,
                  ),
                ),
                trailing: const Icon(Icons.edit),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                onTap: () => _editField(
                  AppLocalizations.of(context)!.commentLabel,
                  _comment,
                  (v) => _comment = v,
                ),
              ),
              const SizedBox(height: 24),
              // Done / Cancel
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(
                          context,
                          _PhoneOrderInput(_name.trim(), _comment.trim()),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
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

// ── Phone Order List Dialog ───────────────────────────────────

class _PhoneOrderListResult {
  final String action; // 'CHECKOUT' or 'CANCEL'
  final String ticketId; // ticket ID for checkout
  _PhoneOrderListResult(this.action, this.ticketId);
}

class _PhoneOrderListDialog extends StatefulWidget {
  const _PhoneOrderListDialog();

  @override
  State<_PhoneOrderListDialog> createState() => _PhoneOrderListDialogState();
}

class _PhoneOrderListDialogState extends State<_PhoneOrderListDialog> {
  List<PhoneOrder> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resp = await PosClient.instance.stub.listPhoneOrders(
        ListPhoneOrdersRequest(),
      );
      if (!mounted) return;
      setState(() {
        _orders = resp.orders;
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

  String _money(int cents) => formatMoney(cents);

  String _time(dynamic epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      epochMs is int ? epochMs : (epochMs as dynamic).toInt(),
    );
    try {
      return DateFormat.jm(Intl.defaultLocale).format(dt);
    } catch (_) {
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${h.toString()}:${dt.minute.toString().padLeft(2, '0')} $ampm';
    }
  }

  Future<void> _doAction(PhoneOrder order, String action) async {
    try {
      final resp = await PosClient.instance.stub.phoneOrderAction(
        PhoneOrderActionRequest()
          ..phoneOrderId = order.id
          ..action = action,
      );
      if (!resp.success) {
        _showMsg('$action failed: ${resp.error}', Colors.red);
        return;
      }
      if (action == 'CHECKOUT') {
        if (mounted) {
          Navigator.pop(
            context,
            _PhoneOrderListResult('CHECKOUT', order.ticket.id),
          );
        }
      } else if (action == 'EDIT') {
        if (mounted) {
          Navigator.pop(
            context,
            _PhoneOrderListResult('EDIT', order.ticket.id),
          );
        }
      } else {
        _showMsg('Order cancelled', Colors.orange);
        _loadOrders();
      }
    } catch (e) {
      _showMsg('$action failed: $e', Colors.red);
    }
  }

  void _showMsg(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
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
                  const Icon(Icons.phone, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.phoneOrders,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadOrders,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              // Order list
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .errorOccurred(_error!),
                            ),
                          )
                        : _orders.isEmpty
                            ? Center(
                                child: Text(
                                  AppLocalizations.of(context)!.noOrdersFound,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _orders.length,
                                itemBuilder: (ctx, i) =>
                                    _buildOrderTile(_orders[i]),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTile(PhoneOrder order) {
    final itemSummary = order.ticket.items
        .map((i) => '${i.quantity}x ${i.item.name}')
        .join(', ');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(Icons.phone, color: Colors.orange.shade700),
        ),
        title: Text(
          order.customerName.isNotEmpty
              ? order.customerName
              : AppLocalizations.of(context)!.phoneOrderTitle,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_time(order.createdAt)}  ${_money(order.ticket.total)}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              itemSummary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            if (order.comment.isNotEmpty)
              Text(
                '${AppLocalizations.of(context)!.noteLabel} ${order.comment}',
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        children: [
          // Full item breakdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in order.ticket.items)
                  Row(
                    children: [
                      Expanded(
                        child: Text('${item.quantity}x ${item.item.name}'),
                      ),
                      Text(_money(item.item.priceCents * item.quantity)),
                    ],
                  ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _money(order.ticket.total),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _doAction(order, 'CANCEL'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancelOrder,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: () => _doAction(order, 'EDIT'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.editOrder,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: () => _doAction(order, 'CHECKOUT'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.checkout,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
