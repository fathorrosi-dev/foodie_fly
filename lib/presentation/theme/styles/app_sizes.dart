import 'package:flutter/material.dart';

@immutable
class AppSizes {
  // Screen Size Breakpoints
  double get maxMobileWidth => 600;
  double get maxTabletWidth => 1024;

  // Content Width Constraints
  double get maxContentWidth1 => 1400;
  double get maxContentWidth2 => 1200;
  double get maxContentWidth3 => 1000;
  double get maxDialogWidth => 600;

  // Component Sizes
  double get buttonHeight => 48;
  double get inputHeight => 56;
  double get toolbarHeight => 64;

  // Icon Sizes
  double get iconXs => 16;
  double get iconSm => 20;
  double get iconMd => 24;
  double get iconLg => 32;
  double get iconXl => 48;

  // Minimum Sizes
  Size get minAppSize => const Size(320, 600);

  // Layout Helpers
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= maxMobileWidth;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width <= maxTabletWidth &&
      MediaQuery.of(context).size.width > maxMobileWidth;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > maxTabletWidth;
}
