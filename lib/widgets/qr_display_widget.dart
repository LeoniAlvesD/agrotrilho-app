import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants.dart';

class QrDisplayWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrDisplayWidget({
    super.key,
    required this.data,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shortId =
        data.length >= 8 ? data.substring(0, 8).toUpperCase() : data.toUpperCase();

    return Semantics(
      label: 'QR Code do Animal, ID: $shortId',
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, color: colorScheme.primary),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'QR Code do Animal',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final qrSize = size < constraints.maxWidth
                      ? size
                      : constraints.maxWidth - AppSpacing.xxxl;
                  return QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: qrSize,
                    backgroundColor: Colors.white,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: colorScheme.primary,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: colorScheme.primary,
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'ID: $shortId',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
