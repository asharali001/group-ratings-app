import 'package:flutter/material.dart';
import '/themes/__themes.dart';
import '/styles/__styles.dart';

class AppTheme {
  static final lightTheme = LightAppTheme.themeData;
  static final darkTheme = DarkAppTheme.themeData;

  // Utility method to get the current theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  // Utility method to get the current color scheme based on brightness
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.light 
        ? lightTheme.colorScheme 
        : darkTheme.colorScheme;
  }

  // Utility method to get the current text theme based on brightness
  static TextTheme getTextTheme(Brightness brightness) {
    return brightness == Brightness.light 
        ? lightTheme.textTheme 
        : darkTheme.textTheme;
  }

  // Utility method to check if current theme is dark
  static bool isDark(ThemeData theme) {
    return theme.brightness == Brightness.dark;
  }

  // Utility method to get appropriate text color based on theme
  static Color getTextColor(ThemeData theme) {
    return isDark(theme) ? AppColors.white : AppColors.text;
  }

  // Utility method to get appropriate background color based on theme
  static Color getBackgroundColor(ThemeData theme) {
    return isDark(theme) ? AppColors.darkGray : AppColors.white;
  }

  // Utility method to get appropriate surface color based on theme
  static Color getSurfaceColor(ThemeData theme) {
    return isDark(theme) ? AppColors.darkGray : AppColors.white;
  }

  // Utility method to get appropriate card color based on theme
  static Color getCardColor(ThemeData theme) {
    return isDark(theme) 
        ? AppColors.darkGray.withValues(alpha: 0.8) 
        : AppColors.white;
  }

  // Utility method to get appropriate border color based on theme
  static Color getBorderColor(ThemeData theme) {
    return isDark(theme) 
        ? AppColors.gray.withValues(alpha: 0.3) 
        : AppColors.gray.withValues(alpha: 0.2);
  }

  // Utility method to get appropriate shadow based on theme
  static List<BoxShadow> getShadow(ThemeData theme, {double elevation = 1.0}) {
    if (isDark(theme)) {
      return elevation == 1.0 
          ? AppShadows.level1Shadow 
          : AppShadows.createShadow(elevation: elevation);
    } else {
      return elevation == 1.0 
          ? AppShadows.level1Shadow 
          : AppShadows.createShadow(elevation: elevation);
    }
  }

  // Utility method to get appropriate border radius based on theme
  static BorderRadius getBorderRadius(ThemeData theme, {double radius = 12.0}) {
    return BorderRadius.circular(radius);
  }

  // Utility method to get appropriate spacing based on theme
  static EdgeInsets getSpacing(ThemeData theme, {EdgeInsets? spacing}) {
    return spacing ?? AppSpacing.paddingMd;
  }

  // Utility method to get appropriate typography based on theme
  static TextStyle getTypography(ThemeData theme, {TextStyle? style}) {
    return style ?? AppTypography.bodyMedium;
  }
}
