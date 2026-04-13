import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../services/animal_service.dart';
import '../services/qrcode_service.dart';
import '../utils/constants.dart';
import 'detalhe_animal.dart';

/// Tela de scanner QR Code com câmera
class ScannerQRCode extends StatefulWidget {
  const ScannerQRCode({super.key});

  @override
  State<ScannerQRCode> createState() => _ScannerQRCodeState();
}

class _ScannerQRCodeState extends State<ScannerQRCode> {
  final MobileScannerController _controller = MobileScannerController();
  bool _escaneado = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Processa o QR Code escaneado
  void _onDetect(BarcodeCapture capture) {
    if (_escaneado) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final qrData = barcode.rawValue!;

    // Valida se é um QR Code do Agrotrilho
    if (!QRCodeService.validarQRCode(qrData)) {
      _mostrarErro(AppMessages.qrInvalido);
      return;
    }

    // Extrai o ID do animal
    final animalId = QRCodeService.extrairAnimalId(qrData);
    if (animalId == null) {
      _mostrarErro(AppMessages.qrInvalido);
      return;
    }

    // Busca o animal
    final service = context.read<AnimalService>();
    final animal = service.buscarPorId(animalId);

    if (animal == null) {
      _mostrarErro(AppMessages.animalNaoEncontrado);
      return;
    }

    // Marca como escaneado e navega para detalhes
    setState(() => _escaneado = true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheAnimal(animalId: animal.id),
      ),
    );
  }

  /// Mostra mensagem de erro
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMessages.scannerTitulo),
        actions: [
          // Botão de flash
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            tooltip: 'Flash',
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Câmera scanner
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Overlay com instruções
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 48,
                    color: AppColors.white,
                  ),
                  SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    'Aponte a câmera para o QR Code do animal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    'O app reconhecerá automaticamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
