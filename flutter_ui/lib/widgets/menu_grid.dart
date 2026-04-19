import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
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
  PointerDeviceKind? _lastPointerKind;

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

    return Listener(
      onPointerDown: (e) => _lastPointerKind = e.kind,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (!_controller.hasClients) return;
          final newOffset = _controller.offset - details.delta.dy;
          final max = _controller.position.hasContentDimensions
              ? _controller.position.maxScrollExtent
              : 0.0;
          final target = (newOffset).clamp(0.0, max).toDouble();
          _controller.jumpTo(target);
        },
        onVerticalDragEnd: (details) {
          if (!_controller.hasClients) return;
          final v = details.velocity.pixelsPerSecond.dy;
          if (v.abs() < 50) return;
          final multiplier =
              _lastPointerKind == PointerDeviceKind.mouse ? 0.2 : 0.6;
          final projected = v * multiplier;
          final max = _controller.position.hasContentDimensions
              ? _controller.position.maxScrollExtent
              : 0.0;
          final target =
              (_controller.offset - projected).clamp(0.0, max).toDouble();
          int durationMs = (v.abs() * 0.2).round();
          durationMs = math.max(200, math.min(1000, durationMs));
          _controller.animateTo(
            target,
            duration: Duration(milliseconds: durationMs),
            curve: Curves.decelerate,
          );
        },
        child: ListView(
          controller: _controller,
          padding: const EdgeInsets.all(12),
          children: children,
        ),
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
