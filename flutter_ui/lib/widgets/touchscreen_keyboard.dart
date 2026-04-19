import 'package:flutter/material.dart';
import 'package:viewtouch_ui/generated/app_localizations.dart';

/// A QWERTY on-screen keyboard widget for touchscreen-only POS terminals.
/// Sends key taps to the provided [controller].
class TouchscreenKeyboard extends StatelessWidget {
  final TextEditingController controller;

  /// If true, show a numeric-only layout instead of full QWERTY.
  final bool numericOnly;

  const TouchscreenKeyboard({
    super.key,
    required this.controller,
    this.numericOnly = false,
  });

  void _onKey(String key) {
    final text = controller.text;
    final sel = controller.selection;
    final base = sel.isValid ? sel.start : text.length;
    if (key == '⌫') {
      if (base > 0) {
        controller.text =
            '${text.substring(0, base - 1)}${text.substring(base)}';
        controller.selection = TextSelection.collapsed(offset: base - 1);
      }
    } else if (key == '␣') {
      controller.text = '${text.substring(0, base)} ${text.substring(base)}';
      controller.selection = TextSelection.collapsed(offset: base + 1);
    } else {
      controller.text = '${text.substring(0, base)}$key${text.substring(base)}';
      controller.selection = TextSelection.collapsed(offset: base + key.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = numericOnly
        ? [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
            ['.', '0', '⌫'],
          ]
        : [
            ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
            ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
            ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
            ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
            [':', '.', ',', '␣', '@', '#', '!'],
          ];

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                final isSpace = key == '␣';
                return Expanded(
                  flex: isSpace ? 3 : 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () => _onKey(key),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: key == '⌫'
                              ? Colors.blueGrey.shade700
                              : isSpace
                                  ? Colors.blueGrey.shade600
                                  : null,
                          foregroundColor:
                              (key == '⌫' || isSpace) ? Colors.white : null,
                        ),
                        child: Text(
                          isSpace
                              ? AppLocalizations.of(context)!.spaceLabel
                              : key,
                          style: TextStyle(
                            fontSize: isSpace ? 16 : 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A dialog that lets the user type text using the on-screen QWERTY keyboard.
/// Returns the entered text, or null if cancelled.
///
/// Use [showTouchKeyboardDialog] as a convenience.
class TouchKeyboardDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final String hintText;
  final bool numericOnly;

  const TouchKeyboardDialog({
    super.key,
    required this.title,
    this.initialValue = '',
    this.hintText = '',
    this.numericOnly = false,
  });

  @override
  State<TouchKeyboardDialog> createState() => _TouchKeyboardDialogState();
}

class _TouchKeyboardDialogState extends State<TouchKeyboardDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.numericOnly ? 400 : 1100,
          maxHeight: widget.numericOnly ? 520 : 640,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                readOnly: true,
                showCursor: true,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TouchscreenKeyboard(
                  controller: _controller,
                  numericOnly: widget.numericOnly,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.pop(context, _controller.text),
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: const TextStyle(fontSize: 16),
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

/// Convenience function: show a full-screen keyboard dialog and return the text.
Future<String?> showTouchKeyboardDialog(
  BuildContext context, {
  required String title,
  String initialValue = '',
  String hintText = '',
  bool numericOnly = false,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => TouchKeyboardDialog(
      title: title,
      initialValue: initialValue,
      hintText: hintText,
      numericOnly: numericOnly,
    ),
  );
}

/// A TextField replacement that opens the TouchKeyboardDialog on tap.
/// Use this as a drop-in replacement for TextField in touchscreen-only UIs.
class TouchTextField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  final String dialogTitle;
  final bool numericOnly;
  final TextStyle? style;
  final bool enabled;

  const TouchTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.dialogTitle = '',
    this.numericOnly = false,
    this.style,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      showCursor: false,
      enabled: enabled,
      decoration: decoration,
      style: style,
      onTap: enabled
          ? () async {
              final result = await showTouchKeyboardDialog(
                context,
                title: dialogTitle.isNotEmpty
                    ? dialogTitle
                    : AppLocalizations.of(context)!.enterText,
                initialValue: controller.text,
                hintText: decoration?.hintText ?? '',
                numericOnly: numericOnly,
              );
              if (result != null) {
                controller.text = result;
              }
            }
          : null,
    );
  }
}
