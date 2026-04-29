double parseBrDouble(String? value) {
  if (value == null || value.isEmpty) return 0.0;

  return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
}
