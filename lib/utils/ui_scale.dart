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

  /// Extra gap used inside banners and featured containers.
  static double bannerPadding(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 16 : ResponsiveHelper.isTablet(c) ? 20 : 24;

  /// Small gap between closely related elements.
  static double gap(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 8 : ResponsiveHelper.isTablet(c) ? 10 : 12;

  /// Vertical padding for primary action buttons.
  static double buttonPadding(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : 14;

  static double fontSm(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : 13;

  static double fontMd(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 14 : 16;

  static double fontLg(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 16 : 18;

  /// Extra-large font, used for headline values inside cards.
  static double fontXl(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 18 : 20;

  static double inputHeight(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 44 : 48;

  static double cardPadding(BuildContext c) =>
      ResponsiveHelper.isMobile(c) ? 12 : 16;
}
