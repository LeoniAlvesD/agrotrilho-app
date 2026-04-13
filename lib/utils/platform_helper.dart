import 'package:flutter/foundation.dart';

/// Utility class for detecting the current platform at runtime.
///
/// Uses [kIsWeb] and [defaultTargetPlatform] so it works on all targets
/// (web, Android, iOS, desktop) without importing `dart:io`.
class PlatformHelper {
  /// `true` when running inside a browser (Chrome, Firefox, Safari, …).
  static bool get isWeb => kIsWeb;

  /// `true` on Android **only** (not web).
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// `true` on iOS **only** (not web).
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// `true` on any mobile platform (Android or iOS, but not web).
  static bool get isMobile => isAndroid || isIOS;

  /// `true` on desktop platforms (macOS, Windows, Linux – not web).
  static bool get isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  /// Human-readable name for the current platform.
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isDesktop) return 'Desktop';
    return 'Unknown';
  }

  /// Whether the platform supports NFC hardware.
  static bool get supportsNfc => isMobile;

  /// Whether the platform supports camera-based QR scanning.
  static bool get supportsCameraScanning => isMobile;

  /// Whether QR scanning is available (simulated on web, real on mobile).
  static bool get supportsQrScanning => true;
}
