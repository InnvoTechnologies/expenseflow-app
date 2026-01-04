import 'package:flutter/material.dart';
class AppTheme {
  static final ThemeData light = ThemeData(
    colorSchemeSeed: const Color(0xFF6750A4),
    brightness: Brightness.light,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  static final ThemeData dark = ThemeData(
    colorSchemeSeed: const Color(0xFF6750A4),
    brightness: Brightness.dark,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
