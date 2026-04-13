import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.onTap,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? AppColors.primary;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Card(
        elevation: _isPressed ? 0 : 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor.withAlpha(15),
                  cardColor.withAlpha(5),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: cardColor, size: 26),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cardColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
