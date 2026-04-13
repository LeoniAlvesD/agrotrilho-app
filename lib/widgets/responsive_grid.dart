import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getGridColumns(context);

    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSpacing = spacing * (columns - 1);
          final itemWidth =
              (constraints.maxWidth - totalSpacing) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children.map((child) {
              return SizedBox(
                width: itemWidth.clamp(0, constraints.maxWidth),
                child: child,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
