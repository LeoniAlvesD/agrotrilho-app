import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../utils/constants.dart';
import '../../utils/platform_helper.dart';
import '../../widgets/web_qr_simulator.dart';
import '../../widgets/platform_indicator.dart';

/// QR Code scanner screen that adapts to the current platform.
///
/// - **Mobile**: opens the device camera via [MobileScanner].
/// - **Web / Desktop**: shows a simulated scan UI via [WebQrSimulator].
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController? _controller;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    if (PlatformHelper.supportsCameraScanning) {
      _controller = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() {
      _hasScanned = true;
    });

    Navigator.pop(context, barcode.rawValue);
  }

  void _onSimulatedScan(String value) {
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformHelper.supportsCameraScanning) {
      return _buildMobileScanner(context);
    }
    return _buildWebScanner(context);
  }

  // ── Mobile: real camera scanner ────────────────────────────

  Widget _buildMobileScanner(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: [
          const PlatformIndicator(),
          SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Flash',
            onPressed: () => _controller?.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            tooltip: 'Trocar câmera',
            onPressed: () => _controller?.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller!,
            onDetect: _onDetect,
          ),
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scanSize = constraints.maxWidth < 300
                    ? constraints.maxWidth - 48
                    : 250.0;
                return Semantics(
                  label: 'Área de leitura do QR Code',
                  child: Container(
                    width: scanSize,
                    height: scanSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.lg),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(AppSpacing.xxl),
                ),
                child: const Text(
                  'Aponte a câmera para o QR Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Web: simulated scanner ─────────────────────────────────

  Widget _buildWebScanner(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: const [
          PlatformIndicator(),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: 80,
                  color: colorScheme.primary,
                  semanticLabel: 'Scanner QR Code (simulado)',
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Scanner QR Code',
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Modo web – câmera não disponível.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),
                WebQrSimulator(onSimulatedScan: _onSimulatedScan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
