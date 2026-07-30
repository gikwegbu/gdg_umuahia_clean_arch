import 'package:flutter/material.dart';

/// AppTextStyles provides typographic definitions grouped by their design roles.
/// Font sizes and heights are configured to scale gracefully with user system accessibility settings.
abstract class AppTextStyles {
  // Primary font family (using default system font family)
  static const String _fontFamily = 'Roboto';

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    height: 1.28, // ~28px line height
    letterSpacing: 0.0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.33, // ~24px line height
    letterSpacing: 0.0,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.25, // ~20px line height
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.43, // ~20px line height
    letterSpacing: 0.1,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.50, // ~24px line height
    letterSpacing: 0.5,
  );

  static const TextStyle content = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.43, // ~20px line height
    letterSpacing: 0.25,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.33, // ~16px line height
    letterSpacing: 0.4,
  );
}
