import 'package:flutter/material.dart';
import 'package:foodie_fly/presentation/theme/config/theme_config.dart';

class ScreenUtils {
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ThemeConfig.desktopBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ThemeConfig.tabletBreakpoint &&
      MediaQuery.of(context).size.width < ThemeConfig.desktopBreakpoint;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ThemeConfig.mobileBreakpoint;

  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  static double screenWidth(BuildContext context) => screenSize(context).width;
  static double screenHeight(BuildContext context) =>
      screenSize(context).height;

  static EdgeInsets screenPadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottomBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
}
