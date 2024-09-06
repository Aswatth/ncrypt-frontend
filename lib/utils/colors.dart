import 'package:flutter/material.dart';

class AppColors {
  static final AppColors _instance = AppColors._internal();

  AppColors._internal();

  factory AppColors() {
    return _instance;
  }

  final Color backgroundColor = HSLColor.fromAHSL(1, 160, 0.60, 0.99).toColor();
  final Color textColor = HSLColor.fromAHSL(1, 171, 0.47, 0.03).toColor();
  final Color primaryColor = HSLColor.fromAHSL(1, 175, 0.65, 0.51).toColor();
  final Color secondaryColor = HSLColor.fromAHSL(1, 175, 0.73, 0.72).toColor();
  final Color accentColor = HSLColor.fromAHSL(1, 175, 0.83, 0.62).toColor();
}
