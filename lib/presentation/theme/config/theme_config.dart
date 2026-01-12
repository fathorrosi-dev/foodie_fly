import 'package:flutter/material.dart';

@immutable
class ThemeConfig {
  static const defaultRadius = 12.0;
  static const defaultPadding = 16.0;
  static const defaultElevation = 0.0;

  static const fontFamily = 'Poppins';

  static const transitionDuration = Duration(milliseconds: 300);
  static const animationDuration = Duration(milliseconds: 200);

  // Layout breakpoints
  static const mobileBreakpoint = 600.0;
  static const tabletBreakpoint = 900.0;
  static const desktopBreakpoint = 1200.0;

  // Button sizes
  static const buttonHeight = 48.0;
  static const buttonRadius = defaultRadius;
  static const buttonElevation = defaultElevation;

  // Input sizes
  static const inputHeight = 56.0;
  static const inputRadius = defaultRadius;

  // Maximum content width constraints
  static const maxContentWidth1 = 800.0;
  static const maxContentWidth2 = 600.0;
  static const maxContentWidth3 = 500.0;
}
