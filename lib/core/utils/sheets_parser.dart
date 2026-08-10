class SheetsParser {
  /// Parses price strings from the sheet.
  /// Format examples: " $  27,968 ", " $  535,500 ", " $  -   ", "19%"
  /// The comma is a thousands separator (not decimal).
  static double parsePrice(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    String cleaned = value
        .replaceAll(r'$', '')
        .replaceAll('%', '')
        .replaceAll(' ', '')
        .replaceAll(',', ''); // remove thousands separator
    if (cleaned.isEmpty || cleaned == '-') return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Parses stock values like " 324 ", " 6,648 ", ""
  static int parseStock(dynamic value) {
    if (value == null) return 0;
    final str = value
        .toString()
        .trim()
        .replaceAll(',', ''); // remove thousands separator
    if (str.isEmpty) return 0;
    return int.tryParse(str) ?? 0;
  }

  /// Formats a number as Colombian pesos display: $27.968
  /// Uses dot as thousands separator (standard display in Colombia).
  static String formatCOP(double value) {
    final intVal = value.toInt();
    if (intVal == 0) return '\$0';
    final numStr = intVal.abs().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(numStr[i]);
      count++;
    }
    final reversed = buffer.toString().split('').reversed.join();
    return '\$$reversed';
  }
}
