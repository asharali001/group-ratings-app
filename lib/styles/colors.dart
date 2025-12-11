import 'dart:ui';

class AppColors {
  // ===========================================================================
  // Core Palette (Primitive Values)
  // Internal use only. Use Semantic Aliases for UI.
  // ===========================================================================

  // Brand Colors
  static const _shiebleBlue = Color(0xFF0BA5EC);
  static const _shiebleIndigo = Color(0xFF6366F1);

  // Neutrals (Slate/Gray Scale)
  static const _neutral50 = Color(0xFFF8FAFC);
  static const _neutral100 = Color(0xFFF1F5F9);
  static const _neutral200 = Color(0xFFE2E8F0);
  static const _neutral300 = Color(0xFFCBD5E1);
  static const _neutral400 = Color(0xFF94A3B8);
  static const _neutral500 = Color(0xFF64748B);
  static const _neutral600 = Color(0xFF475569);
  static const _neutral700 = Color(0xFF334155);
  static const _neutral800 = Color(0xFF1E293B);
  static const _neutral900 = Color(0xFF0F172A);

  // Functional Colors
  static const _green500 = Color(0xFF22C55E);
  static const _green50 = Color(0xFFF0FDF4); // Success Background
  
  static const _red500 = Color(0xFFEF4444);
  static const _red50 = Color(0xFFFEF2F2);   // Error Background

  static const _orange500 = Color(0xFFF97316);
  static const _orange50 = Color(0xFFFFF7ED); // Warning Background

  static const _blue500 = Color(0xFF3B82F6);
  static const _blue50 = Color(0xFFEFF6FF);   // Info Background

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  // ===========================================================================
  // Semantic Aliases (Usage based)
  // ===========================================================================

  // Primary
  static const primary = _shiebleBlue;
  static const onPrimary = white;
  static const primaryContainer = Color(0xFFE0F2FE); // Light Blue
  static const onPrimaryContainer = Color(0xFF0369A1); // Dark Blue

  // Secondary
  static const secondary = _shiebleIndigo;
  static const onSecondary = white;

  // Backgrounds
  static const background = _neutral50;
  static const surface = white;
  static const onSurface = textPrimary;
  static const surfaceVariant = _neutral100;
  static const onSurfaceVariant = textSecondary; // Also useful
  
  // Text
  static const textPrimary = _neutral900;
  
  // Semantic Aliases for common colors
  static const green = _green500;
  static const red = _red500;
  static const blue = _blue500;
  static const yellow = _orange500; // Mapping yellow to orange/warning color or add actual yellow
  static const purple = _shiebleIndigo; // Mapping purple to indigo
  static const textSecondary = _neutral500;
  static const textTertiary = _neutral400;
  
  // Borders
  static const border = _neutral200;
  static const borderFocus = _shiebleBlue;

  // Feedback (Toast / functional)
  static const success = _green500;
  static const successContainer = _green50;
  
  static const error = _red500;
  static const errorContainer = _red50;
  
  static const warning = _orange500;
  static const warningContainer = _orange50;
  
  static const info = _blue500;
  static const infoContainer = _blue50;

  // Legacy mappings for backward compatibility during refactor
  // TODO: Remove these once migration is complete
  static const gray = _neutral400;
  static const darkGray = _neutral800;
  static const silver = _neutral300;
  static const outline = _neutral300;
  static const outlineVariant = _neutral200;
  static const text = textPrimary;
  static const textLight = textSecondary;
  static const cardBackground = surface;
  static const onCardBackground = textPrimary;
}
