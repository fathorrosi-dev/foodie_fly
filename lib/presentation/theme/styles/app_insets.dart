import 'package:flutter/material.dart';

@immutable
class AppInsets {
  AppInsets(this._scale);
  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 16 * _scale;
  late final double md = 24 * _scale;
  late final double lg = 32 * _scale;
  late final double xl = 48 * _scale;
  late final double xxl = 56 * _scale;
  late final double offset = 80 * _scale;

  EdgeInsets get screenPadding => EdgeInsets.all(sm);
  EdgeInsets get cardPadding => EdgeInsets.all(md);

  // Responsive paddings
  EdgeInsets get responsiveHorizontal =>
      EdgeInsets.symmetric(horizontal: _scale <= 1 ? sm : md);

  EdgeInsets get responsiveVertical =>
      EdgeInsets.symmetric(vertical: _scale <= 1 ? sm : md);

  EdgeInsets get responsiveAll => EdgeInsets.all(_scale <= 1 ? sm : md);
}
