import 'package:flutter/foundation.dart';
import '../utils/platform_helper.dart';

/// Platform-aware QR code scanning service.
///
/// On **web** a simulated scan is returned; on **mobile** the caller should
/// use the real camera scanner provided by `mobile_scanner`.
class QrPlatformService {
  /// Attempts to scan a QR code.
  ///
  /// - Web: returns a mock scan result for testing.
  /// - Mobile: returns `null` – the caller should open the camera scanner
  ///   screen instead.
  Future<String?> scanQrCode() async {
    if (PlatformHelper.isWeb) {
      return _webMockScan();
    }
    // On mobile the QR scanner screen handles real scanning via the camera.
    return null;
  }

  /// Whether the platform supports camera-based QR scanning.
  bool get supportsCameraScanning => PlatformHelper.supportsCameraScanning;

  /// Whether the platform should show a simulated scanner.
  bool get shouldSimulate => PlatformHelper.isWeb;

  // ── Private ──────────────────────────────────────────────────

  Future<String?> _webMockScan() async {
    // Simulate a small delay to mimic real scanning.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    debugPrint('[QrPlatformService] Web mock scan triggered');
    return null; // Caller provides the simulated value via the UI.
  }
}
