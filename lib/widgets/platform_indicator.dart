import 'package:flutter/material.dart';
import '../utils/platform_config.dart';
import '../utils/constants.dart';

/// A small badge that displays the current platform mode (WEB / MOBILE / DESKTOP).
class PlatformIndicator extends StatelessWidget {
  const PlatformIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = PlatformConfig.modeLabel;

    return Tooltip(
      message: PlatformConfig.scannerCapabilities,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
