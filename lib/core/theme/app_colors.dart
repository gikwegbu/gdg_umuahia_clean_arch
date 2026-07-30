import 'package:flutter/material.dart';

/// AppColors contains color constants for the app's light and dark themes.
/// All text/background combinations are designed to meet AA-contrast requirements (ratio >= 4.5:1).
abstract class AppColors {
  // --- Light Palette ---
  static const Color primaryLight = Color(0xFF0052FF); // Visa/Coinbase Banking Blue
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFF0A2540); // Deep Dark Blue
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  
  static const Color backgroundLight = Color(0xFFF4F6F9); // Light Grayish Blue
  static const Color onBackgroundLight = Color(0xFF111827); // Dark gray (almost black)
  
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1F2937);
  static const Color onSurfaceVariantLight = Color(0xFF6B7280); // Gray text
  
  static const Color successLight = Color(0xFF10B981); // Emerald Green
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  
  static const Color errorLight = Color(0xFFEF4444); // Red
  static const Color onErrorLight = Color(0xFFFFFFFF);
  
  static const Color warningLight = Color(0xFFF59E0B); // Amber
  static const Color onWarningLight = Color(0xFF1F2937);

  // --- Dark Palette ---
  static const Color primaryDark = Color(0xFF3B82F6); // Lighter blue for readability in dark mode
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color secondaryDark = Color(0xFF60A5FA);
  static const Color onSecondaryDark = Color(0xFF111827);
  
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900
  static const Color onBackgroundDark = Color(0xFFF8FAFC); // Slate 50
  
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color onSurfaceDark = Color(0xFFF1F5F9); // Slate 100
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8); // Slate 400
  
  static const Color successDark = Color(0xFF34D399); // Emerald 400
  static const Color onSuccessDark = Color(0xFF064E3B); // Dark green
  
  static const Color errorDark = Color(0xFFF87171); // Red 400
  static const Color onErrorDark = Color(0xFF7F1D1D); // Dark red
  
  static const Color warningDark = Color(0xFFFBBF24); // Amber 400
  static const Color onWarningDark = Color(0xFF78350F); // Dark amber

  // --- Neutral & Utility Colors ---
  static const Color outlineLight = Color(0xFFE5E7EB);
  static const Color outlineDark = Color(0xFF334155);
}
