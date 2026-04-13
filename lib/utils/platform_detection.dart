import 'package:flutter/foundation.dart';

/// Lightweight platform detection utility for mobile-only builds.
///
/// Uses [kIsWeb] and [defaultTargetPlatform] to detect the current platform
/// without importing `dart:io`, making it safe for all compilation targets.
///
/// When web support is re-enabled in the future, this class already works
/// correctly – [kIsWeb] is `true` on web and the mobile checks are guarded.
class PlatformDetection {
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isMobile => isAndroid || isIOS;

  /// Human-readable platform name.
  static String get platformName {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    return 'Unknown';
  }
}
