class Validators {
  /// Maximum allowed name length.
  static const int maxNomeLength = 100;

  /// Maximum allowed age in months.
  static const int maxIdade = 600;

  /// Maximum allowed weight in kg.
  static const double maxPeso = 5000.0;

  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome do animal';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    if (trimmed.length > maxNomeLength) {
      return 'O nome deve ter no máximo $maxNomeLength caracteres';
    }
    return null;
  }

  static String? validarIdade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe a idade';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Informe um número inteiro válido';
    }
    if (parsed <= 0) {
      return 'A idade deve ser maior que zero';
    }
    if (parsed > maxIdade) {
      return 'A idade máxima permitida é $maxIdade meses';
    }
    return null;
  }

  static String? validarPeso(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o peso';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Informe um número válido';
    }
    if (parsed <= 0) {
      return 'O peso deve ser maior que zero';
    }
    if (parsed > maxPeso) {
      return 'O peso máximo permitido é ${maxPeso.toStringAsFixed(0)} kg';
    }
    return null;
  }
}
