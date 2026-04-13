class QrCodeService {
  /// Generates QR Code data string for an animal.
  static String gerarDados(String animalId) {
    return animalId;
  }

  /// Validates whether a scanned QR code value looks like a valid animal ID.
  static bool validarQrCode(String? valor) {
    if (valor == null || valor.isEmpty) return false;
    // UUID v4 format: 8-4-4-4-12 hex chars
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(valor);
  }
}
