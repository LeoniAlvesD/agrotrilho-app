import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ui_scale.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const StatsCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiScale.cardPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: colorScheme.primary,
                    semanticLabel: title),
                SizedBox(width: AppSpacing.sm),
                Text(title,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: UiScale.fontMd(context))),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
