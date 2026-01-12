import 'package:flutter/material.dart';
import 'package:foodie_fly/presentation/theme/styles/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppText {
  AppText(this._scale) {
    _initializeTextStyles();
  }

  final double _scale;

  late final TextStyle displayLarge;
  late final TextStyle displayMedium;
  late final TextStyle displaySmall;
  late final TextStyle headlineLarge;
  late final TextStyle headlineMedium;
  late final TextStyle headlineSmall;
  late final TextStyle titleLarge;
  late final TextStyle titleMedium;
  late final TextStyle titleSmall;
  late final TextStyle bodyLarge;
  late final TextStyle bodyMedium;
  late final TextStyle bodySmall;
  late final TextStyle labelLarge;
  late final TextStyle labelMedium;
  late final TextStyle labelSmall;

  void _initializeTextStyles() {
    final baseStyle = GoogleFonts.plusJakartaSans();
    final secondaryStyle = GoogleFonts.inter();

    displayLarge = _createFont(
      baseStyle,
      sizePx: 57,
      heightPx: 64,
      weight: FontWeight.w400,
      spacingPc: -0.25,
    );
    displayMedium = _createFont(
      baseStyle,
      sizePx: 45,
      heightPx: 52,
      weight: FontWeight.w400,
    );
    displaySmall = _createFont(
      baseStyle,
      sizePx: 36,
      heightPx: 44,
      weight: FontWeight.w400,
    );

    headlineLarge = _createFont(
      baseStyle,
      sizePx: 32,
      heightPx: 40,
      weight: FontWeight.w400,
    );
    headlineMedium = _createFont(
      baseStyle,
      sizePx: 28,
      heightPx: 36,
      weight: FontWeight.w400,
    );
    headlineSmall = _createFont(
      baseStyle,
      sizePx: 24,
      heightPx: 32,
      weight: FontWeight.w400,
    );

    titleLarge = _createFont(
      baseStyle,
      sizePx: 22,
      heightPx: 28,
      weight: FontWeight.w400,
    );
    titleMedium = _createFont(
      baseStyle,
      sizePx: 16,
      heightPx: 24,
      weight: FontWeight.w500,
      spacingPc: 0.15,
    );
    titleSmall = _createFont(
      baseStyle,
      sizePx: 14,
      heightPx: 20,
      weight: FontWeight.w500,
      spacingPc: 0.1,
    );

    bodyLarge = _createFont(
      secondaryStyle,
      sizePx: 16,
      heightPx: 24,
      weight: FontWeight.w400,
      spacingPc: 0.5,
    );
    bodyMedium = _createFont(
      secondaryStyle,
      sizePx: 14,
      heightPx: 20,
      weight: FontWeight.w400,
      spacingPc: 0.25,
    );
    bodySmall = _createFont(
      secondaryStyle,
      sizePx: 12,
      heightPx: 16,
      weight: FontWeight.w400,
      spacingPc: 0.4,
    );

    labelLarge = _createFont(
      secondaryStyle,
      sizePx: 14,
      heightPx: 20,
      weight: FontWeight.w500,
      spacingPc: 0.1,
    );
    labelMedium = _createFont(
      secondaryStyle,
      sizePx: 12,
      heightPx: 16,
      weight: FontWeight.w500,
      spacingPc: 0.5,
    );
    labelSmall = _createFont(
      secondaryStyle,
      sizePx: 11,
      heightPx: 16,
      weight: FontWeight.w500,
      spacingPc: 0.5,
    );
  }

  TextStyle _createFont(
    TextStyle style, {
    required double sizePx,
    double? heightPx,
    double? spacingPc,
    FontWeight? weight,
  }) {
    return style.copyWith(
      leadingDistribution: TextLeadingDistribution.even,
      fontSize: sizePx * _scale,
      height: heightPx != null ? (heightPx / sizePx) : style.height,
      letterSpacing: spacingPc != null
          ? sizePx * spacingPc * 0.01
          : style.letterSpacing,
      fontWeight: weight,
    );
  }

  TextTheme toTextTheme(bool isDark) {
    final colors = AppColors();
    final color = isDark ? colors.darkPrimaryText : colors.lightPrimaryText;
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: color),
      displayMedium: displayMedium.copyWith(color: color),
      displaySmall: displaySmall.copyWith(color: color),
      headlineLarge: headlineLarge.copyWith(color: color),
      headlineMedium: headlineMedium.copyWith(color: color),
      headlineSmall: headlineSmall.copyWith(color: color),
      titleLarge: titleLarge.copyWith(color: color),
      titleMedium: titleMedium.copyWith(color: color),
      titleSmall: titleSmall.copyWith(color: color),
      bodyLarge: bodyLarge.copyWith(color: color),
      bodyMedium: bodyMedium.copyWith(color: color),
      bodySmall: bodySmall.copyWith(color: color),
      labelLarge: labelLarge.copyWith(color: color),
      labelMedium: labelMedium.copyWith(color: color),
      labelSmall: labelSmall.copyWith(color: color),
    );
  }
}
