import '../utils/constants.dart';

/// Service responsável pela lógica de QR Code
class QRCodeService {
  /// Gera o conteúdo do QR Code para um animal
  /// Formato: agrotrilho://animal/{id}
  static String gerarQRCodeData(String animalId) {
    return '${AppMessages.qrCodePrefix}$animalId';
  }

  /// Valida se o QR Code lido é do formato Agrotrilho
  static bool validarQRCode(String qrData) {
    return qrData.startsWith(AppMessages.qrCodePrefix);
  }

  /// Extrai o ID do animal a partir do QR Code
  /// Retorna null se o QR Code for inválido
  static String? extrairAnimalId(String qrData) {
    if (!validarQRCode(qrData)) return null;
    final id = qrData.replaceFirst(AppMessages.qrCodePrefix, '');
    return id.isNotEmpty ? id : null;
  }
}
