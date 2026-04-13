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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
