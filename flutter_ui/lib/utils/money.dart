/// Format cents as a dollar string with commas: 123456 → "$1,234.56"
String formatMoney(int cents) {
  final negative = cents < 0;
  final abs = cents.abs();
  final dollars = abs ~/ 100;
  final remainder = abs % 100;
  // Insert commas into dollar portion.
  final dollarStr = dollars.toString();
  final buf = StringBuffer();
  for (var i = 0; i < dollarStr.length; i++) {
    if (i > 0 && (dollarStr.length - i) % 3 == 0) buf.write(',');
    buf.write(dollarStr[i]);
  }
  final sign = negative ? '-' : '';
  return '$sign\$$buf.${remainder.toString().padLeft(2, '0')}';
}
