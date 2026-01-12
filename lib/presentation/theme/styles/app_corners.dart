import 'package:flutter/material.dart';

@immutable
class AppCorners {
  final double xs = 4;
  final double sm = 8;
  final double md = 12;
  final double lg = 16;
  final double xl = 24;
  final double xxl = 32;

  BorderRadius get btnRadius => BorderRadius.circular(sm);
  BorderRadius get cardRadius => BorderRadius.circular(md);
  BorderRadius get dialogRadius => BorderRadius.circular(lg);

  RoundedRectangleBorder get btnShape =>
      RoundedRectangleBorder(borderRadius: btnRadius);

  RoundedRectangleBorder get cardShape =>
      RoundedRectangleBorder(borderRadius: cardRadius);
}
