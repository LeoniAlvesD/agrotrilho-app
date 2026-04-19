import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ui_scale.dart';

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.onTap,
    this.semanticLabel,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = widget.color ?? colorScheme.primary;

    return Semantics(
      label: widget.semanticLabel ?? '${widget.title}: ${widget.value}',
      button: widget.onTap != null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.97 : 1.0,
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Padding(
              padding: EdgeInsets.all(UiScale.cardPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cardColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: cardColor, size: 22),
                  ),
                  SizedBox(height: UiScale.gap(context)),
                  Text(
                    widget.value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cardColor,
                      fontSize: UiScale.fontXl(context),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: UiScale.fontSm(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
