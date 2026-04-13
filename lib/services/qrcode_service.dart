import 'dart:convert';
import '../models/animal.dart';

class QrCodeService {
  /// Generates a JSON string containing the animal's complete information
  /// for encoding into a QR Code.
  static String gerarDados(Animal animal) {
    final data = {
      'id': animal.id,
      'nome': animal.nome,
      'idade': animal.idade,
      'peso': animal.peso,
      'observacoes': animal.observacoes,
    };
    return json.encode(data);
  }

  /// Validates whether a scanned QR code value is a valid Agrotrilho QR code.
  ///
  /// Accepts both the new JSON format and the legacy UUID-only format.
  static bool validarQrCode(String? valor) {
    if (valor == null || valor.isEmpty) return false;

    // Try JSON format first
    if (_isValidJson(valor)) return true;

    // Fall back to legacy UUID-only format
    return _isValidUuid(valor);
  }

  /// Extracts the animal ID from a QR code value.
  ///
  /// Supports both the new JSON format and the legacy UUID-only format.
  /// Returns `null` if the value is not a valid QR code.
  static String? extrairId(String? valor) {
    if (valor == null || valor.isEmpty) return null;

    // Try JSON format first
    try {
      final data = json.decode(valor);
      if (data is Map<String, dynamic> && data.containsKey('id')) {
        return data['id'] as String;
      }
    } catch (_) {
      // Not valid JSON – try legacy format
    }

    // Fall back to legacy UUID format
    if (_isValidUuid(valor)) return valor;

    return null;
  }

  static bool _isValidJson(String valor) {
    try {
      final data = json.decode(valor);
      return data is Map<String, dynamic> && data.containsKey('id');
    } catch (_) {
      return false;
    }
  }

  static bool _isValidUuid(String valor) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(valor);
  }
}
