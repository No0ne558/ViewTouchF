import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LocaleProvider extends ChangeNotifier {
  static const _prefKey = 'locale';

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      Intl.defaultLocale = _locale!.toLanguageTag();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    Intl.defaultLocale = locale.toLanguageTag();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    notifyListeners();
  }
}
