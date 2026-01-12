import 'package:flutter/material.dart';
import 'package:foodie_fly/presentation/theme/styles/app_colors.dart';
import 'package:foodie_fly/presentation/theme/styles/app_corners.dart';
import 'package:foodie_fly/presentation/theme/styles/app_insets.dart';
import 'package:foodie_fly/presentation/theme/styles/app_sizes.dart';
import 'package:foodie_fly/presentation/theme/styles/app_text.dart';

@immutable
class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }
    scale = _calculateScale(screenSize);
  }

  late final double scale;
  final AppColors colors = AppColors();
  late final AppCorners corners = AppCorners();
  late final AppInsets insets = AppInsets(scale);
  late final AppText text = AppText(scale);
  late final AppSizes sizes = AppSizes();

  double _calculateScale(Size screenSize) {
    final shortestSide = screenSize.shortestSide;
    if (shortestSide > 1000) return 1.25;
    if (shortestSide > 800) return 1.15;
    if (shortestSide > 600) return 1;
    if (shortestSide > 400) return 0.9;
    return 0.85;
  }

  ThemeData toThemeData({bool isDark = false}) {
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    return baseTheme.copyWith(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: isDark
          ? _createDarkColorScheme()
          : _createLightColorScheme(),
      textTheme: text.toTextTheme(isDark),
      scaffoldBackgroundColor: isDark
          ? colors.darkBackground
          : colors.lightBackground,
    );
  }

  ColorScheme _createLightColorScheme() {
    return ColorScheme.light(
      surface: colors.lightSurface,
      primary: colors.lightPrimaryButton,
      secondary: colors.lightSecondaryButton,
      error: colors.error,
    );
  }

  ColorScheme _createDarkColorScheme() {
    return ColorScheme.dark(
      surface: colors.darkSurface,
      primary: colors.darkPrimaryButton,
      secondary: colors.darkSecondaryButton,
      error: colors.error,
    );
  }
}
