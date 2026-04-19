import 'package:flutter/material.dart';
import 'responsive_helper.dart';

/// Responsive sizing helpers for compact, proportional UI across breakpoints.
///
/// Mobile  (<600 px): smaller padding, fonts and input heights.
/// Tablet  (600–1200 px): medium values.
/// Desktop (>1200 px): larger, more spacious values.
class UiScale {
  static double padding(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : ResponsiveHelper.isTablet(c) ? 16 : 20;

  static double gap(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 8 : 12;

  static double fontSm(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : 13;

  static double fontMd(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 14 : 16;

  static double fontLg(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 16 : 18;

  static double inputHeight(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 44 : 48;

  static double cardPadding(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : 16;
}
