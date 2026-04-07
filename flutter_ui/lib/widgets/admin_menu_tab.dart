import 'dart:math';

import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';
import '../services/pos_client.dart';
import 'touchscreen_keyboard.dart';

class AdminMenuTab extends StatefulWidget {
  const AdminMenuTab({super.key});

  @override
  State<AdminMenuTab> createState() => _AdminMenuTabState();
}

class _AdminMenuTabState extends State<AdminMenuTab> {
  List<MenuItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    try {
      final resp = await PosClient.instance.stub.getMenu(GetMenuRequest());
      setState(() {
        _items = List.from(resp.items);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnack('Failed to load menu: $e', error: true);
    }
  }

  Future<void> _addItem() async {
    final result = await Navigator.of(context).push<MenuItem>(
      MaterialPageRoute(builder: (_) => const _MenuItemEditor()),
    );
    if (result == null) return;
    try {
      await PosClient.instance.stub.addMenuItem(
        AddMenuItemRequest()..item = result,
      );
      _loadMenu();
      _showSnack('Item added');
    } catch (e) {
      _showSnack('Add failed: $e', error: true);
    }
  }

  Future<void> _editItem(MenuItem existing) async {
    final result = await Navigator.of(context).push<MenuItem>(
      MaterialPageRoute(builder: (_) => _MenuItemEditor(existing: existing)),
    );
    if (result == null) return;
    try {
      await PosClient.instance.stub.updateMenuItem(
        UpdateMenuItemRequest()..item = result,
      );
      _loadMenu();
      _showSnack('Item updated');
    } catch (e) {
      _showSnack('Update failed: $e', error: true);
    }
  }

  Future<void> _deleteItem(MenuItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Remove "${item.name}" from the menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await PosClient.instance.stub.deleteMenuItem(
        DeleteMenuItemRequest()..itemId = item.id,
      );
      _loadMenu();
      _showSnack('Item deleted');
    } catch (e) {
      _showSnack('Delete failed: $e', error: true);
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

  String _money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Menu Items (${_items.length})',
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              FilledButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('No menu items. Add one above.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _items[i];
                    final modCount = item.modifierGroups.length;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(item.id.substring(0,
                            item.id.length > 3 ? 3 : item.id.length)),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        '${item.category}  •  ${_money(item.priceCents)}'
                        '${modCount > 0 ? '  •  $modCount mod group${modCount > 1 ? 's' : ''}' : ''}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editItem(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Full-page Menu Item Editor with modifier group support
// ══════════════════════════════════════════════════════════════

class _MenuItemEditor extends StatefulWidget {
  final MenuItem? existing;
  const _MenuItemEditor({this.existing});

  @override
  State<_MenuItemEditor> createState() => _MenuItemEditorState();
}

class _MenuItemEditorState extends State<_MenuItemEditor> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _catCtrl;
  late final bool _isEdit;
  late bool _sendToKitchen;

  // Mutable list of modifier groups being edited.
  late List<_EditableModifierGroup> _groups;

  static String _uniqueId(String prefix) {
    final r = Random();
    final hex = List.generate(8, (_) => r.nextInt(16).toRadixString(16)).join();
    return '${prefix}_$hex';
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _isEdit = e != null;
    _idCtrl = TextEditingController(text: e?.id ?? '');
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _priceCtrl = TextEditingController(
      text: e != null ? (e.priceCents / 100.0).toStringAsFixed(2) : '',
    );
    _catCtrl = TextEditingController(text: e?.category ?? '');
    _sendToKitchen = e?.sendToKitchen ?? true;

    if (e != null && e.modifierGroups.isNotEmpty) {
      _groups = e.modifierGroups.map((g) {
        return _EditableModifierGroup(
          idCtrl: TextEditingController(text: g.id),
          nameCtrl: TextEditingController(text: g.name),
          minSelect: g.minSelect,
          maxSelect: g.maxSelect,
          modifiers: g.modifiers.map((m) {
            return _EditableModifier(
              idCtrl: TextEditingController(text: m.id),
              nameCtrl: TextEditingController(text: m.name),
              priceCtrl: TextEditingController(
                text: m.priceCents > 0
                    ? (m.priceCents / 100.0).toStringAsFixed(2)
                    : '',
              ),
              isDefault: m.isDefault,
            );
          }).toList(),
        );
      }).toList();
    } else {
      _groups = [];
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _catCtrl.dispose();
    for (final g in _groups) {
      g.idCtrl.dispose();
      g.nameCtrl.dispose();
      for (final m in g.modifiers) {
        m.idCtrl.dispose();
        m.nameCtrl.dispose();
        m.priceCtrl.dispose();
      }
    }
    super.dispose();
  }

  void _addGroup() {
    setState(() {
      _groups.add(_EditableModifierGroup(
        idCtrl: TextEditingController(text: _uniqueId('MG')),
        nameCtrl: TextEditingController(),
        minSelect: 0,
        maxSelect: 0,
        modifiers: [],
      ));
    });
  }

  void _removeGroup(int index) {
    setState(() {
      final g = _groups.removeAt(index);
      g.idCtrl.dispose();
      g.nameCtrl.dispose();
      for (final m in g.modifiers) {
        m.idCtrl.dispose();
        m.nameCtrl.dispose();
        m.priceCtrl.dispose();
      }
    });
  }

  void _addModifier(int groupIndex) {
    setState(() {
      _groups[groupIndex].modifiers.add(_EditableModifier(
        idCtrl: TextEditingController(text: _uniqueId('MOD')),
        nameCtrl: TextEditingController(),
        priceCtrl: TextEditingController(),
        isDefault: false,
      ));
    });
  }

  void _removeModifier(int groupIndex, int modIndex) {
    setState(() {
      final m = _groups[groupIndex].modifiers.removeAt(modIndex);
      m.idCtrl.dispose();
      m.nameCtrl.dispose();
      m.priceCtrl.dispose();
    });
  }

  MenuItem _buildMenuItem() {
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final item = MenuItem()
      ..id = _idCtrl.text.trim()
      ..name = _nameCtrl.text.trim()
      ..priceCents = (price * 100).round()
      ..category = _catCtrl.text.trim()
      ..sendToKitchen = _sendToKitchen;

    for (final g in _groups) {
      final group = ModifierGroup()
        ..id = g.idCtrl.text.trim()
        ..name = g.nameCtrl.text.trim()
        ..minSelect = g.minSelect
        ..maxSelect = g.maxSelect;
      for (final m in g.modifiers) {
        final modPrice = double.tryParse(m.priceCtrl.text) ?? 0;
        group.modifiers.add(Modifier()
          ..id = m.idCtrl.text.trim()
          ..name = m.nameCtrl.text.trim()
          ..priceCents = (modPrice * 100).round()
          ..isDefault = m.isDefault);
      }
      item.modifierGroups.add(group);
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Menu Item' : 'New Menu Item'),
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, _buildMenuItem()),
            icon: const Icon(Icons.save),
            label: Text(_isEdit ? 'Save' : 'Add'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Basic fields ─────────────────────────────────
          Text('Item Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TouchTextField(
                  controller: _idCtrl,
                  enabled: !_isEdit,
                  dialogTitle: 'Item ID',
                  decoration: const InputDecoration(
                    labelText: 'Item ID',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. BUR03',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TouchTextField(
                  controller: _nameCtrl,
                  dialogTitle: 'Item Name',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TouchTextField(
                  controller: _priceCtrl,
                  dialogTitle: 'Price (\$)',
                  numericOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                    hintText: '12.99',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TouchTextField(
                  controller: _catCtrl,
                  dialogTitle: 'Category',
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    hintText: 'e.g. Entrees',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Send to Kitchen'),
            subtitle: const Text('Print this item on kitchen tickets'),
            value: _sendToKitchen,
            onChanged: (v) => setState(() => _sendToKitchen = v),
          ),

          // ── Modifier Groups ──────────────────────────────
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Modifier Groups',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold)),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _addGroup,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Group'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_groups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No modifier groups. Items will be added as-is.',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
          for (int gi = 0; gi < _groups.length; gi++)
            _buildGroupCard(gi),
        ],
      ),
    );
  }

  Widget _buildGroupCard(int gi) {
    final g = _groups[gi];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group header
            Row(
              children: [
                Expanded(
                  child: TouchTextField(
                    controller: g.idCtrl,
                    dialogTitle: 'Group ID',
                    decoration: const InputDecoration(
                      labelText: 'Group ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TouchTextField(
                    controller: g.nameCtrl,
                    dialogTitle: 'Group Name',
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'e.g. Toppings',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: TouchTextField(
                    controller: TextEditingController(text: '${g.minSelect}'),
                    dialogTitle: 'Min Select',
                    numericOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 70,
                  child: TouchTextField(
                    controller: TextEditingController(text: '${g.maxSelect}'),
                    dialogTitle: 'Max Select',
                    numericOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  tooltip: 'Remove group',
                  onPressed: () => _removeGroup(gi),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Modifier rows
            if (g.modifiers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No modifiers in this group.',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            for (int mi = 0; mi < g.modifiers.length; mi++)
              _buildModifierRow(gi, mi),

            // Add modifier button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _addModifier(gi),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Modifier', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModifierRow(int gi, int mi) {
    final m = _groups[gi].modifiers[mi];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: TouchTextField(
              controller: m.idCtrl,
              dialogTitle: 'Modifier ID',
              decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: TouchTextField(
              controller: m.nameCtrl,
              dialogTitle: 'Modifier Name',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 80,
            child: TouchTextField(
              controller: m.priceCtrl,
              dialogTitle: 'Modifier Price',
              numericOnly: true,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                isDense: true,
                hintText: '0.00',
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            children: [
              const Text('Default', style: TextStyle(fontSize: 10)),
              Switch(
                value: m.isDefault,
                onChanged: (v) => setState(() => m.isDefault = v),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline,
                color: Colors.red, size: 18),
            tooltip: 'Remove',
            visualDensity: VisualDensity.compact,
            onPressed: () => _removeModifier(gi, mi),
          ),
        ],
      ),
    );
  }
}

// ── Helper data classes for editing state ─────────────────────

class _EditableModifierGroup {
  TextEditingController idCtrl;
  TextEditingController nameCtrl;
  int minSelect;
  int maxSelect;
  List<_EditableModifier> modifiers;

  _EditableModifierGroup({
    required this.idCtrl,
    required this.nameCtrl,
    required this.minSelect,
    required this.maxSelect,
    required this.modifiers,
  });
}

class _EditableModifier {
  TextEditingController idCtrl;
  TextEditingController nameCtrl;
  TextEditingController priceCtrl;
  bool isDefault;

  _EditableModifier({
    required this.idCtrl,
    required this.nameCtrl,
    required this.priceCtrl,
    required this.isDefault,
  });
}
