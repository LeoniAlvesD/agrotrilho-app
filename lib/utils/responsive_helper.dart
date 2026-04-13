import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static double getWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  static double getFontScale(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 1.1;
    return 1.2;
  }
}
