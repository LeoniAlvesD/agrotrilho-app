class Validators {
  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome do animal';
    }
    if (value.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  static String? validarIdade(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a idade';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Informe um número válido maior que zero';
    }
    return null;
  }

  static String? validarPeso(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o peso';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Informe um número válido maior que zero';
    }
    return null;
  }
}
