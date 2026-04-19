import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../generated/pos_service.pb.dart';
import '../utils/money.dart';
// Touch-friendly by default: no provider required.

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

    // Build slivers — a SliverToBoxAdapter header followed by a SliverGrid
    // for each category. This keeps the list virtualized: only visible
    // children and the nearby ones are instantiated, which reduces memory
    // pressure on small devices.
    final slivers = <Widget>[];
    categories.forEach((cat, items) {
      slivers.add(SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        sliver: SliverToBoxAdapter(
          child: Text(
            cat,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ));

      slivers.add(SliverPadding(
        padding: const EdgeInsets.only(bottom: 12),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final item = items[i];
              return _MenuButton(
                  item: item, onTap: () => widget.onItemTap(item));
            },
            childCount: items.length,
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.15,
          ),
        ),
      ));
    });

    // Apply the previous ListView padding around the scrollable content.
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomScrollView(
        controller: _controller,
        slivers: slivers,
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const _MenuButton({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Touch-first: use larger padding and slightly larger text for readability
    // on a capacitive touchscreen by default.
    final pad = 18.0;
    final nameStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18);
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: nameStyle,
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
