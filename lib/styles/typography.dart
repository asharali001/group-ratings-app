import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Base text theme using Google Fonts - used for ThemeData
  static TextTheme get textTheme => GoogleFonts.kanitTextTheme();

  // Custom text styles with consistent sizing and weights
  // Using GoogleFonts.kanit directly to ensure font family is always applied
  
  // Display
  static TextStyle get displayLarge => GoogleFonts.kanit(
    fontSize: 57,
    fontWeight: regular,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle get displayMedium => GoogleFonts.kanit(
    fontSize: 45,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.16,
  );

  static TextStyle get displaySmall => GoogleFonts.kanit(
    fontSize: 36,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.22,
  );

  // Headline
  static TextStyle get headlineLarge => GoogleFonts.kanit(
    fontSize: 32,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.25,
  );

  static TextStyle get headlineMedium => GoogleFonts.kanit(
    fontSize: 28,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.29,
  );

  static TextStyle get headlineSmall => GoogleFonts.kanit(
    fontSize: 24,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.33,
  );

  // Title
  static TextStyle get titleLarge => GoogleFonts.kanit(
    fontSize: 22,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.27,
  );

  static TextStyle get titleMedium => GoogleFonts.kanit(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle get titleSmall => GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.kanit(
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static TextStyle get bodySmall => GoogleFonts.kanit(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label
  static TextStyle get labelLarge => GoogleFonts.kanit(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle get labelMedium => GoogleFonts.kanit(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static TextStyle get labelSmall => GoogleFonts.kanit(
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Utility method to apply color to text styles
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Utility method to apply weight to text styles
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // Utility method to apply size to text styles
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
