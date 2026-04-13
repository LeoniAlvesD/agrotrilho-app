import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatWidget extends StatelessWidget {
  final String label;
  final String value;
  final double fraction;
  final Color? color;

  const StatWidget({
    super.key,
    required this.label,
    required this.value,
    this.fraction = 0.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, _) {
                return LinearProgressIndicator(
                  value: animValue,
                  backgroundColor: barColor.withAlpha(25),
                  valueColor: AlwaysStoppedAnimation(barColor),
                  minHeight: 8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
