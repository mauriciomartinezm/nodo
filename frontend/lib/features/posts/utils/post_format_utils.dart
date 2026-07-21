import 'package:flutter/services.dart';

List<String> parsePostImages(dynamic photos) {
  if (photos is List) {
    return photos.map((url) => url.toString()).toList();
  }
  return [];
}

String formatPostDate(String? dateString) {
  if (dateString == null) return '';
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (_) {
    return dateString;
  }
}

/// Formatea un número como presupuesto con separador de miles (punto).
/// Ej: 1500000 → "1.500.000"
String formatBudget(dynamic budget) {
  if (budget == null) return '0';
  final amount = int.tryParse(budget.toString()) ?? 0;
  if (amount == 0) return '0';
  return amount
      .toString()
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

/// Convierte un valor formateado ("1.500.000") de vuelta a int.
int parseBudget(String formatted) =>
    int.tryParse(formatted.replaceAll('.', '')) ?? 0;

/// TextInputFormatter que agrega puntos de miles en tiempo real.
class BudgetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Solo dígitos
    final digits = newValue.text.replaceAll('.', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    // Sin ceros a la izquierda
    final clean = digits.replaceAll(RegExp(r'^0+'), '');
    if (clean.isEmpty) return newValue.copyWith(text: '0');

    final formatted = clean.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
