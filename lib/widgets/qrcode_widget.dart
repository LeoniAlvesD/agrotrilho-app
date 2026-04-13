import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants.dart';

/// Widget reutilizável para exibir QR Code de um animal
class QRCodeWidget extends StatelessWidget {
  final String data;
  final double size;

  const QRCodeWidget({
    super.key,
    required this.data,
    this.size = AppDimensions.qrCodeSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            backgroundColor: AppColors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.roundedOuter,
              color: AppColors.darkGreen,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.roundedOuterCorners,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            'Escaneie para identificar',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
