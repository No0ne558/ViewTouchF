import 'package:intl/intl.dart';

/// Format cents as a currency string using the current locale.
String formatMoney(int cents) {
  final value = cents / 100.0;
  final locale = Intl.defaultLocale;
  final fmt = NumberFormat.simpleCurrency(locale: locale);
  return fmt.format(value);
}
