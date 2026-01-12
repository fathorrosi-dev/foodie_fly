import 'package:flutter/material.dart';

@immutable
class AppColors {
  // Light Theme Colors
  final Color lightBackground = const Color(0xFFFFFAFA);
  final Color lightSurface = const Color(0xFFF5F0F0);
  final Color lightCard = const Color(0xFFFFFFFF);
  final Color lightBorder = const Color(0xFFE0E0E0);
  final Color lightDivider = const Color(0xFFEEEEEE);

  // Light Theme Text Colors
  final Color lightPrimaryText = const Color(0xFF1A1A1A);
  final Color lightSecondaryText = const Color(0xFF757575);
  final Color lightDisabledText = const Color(0xFFBDBDBD);

  // Light Theme Button Colors
  final Color lightPrimaryButton = const Color(0xFF424242);
  final Color lightSecondaryButton = const Color(0xFFE0E0E0);
  final Color lightDisabledButton = const Color(0xFFF5F5F5);

  // Dark Theme Colors
  final Color darkBackground = const Color(0xFF0C0F14);
  final Color darkSurface = const Color(0xFF161B22);
  final Color darkCard = const Color(0xFF1C2128);
  final Color darkBorder = const Color(0xFF30363D);
  final Color darkDivider = const Color(0xFF21262D);

  // Dark Theme Text Colors
  final Color darkPrimaryText = const Color(0xFFF0F6FC);
  final Color darkSecondaryText = const Color(0xFFB1BAC4);
  final Color darkDisabledText = const Color(0xFF484F58);

  // Dark Theme Button Colors
  final Color darkPrimaryButton = const Color(0xFFE6EDF3);
  final Color darkSecondaryButton = const Color(0xFF21262D);
  final Color darkDisabledButton = const Color(0xFF0D1117);

  // Universal Colors
  final Color error = const Color(0xFFCF6679);
  final Color success = const Color(0xFF4CAF50);
  final Color warning = const Color(0xFFFFA726);
  final Color info = const Color(0xFF29B6F6);

  Color shift(Color c, double d) => _shiftHsl(c, d);

  Color _shiftHsl(Color c, double d) {
    final hslColor = HSLColor.fromColor(c);
    return hslColor
        .withLightness((hslColor.lightness + d).clamp(0.0, 1.0))
        .toColor();
  }
}
