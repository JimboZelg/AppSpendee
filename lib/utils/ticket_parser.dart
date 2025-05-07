class TicketParser {
  // Expresiones comunes para detectar montos después de palabras clave
  static final List<RegExp> _patterns = [
    RegExp(r'(total|monto a pagar|importe)\D{0,10}(\d+[.,]?\d*)', caseSensitive: false),
    RegExp(r'(subtotal)\D{0,10}(\d+[.,]?\d*)', caseSensitive: false),
  ];

  static double? extractTotalFromText(String text) {
    for (final pattern in _patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 2) {
        final raw = match.group(2)!.replaceAll(',', '.');
        final value = double.tryParse(raw);
        if (value != null && value > 0) {
          return value;
        }
      }
    }

    return null;
  }
}
