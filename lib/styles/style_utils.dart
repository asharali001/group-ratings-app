import 'package:flutter/material.dart';
import 'colors.dart';
import 'spacing.dart';
import 'border_radius.dart';
import 'shadows.dart';
import 'typography.dart';
import 'sizes.dart';
import 'breakpoints.dart';

class AppStyleUtils {
  // Common decoration patterns
  static BoxDecoration get cardDecoration => const BoxDecoration(
    color: AppColors.white,
    borderRadius: AppBorderRadius.lgRadius,
    boxShadow: AppShadows.cardShadow,
  );

  static BoxDecoration get buttonDecoration => const BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppBorderRadius.mdRadius,
    boxShadow: AppShadows.buttonShadow,
  );

  static BoxDecoration get inputDecoration => BoxDecoration(
    color: AppColors.white,
    borderRadius: AppBorderRadius.mdRadius,
    border: Border.all(color: AppColors.gray),
  );

  static BoxDecoration get chipDecoration => BoxDecoration(
    color: AppColors.gray.withValues(alpha: 0.1),
    borderRadius: AppBorderRadius.fullRadius,
    border: Border.all(color: AppColors.gray.withValues(alpha: 0.3)),
  );

  // Common text styles with colors
  static TextStyle get headingText => AppTypography.headlineMedium.copyWith(
    color: AppColors.text,
    fontWeight: AppTypography.semiBold,
  );

  static TextStyle get subheadingText => AppTypography.titleLarge.copyWith(
    color: AppColors.textLight,
    fontWeight: AppTypography.medium,
  );

  static TextStyle get bodyText => AppTypography.bodyMedium.copyWith(
    color: AppColors.text,
  );

  static TextStyle get captionText => AppTypography.bodySmall.copyWith(
    color: AppColors.textLight,
  );

  static TextStyle get buttonText => AppTypography.labelLarge.copyWith(
    color: AppColors.white,
    fontWeight: AppTypography.medium,
  );

  static TextStyle get linkText => AppTypography.bodyMedium.copyWith(
    color: AppColors.info,
    decoration: TextDecoration.underline,
  );

  // Common input decoration
  static InputDecoration get standardInputDecoration => const InputDecoration(
    filled: true,
    fillColor: AppColors.white,
    contentPadding: AppSpacing.inputPadding,
    border: OutlineInputBorder(
      borderRadius: AppBorderRadius.mdRadius,
      borderSide: BorderSide(color: AppColors.gray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.mdRadius,
      borderSide: BorderSide(color: AppColors.gray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.mdRadius,
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.mdRadius,
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.mdRadius,
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
  );

  // Common button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    padding: AppSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mdRadius,
    ),
    elevation: AppShadows.level1,
    minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.primary,
    padding: AppSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mdRadius,
      side: BorderSide(color: AppColors.primary),
    ),
    elevation: 0,
    minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
  );

  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: AppSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mdRadius,
    ),
    minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
  );

  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary),
    padding: AppSpacing.buttonPadding,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mdRadius,
    ),
    minimumSize: const Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
  );

  // Common card styles
  static Card get standardCard => const Card(
    elevation: AppShadows.level1,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.lgRadius,
    ),
    margin: EdgeInsets.all(AppSizes.cardMargin),
    child: Padding(
      padding: EdgeInsets.all(AppSizes.cardContentPadding),
      child: null, // Child will be set when used
    ),
  );

  // Common list tile styles
  static ListTileThemeData get standardListTileTheme => const ListTileThemeData(
    contentPadding: AppSpacing.listTilePadding,
    horizontalTitleGap: AppSpacing.md,
    minLeadingWidth: AppSizes.listTileLeadingWidth,
    minVerticalPadding: AppSizes.listTileMinVerticalPadding,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.mdRadius,
    ),
  );

  // Common app bar styles
  static AppBarTheme get standardAppBarTheme => AppBarTheme(
    elevation: AppShadows.level2,
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.text,
    centerTitle: true,
    titleTextStyle: headingText,
    iconTheme: const IconThemeData(
      color: AppColors.text,
      size: AppSizes.mediumIconSize,
    ),
  );

  // Common bottom navigation styles
  static BottomNavigationBarThemeData get standardBottomNavigationTheme => const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.gray,
    type: BottomNavigationBarType.fixed,
    elevation: AppShadows.level3,
  );

  // Common floating action button styles
  static FloatingActionButtonThemeData get standardFabTheme => const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: AppShadows.level3,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.fullRadius,
    ),
  );

  // Common dialog styles
  static DialogTheme get standardDialogTheme => DialogTheme(
    backgroundColor: AppColors.white,
    elevation: AppShadows.level5,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.xlRadius,
    ),
    titleTextStyle: headingText,
    contentTextStyle: bodyText,
  );

  // Common bottom sheet styles
  static BottomSheetThemeData get standardBottomSheetTheme => const BottomSheetThemeData(
    backgroundColor: AppColors.white,
    elevation: AppShadows.level4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppBorderRadius.xl),
        topRight: Radius.circular(AppBorderRadius.xl),
      ),
    ),
  );

  // Utility methods for creating custom styles
  static BoxDecoration createDecoration({
    Color? color,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.white,
      borderRadius: borderRadius ?? BorderRadius.zero,
      boxShadow: boxShadow ?? AppShadows.none,
      border: border,
    );
  }

  static TextStyle createTextStyle({
    TextStyle? baseStyle,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextDecoration? decoration,
  }) {
    final style = baseStyle ?? AppTypography.bodyMedium;
    return style.copyWith(
      color: color ?? style.color,
      fontWeight: fontWeight ?? style.fontWeight,
      fontSize: fontSize ?? style.fontSize,
      decoration: decoration ?? style.decoration,
    );
  }

  static InputDecoration createInputDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
  }) {
    return standardInputDecoration.copyWith(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: BorderSide(color: borderColor ?? AppColors.gray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: BorderSide(color: borderColor ?? AppColors.gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: BorderSide(color: focusedBorderColor ?? AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: BorderSide(color: errorBorderColor ?? AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: BorderSide(color: errorBorderColor ?? AppColors.error, width: 2),
      ),
    );
  }

  // Responsive style helpers
  static BoxDecoration responsiveDecoration({
    required BuildContext context,
    required BoxDecoration mobile,
    BoxDecoration? tablet,
    BoxDecoration? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= AppBreakpoints.desktop && desktop != null) {
      return desktop;
    } else if (width >= AppBreakpoints.tablet && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static TextStyle responsiveTextStyle({
    required BuildContext context,
    required TextStyle mobile,
    TextStyle? tablet,
    TextStyle? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= AppBreakpoints.desktop && desktop != null) {
      return desktop;
    } else if (width >= AppBreakpoints.tablet && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
