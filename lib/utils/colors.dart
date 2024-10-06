import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._internal();

  AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  final Color backgroundColor_light = HSLColor.fromAHSL(1, 144, 0.38, 0.97).toColor();
  final Color textColor_light = HSLColor.fromAHSL(1, 140, 0.38, 0.03).toColor();
  final Color primaryColor_light = HSLColor.fromAHSL(1, 144, 0.49, 0.51).toColor();
  final Color secondaryColor_light = HSLColor.fromAHSL(1, 144, 0.53, 0.75).toColor();
  final Color accentColor_light = HSLColor.fromAHSL(1, 144, 0.58, 0.64).toColor();

  final Color backgroundColor_dark = HSLColor.fromAHSL(1, 60, 0.2, 0.02).toColor();
  final Color textColor_dark = HSLColor.fromAHSL(1, 84, 0.14, 0.93).toColor();
  final Color primaryColor_dark = HSLColor.fromAHSL(1, 83, 0.48, 0.46).toColor();
  final Color secondaryColor_dark = HSLColor.fromAHSL(1, 84, 0.65, 0.26).toColor();
  final Color accentColor_dark = HSLColor.fromAHSL(1, 84, 0.83, 0.39).toColor();
}
