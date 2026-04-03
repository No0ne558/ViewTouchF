import 'package:flutter/material.dart';
import '../generated/pos_service.pb.dart';

/// A responsive grid of tappable menu item buttons.
class MenuGrid extends StatelessWidget {
  final List<MenuItem> items;
  final ValueChanged<MenuItem> onItemTap;

  const MenuGrid({super.key, required this.items, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    // Group items by category.
    final categories = <String, List<MenuItem>>{};
    for (final item in items) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final entry in categories.entries) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              entry.key,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.4,
            ),
            itemCount: entry.value.length,
            itemBuilder: (ctx, i) {
              final item = entry.value[i];
              return _MenuButton(item: item, onTap: () => onItemTap(item));
            },
          ),
        ],
      ],
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${(item.priceCents / 100).toStringAsFixed(2)}',
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
