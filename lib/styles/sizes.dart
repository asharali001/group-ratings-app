class AppSizes {
  // Base size unit (4dp)
  static const double _baseUnit = 4.0;
  
  // Size scale following Material Design 4dp grid system
  static const double none = 0.0;
  static const double xs = _baseUnit; // 4dp
  static const double sm = _baseUnit * 2; // 8dp
  static const double md = _baseUnit * 4; // 16dp
  static const double lg = _baseUnit * 6; // 24dp
  static const double xl = _baseUnit * 8; // 32dp
  static const double xxl = _baseUnit * 12; // 48dp
  static const double xxxl = _baseUnit * 16; // 64dp

  // Elevation values
  static const double elevation = 3.0;
  static const double bottomElevation = 8.0;

  // Padding values (using the new spacing system)
  static const double exSmallPadding = xs; // 4dp
  static const double smallPadding = sm; // 8dp
  static const double mediumPadding = md; // 16dp
  static const double largePadding = lg; // 24dp
  static const double extraLargePadding = xl; // 32dp

  // Icon sizes
  static const double exSmallIconSize = 14;
  static const double smallIconSize = 18;
  static const double mediumIconSize = 24;
  static const double largeIconSize = 32;
  static const double extraLargeIconSize = 48;

  // Border radius values (using the new border radius system)
  static const double chipRadius = sm; // 8dp
  static const double cardRadius = md; // 12dp
  static const double fabRadius = lg; // 16dp
  static const double buttonRadius = sm; // 8dp
  static const double roundRadius = xxl; // 48dp
  static const double textFieldRadius = xxl; // 48dp

  // Component sizes
  static const double appBarHeight = 56.0;
  static const double tabHeight = 56.0;
  static const double tabWidth = 65.0;
  static const double bottomNavigationHeight = 56.0;
  static const double floatingActionButtonSize = 56.0;
  static const double iconButtonSize = 48.0;
  static const double smallIconButtonSize = 40.0;
  static const double largeIconButtonSize = 64.0;

  // List and grid sizes
  static const double listTileHeight = 56.0;
  static const double listTileLeadingWidth = 40.0;
  static const double listTileMinVerticalPadding = 0.0;
  static const double gridSpacing = md; // 16dp
  static const double gridCrossAxisCount = 2.0;

  // Dialog and modal sizes
  static const double dialogWidth = 400.0;
  static const double dialogMaxWidth = 600.0;
  static const double bottomSheetMaxHeight = 0.9; // 90% of screen height
  static const double snackBarHeight = 48.0;

  // Input and form sizes
  static const double inputHeight = 48.0;
  static const double inputBorderWidth = 1.0;
  static const double inputFocusedBorderWidth = 2.0;
  static const double checkboxSize = 18.0;
  static const double radioSize = 18.0;
  static const double switchWidth = 40.0;
  static const double switchHeight = 24.0;

  // Card sizes
  static const double cardElevation = 1.0;
  static const double cardMargin = 8.0;
  static const double cardContentPadding = 16.0;

  // Button sizes
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 88.0;
  static const double buttonIconSpacing = 8.0;
  static const double buttonTextSpacing = 8.0;

  // Chip sizes
  static const double chipHeight = 32.0;
  static const double chipLabelPadding = 12.0;
  static const double chipAvatarSize = 20.0;

  // Divider sizes
  static const double dividerThickness = 0.5;
  static const double dividerSpace = 16.0;

  // Progress indicator sizes
  static const double linearProgressIndicatorHeight = 4.0;
  static const double circularProgressIndicatorSize = 24.0;
  static const double largeCircularProgressIndicatorSize = 48.0;

  // Utility methods for creating custom sizes
  static double customSize(double multiplier) {
    return _baseUnit * multiplier;
  }

  static double responsiveSize(
    double baseSize,
    double screenWidth,
  ) {
    if (screenWidth < 600) {
      return baseSize * 0.75; // Small screens
    } else if (screenWidth < 1200) {
      return baseSize; // Medium screens
    } else {
      return baseSize * 1.25; // Large screens
    }
  }

  // Predefined size configurations for common components
  static const Map<String, double> buttonSizes = {
    'small': 36.0,
    'medium': 48.0,
    'large': 56.0,
  };

  static const Map<String, double> iconSizes = {
    'small': 16.0,
    'medium': 24.0,
    'large': 32.0,
    'extraLarge': 48.0,
  };

  static const Map<String, double> paddingSizes = {
    'none': 0.0,
    'small': 8.0,
    'medium': 16.0,
    'large': 24.0,
    'extraLarge': 32.0,
  };
}