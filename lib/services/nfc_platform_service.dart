import 'package:flutter/foundation.dart';
import '../utils/platform_helper.dart';

/// Platform-aware NFC service.
///
/// NFC hardware is only available on Android and iOS.  On **web** (and
/// desktop) every method returns a safe no-op / false value.
class NfcPlatformService {
  /// Whether NFC hardware is available on this device.
  ///
  /// On web this always returns `false`.
  Future<bool> isAvailable() async {
    if (!PlatformHelper.supportsNfc) return false;

    // On mobile, NFC would be checked via nfc_manager if installed.
    // Since we keep dependencies unchanged, we report availability based on
    // the platform – the actual check requires the nfc_manager package.
    debugPrint('[NfcPlatformService] NFC supported on ${PlatformHelper.platformName}');
    return true;
  }

  /// Start an NFC reading session.
  ///
  /// [onTagRead] is called when a tag is detected (mobile only).
  Future<void> startReading({
    required void Function(String tagId) onTagRead,
    void Function(String error)? onError,
  }) async {
    if (!PlatformHelper.supportsNfc) {
      onError?.call('NFC não disponível nesta plataforma');
      return;
    }

    // On mobile, an nfc_manager session would start here.
    // Without the package we simulate a placeholder flow.
    debugPrint('[NfcPlatformService] NFC reading started (simulated)');
  }

  /// Stop the current NFC reading session.
  Future<void> stopReading() async {
    if (!PlatformHelper.supportsNfc) return;
    debugPrint('[NfcPlatformService] NFC reading stopped');
  }

  /// Human-readable status text for the current platform.
  String get statusText {
    if (PlatformHelper.isWeb) return 'NFC não disponível em navegadores web';
    if (PlatformHelper.isDesktop) return 'NFC não disponível em desktop';
    return 'NFC disponível';
  }
}
