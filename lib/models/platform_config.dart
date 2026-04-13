/// Immutable snapshot of platform capabilities.
///
/// Can be passed around or stored in state management without depending on
/// static helpers.
class PlatformCapabilities {
  final bool supportsNfc;
  final bool supportsCameraScanning;
  final bool supportsQrScanning;
  final String platformName;

  const PlatformCapabilities({
    required this.supportsNfc,
    required this.supportsCameraScanning,
    required this.supportsQrScanning,
    required this.platformName,
  });

  /// Creates a [PlatformCapabilities] for web browsers.
  const PlatformCapabilities.web()
      : supportsNfc = false,
        supportsCameraScanning = false,
        supportsQrScanning = true,
        platformName = 'Web';

  /// Creates a [PlatformCapabilities] for Android devices.
  const PlatformCapabilities.android()
      : supportsNfc = true,
        supportsCameraScanning = true,
        supportsQrScanning = true,
        platformName = 'Android';

  /// Creates a [PlatformCapabilities] for iOS devices.
  const PlatformCapabilities.ios()
      : supportsNfc = true,
        supportsCameraScanning = true,
        supportsQrScanning = true,
        platformName = 'iOS';
}
