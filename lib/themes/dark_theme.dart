import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/styles/__styles.dart';

class DarkAppTheme {
  static final themeData = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    scaffoldBackgroundColor: _colorScheme.surface,
    appBarTheme: _appBarTheme,
    tabBarTheme: _tabBarTheme,
    dividerTheme: _dividerTheme,
    drawerTheme: _drawerTheme,
    listTileTheme: _listTileTheme,
    cardTheme: _cardTheme,
    radioTheme: _radioTheme,
    checkboxTheme: _checkboxTheme,
    floatingActionButtonTheme: _fabTheme,
    inputDecorationTheme: _inputDecorationTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _chipTheme,
    dialogTheme: _dialogThemeData,
    bottomSheetTheme: _bottomSheetTheme,
  );

  static final _colorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,
  );

  static final _textTheme = GoogleFonts.outfitTextTheme().apply(
    bodyColor: _colorScheme.onSurface,
    displayColor: _colorScheme.onSurface,
  );

  static final _appBarTheme = AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColors.transparent,
    ),
    elevation: AppShadows.level2,
    backgroundColor: _colorScheme.surface,
    foregroundColor: _colorScheme.onSurface,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: _colorScheme.onSurface,
      size: AppSizes.mediumIconSize,
    ),
    titleTextStyle: AppTypography.titleLarge.copyWith(
      color: _colorScheme.onSurface,
      fontWeight: AppTypography.semiBold,
    ),
    titleSpacing: AppSpacing.md,
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.bottomOnly(AppBorderRadius.md),
    ),
  );

  static final _fabTheme = FloatingActionButtonThemeData(
    elevation: AppShadows.level3,
    backgroundColor: _colorScheme.tertiaryContainer,
    foregroundColor: _colorScheme.onTertiaryContainer,
    extendedIconLabelSpacing: AppSpacing.iconSpacing,
    extendedTextStyle: _textTheme.labelLarge,
    extendedPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.fabRadiusObj,
    ),
  );

  static final _dividerTheme = DividerThemeData(
    color: _colorScheme.surfaceContainerHighest,
    thickness: AppSizes.dividerThickness,
    space: AppSizes.dividerSpace,
  );

  static final _drawerTheme = DrawerThemeData(
    elevation: AppShadows.level5,
    backgroundColor: _colorScheme.surface,
    scrimColor: _colorScheme.inverseSurface.withValues(alpha: 0.4),
    shape: RoundedRectangleBorder(
      borderRadius: AppBorderRadius.rightOnly(AppBorderRadius.md),
    ),
  );

  /////////// TabBar Theme //////////////
  static final _tabBarTheme = TabBarThemeData(
    labelColor: _colorScheme.primary,
    unselectedLabelColor: _colorScheme.onSurfaceVariant,
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: AppTypography.labelMedium,
    unselectedLabelStyle: AppTypography.labelMedium,
  );

  static final _listTileTheme = ListTileThemeData(
    contentPadding: AppSpacing.listTilePadding,
    horizontalTitleGap: AppSpacing.md,
    minLeadingWidth: AppSizes.listTileLeadingWidth,
    minVerticalPadding: AppSizes.listTileMinVerticalPadding,
    tileColor: _colorScheme.surface,
    selectedTileColor: _colorScheme.secondaryContainer,
    selectedColor: _colorScheme.onSecondaryContainer,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.listTileRadiusObj,
    ),
  );

  /////////// Card Theme //////////////
  static final _cardTheme = CardThemeData(
    elevation: AppShadows.level1,
    color: _colorScheme.surfaceContainerHighest,
    margin: const EdgeInsets.all(AppSizes.cardMargin),
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.cardRadiusObj,
    ),
  );

  /////////// Radio Theme //////////////
  static final _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colorScheme.primary;
      } else if (states.contains(WidgetState.disabled)) {
        return AppColors.silver;
      } else {
        return AppColors.darkGray;
      }
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  /////////// Checkbox Theme //////////////
  static final _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return _colorScheme.primary;
      } else if (states.contains(WidgetState.disabled)) {
        return AppColors.silver;
      } else {
        return AppColors.darkGray;
      }
    }),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: const RoundedRectangleBorder(borderRadius: AppBorderRadius.xsRadius),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: _colorScheme.surfaceContainerHighest,
    errorMaxLines: 3,
    contentPadding: AppSpacing.inputPadding,
    labelStyle: AppTypography.labelLarge.copyWith(
      color: _colorScheme.onSurfaceVariant,
    ),
    hintStyle: AppTypography.labelLarge.copyWith(
      color: _colorScheme.onSurfaceVariant,
    ),
    errorStyle: AppTypography.labelSmall.copyWith(color: _colorScheme.error),
    helperStyle: AppTypography.labelSmall,
    counterStyle: AppTypography.labelSmall,
    border: const OutlineInputBorder(
      borderRadius: AppBorderRadius.textFieldRadiusObj,
      borderSide: BorderSide.none,
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: AppBorderRadius.textFieldRadiusObj,
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.textFieldRadiusObj,
      borderSide: BorderSide(color: _colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppBorderRadius.textFieldRadiusObj,
      borderSide: BorderSide(
        color: _colorScheme.error,
        width: AppSizes.inputFocusedBorderWidth,
      ),
    ),
  );

  /////////// Bottom Navigation Theme //////////////
  static final _bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: _colorScheme.surface,
    selectedItemColor: _colorScheme.primary,
    unselectedItemColor: _colorScheme.onSurfaceVariant,
    type: BottomNavigationBarType.fixed,
    elevation: AppShadows.level3,
    selectedLabelStyle: AppTypography.labelSmall,
    unselectedLabelStyle: AppTypography.labelSmall,
  );

  /////////// Elevated Button Theme //////////////
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: AppStyleUtils.primaryButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(_colorScheme.primary),
      foregroundColor: WidgetStateProperty.all(_colorScheme.onPrimary),
    ),
  );

  /////////// Outlined Button Theme //////////////
  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: AppStyleUtils.outlinedButtonStyle.copyWith(
      foregroundColor: WidgetStateProperty.all(_colorScheme.primary),
      side: WidgetStateProperty.all(BorderSide(color: _colorScheme.primary)),
    ),
  );

  /////////// Text Button Theme //////////////
  static final _textButtonTheme = TextButtonThemeData(
    style: AppStyleUtils.textButtonStyle.copyWith(
      foregroundColor: WidgetStateProperty.all(_colorScheme.primary),
    ),
  );

  /////////// Chip Theme //////////////
  static final _chipTheme = ChipThemeData(
    backgroundColor: _colorScheme.surfaceContainerHighest,
    selectedColor: _colorScheme.primaryContainer,
    labelStyle: AppTypography.labelMedium,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSizes.chipLabelPadding,
      vertical: AppSpacing.xs,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.chipRadiusObj,
    ),
    elevation: AppShadows.level1,
  );

  /////////// Dialog Theme //////////////
  static final _dialogThemeData = DialogThemeData(
    backgroundColor: _colorScheme.surface,
    elevation: AppShadows.level5,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.dialogRadiusObj,
    ),
    titleTextStyle: AppTypography.titleLarge.copyWith(
      color: _colorScheme.onSurface,
    ),
    contentTextStyle: AppTypography.bodyMedium.copyWith(
      color: _colorScheme.onSurfaceVariant,
    ),
  );

  /////////// Bottom Sheet Theme //////////////
  static final _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: _colorScheme.surface,
    elevation: AppShadows.level4,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppBorderRadius.dialogRadius),
        topRight: Radius.circular(AppBorderRadius.dialogRadius),
      ),
    ),
  );
}
