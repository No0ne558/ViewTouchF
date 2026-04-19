import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple provider to persist whether the UI should be in Touch Mode.
class TouchModeProvider extends ChangeNotifier {
  static const _prefKey = 'touch_mode_enabled';

  bool _enabled = false;
  bool get enabled => _enabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_prefKey) ?? false;
  }

  Future<void> setEnabled(bool v) async {
    if (v == _enabled) return;
    _enabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, v);
    notifyListeners();
  }
}
