import 'platform_helper.dart';

/// Runtime configuration that adapts to the current platform.
class PlatformConfig {
  /// Whether the QR scanner can use the device camera.
  static bool get canUseCamera => PlatformHelper.supportsCameraScanning;

  /// Whether NFC reading is supported.
  static bool get canUseNfc => PlatformHelper.supportsNfc;

  /// Whether the QR scanner should show a simulation UI instead of a camera.
  static bool get shouldSimulateQr => PlatformHelper.isWeb;

  /// Short description of available scanning features for the current platform.
  static String get scannerCapabilities {
    if (PlatformHelper.isWeb) {
      return 'QR = simulado, NFC = indisponível';
    }
    return 'QR = câmera real, NFC = leitor real';
  }

  /// Mode label shown in the UI.
  static String get modeLabel {
    if (PlatformHelper.isWeb) return '🌐 WEB MODE';
    if (PlatformHelper.isMobile) return '📱 MOBILE MODE';
    return '🖥️ DESKTOP MODE';
  }
}
