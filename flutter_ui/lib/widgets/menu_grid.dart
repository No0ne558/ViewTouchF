import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../generated/pos_service.pb.dart';
import '../utils/money.dart';

/// A responsive grid of tappable menu item buttons.
class MenuGrid extends StatefulWidget {
  final List<MenuItem> items;
  final ValueChanged<MenuItem> onItemTap;
  final ScrollController? controller;

  const MenuGrid({
    super.key,
    required this.items,
    required this.onItemTap,
    this.controller,
  });

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  late final ScrollController _controller;
  late final bool _ownController;
  // Using the native scrolling behavior provided by ListView is more
  // efficient on low-powered devices than handling pointer drag events
  // manually. Keep a single ScrollController (optionally provided).

  @override
  void initState() {
    super.initState();
    _ownController = widget.controller == null;
    _controller = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (_ownController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Group items by category.
    final categories = <String, List<MenuItem>>{};
    for (final item in widget.items) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }

    final children = <Widget>[];
    categories.forEach((cat, items) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            cat,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      );
      children.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.15,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final item = items[i];
            return _MenuButton(item: item, onTap: () => widget.onItemTap(item));
          },
        ),
      );
    });

    // Let ListView handle pointer interactions and momentum scrolling.
    return ListView(
      controller: _controller,
      padding: const EdgeInsets.all(12),
      children: children,
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const _MenuButton({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                formatMoney(item.priceCents),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
