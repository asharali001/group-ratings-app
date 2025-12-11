import 'package:flutter/material.dart';
import '/styles/__styles.dart';

class AppTheme {
  // ===========================================================================
  // Light Theme
  // ===========================================================================
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: _buildColorScheme(Brightness.light),
    );
  }

  // ===========================================================================
  // Dark Theme
  // ===========================================================================
  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: _buildColorScheme(Brightness.dark),
    );
  }

  // ===========================================================================
  // Theme Builder
  // ===========================================================================
  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,

      // Typography
      fontFamily: 'Kanit', // Ensure fallback
      textTheme: _buildTextTheme(colorScheme.onSurface),

      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
          fontWeight: AppTypography.semiBold,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.surfaceVariant : AppColors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
          side: BorderSide(
            color: isDark ? AppColors.transparent : AppColors.border,
            width: 1,
          ),
        ),
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.smRadius,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.smRadius,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.smRadius,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.surfaceVariant : AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTypography.labelSmall.copyWith(color: AppColors.error),
        border: const OutlineInputBorder(
          borderRadius: AppBorderRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.mdRadius,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),

      // Dialogs & Sheets
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.lgRadius,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          fontWeight: AppTypography.semiBold,
          color: colorScheme.onSurface,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        modalBackgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppBorderRadius.xl),
          ),
        ),
      ),

      // Others
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return null;
        }),
      ),
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static ColorScheme _buildColorScheme(Brightness brightness) {
    // We can define semantic overrides for Dark Mode here if needed
    // For now we assume AppColors handles simple light/dark aliasing via static consts?
    // Actually AppColors constants are static.
    // If we want real dark mode support, we need to map colors dynamically.

    final isDark = brightness == Brightness.dark;

    // In a real expanded system we would have AppColors.darkPrimary etc.
    // For this refactor, I will map the logical colors based on brightness.

    return ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,

      error: AppColors.error,
      onError: AppColors.white,

      surface: isDark ? const Color(0xFF0F172A) : AppColors.surface,
      onSurface: isDark ? const Color(0xFFF1F5F9) : AppColors.onSurface,

      // Background is usually same as surface in M3 or slightly different
      surfaceContainerHighest: isDark
          ? const Color(0xFF1E293B)
          : AppColors.surfaceVariant,

      outline: isDark ? const Color(0xFF475569) : AppColors.border,
    );
  }

  static TextTheme _buildTextTheme(Color baseColor) {
    // We apply the base color to all our Typography definitions to ensure passing Theme.of(context).textTheme.bodyMedium comes with the right color.

    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: baseColor),
      displayMedium: AppTypography.displayMedium.copyWith(color: baseColor),
      displaySmall: AppTypography.displaySmall.copyWith(color: baseColor),

      headlineLarge: AppTypography.headlineLarge.copyWith(color: baseColor),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: baseColor),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: baseColor),

      titleLarge: AppTypography.titleLarge.copyWith(color: baseColor),
      titleMedium: AppTypography.titleMedium.copyWith(color: baseColor),
      titleSmall: AppTypography.titleSmall.copyWith(color: baseColor),

      bodyLarge: AppTypography.bodyLarge.copyWith(color: baseColor),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: baseColor),
      bodySmall: AppTypography.bodySmall.copyWith(color: baseColor),

      labelLarge: AppTypography.labelLarge.copyWith(color: baseColor),
      labelMedium: AppTypography.labelMedium.copyWith(color: baseColor),
      labelSmall: AppTypography.labelSmall.copyWith(color: baseColor),
    );
  }
}
