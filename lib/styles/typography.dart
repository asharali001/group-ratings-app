import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Base text theme using Google Fonts - used for ThemeData
  static TextTheme get textTheme => GoogleFonts.dmSansTextTheme();

  // Display - 48px/700/-0.03em (CLAUDE.md Display)
  static TextStyle get displayLarge => GoogleFonts.dmSans(
    fontSize: 48,
    fontWeight: bold,
    letterSpacing: -0.03 * 48,
    height: 1.12,
  );

  static TextStyle get displayMedium => GoogleFonts.dmSans(
    fontSize: 45,
    fontWeight: bold,
    letterSpacing: -0.03 * 45,
    height: 1.16,
  );

  static TextStyle get displaySmall => GoogleFonts.dmSans(
    fontSize: 36,
    fontWeight: bold,
    letterSpacing: -0.02 * 36,
    height: 1.22,
  );

  // Headline - H1: 36px/700/-0.02em, H2: 24px/700/-0.02em
  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 36,
    fontWeight: bold,
    letterSpacing: -0.02 * 36,
    height: 1.25,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: bold,
    letterSpacing: -0.02 * 28,
    height: 1.29,
  );

  static TextStyle get headlineSmall => GoogleFonts.dmSans(
    fontSize: 24,
    fontWeight: bold,
    letterSpacing: -0.02 * 24,
    height: 1.33,
  );

  // Title - H3: 18px/600/-0.01em
  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 22,
    fontWeight: semiBold,
    letterSpacing: -0.01 * 22,
    height: 1.27,
  );

  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: semiBold,
    letterSpacing: -0.01 * 18,
    height: 1.5,
  );

  static TextStyle get titleSmall => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0,
    height: 1.43,
  );

  // Body - 16px/400/1.6
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.43,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.33,
  );

  // Label - Caption: 13px/500, Overline: 12px/600/0.08em
  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0,
    height: 1.43,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: medium,
    letterSpacing: 0,
    height: 1.33,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: semiBold,
    letterSpacing: 0.08 * 12,
    height: 1.45,
  );

  // Monospace for code/technical elements
  static TextStyle get mono => GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
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
