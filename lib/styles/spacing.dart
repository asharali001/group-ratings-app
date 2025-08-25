import 'package:flutter/material.dart';

class AppSpacing {
  // Base spacing unit (4dp)
  static const double _baseUnit = 4.0;
  
  // Spacing scale following Material Design 4dp grid system
  static const double none = 0.0;
  static const double xs = _baseUnit; // 4dp
  static const double sm = _baseUnit * 2; // 8dp
  static const double md = _baseUnit * 4; // 16dp
  static const double lg = _baseUnit * 6; // 24dp
  static const double xl = _baseUnit * 8; // 32dp
  static const double xxl = _baseUnit * 12; // 48dp
  static const double xxxl = _baseUnit * 16; // 64dp

  // Specific spacing values for common use cases
  static const double iconSpacing = sm; // 8dp
  static const double contentSpacing = md; // 16dp
  static const double sectionSpacing = lg; // 24dp
  static const double pageSpacing = xl; // 32dp
  static const double screenSpacing = xxl; // 48dp

  // Padding constants
  static const EdgeInsets paddingNone = EdgeInsets.zero;
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // Margin constants
  static const EdgeInsets marginNone = EdgeInsets.zero;
  static const EdgeInsets marginXs = EdgeInsets.all(xs);
  static const EdgeInsets marginSm = EdgeInsets.all(sm);
  static const EdgeInsets marginMd = EdgeInsets.all(md);
  static const EdgeInsets marginLg = EdgeInsets.all(lg);
  static const EdgeInsets marginXl = EdgeInsets.all(xl);

  // Horizontal margin
  static const EdgeInsets marginHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets marginHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets marginHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets marginHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical margin
  static const EdgeInsets marginVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets marginVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // Common layout spacing
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets dialogPadding = EdgeInsets.all(lg);
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(lg);

  // Utility methods for creating custom spacing
  static EdgeInsets only({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  static EdgeInsets symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  static EdgeInsets all(double value) {
    return EdgeInsets.all(value);
  }

  // Responsive spacing based on screen size
  static double responsiveSpacing(double baseSpacing, double screenWidth) {
    if (screenWidth < 600) {
      return baseSpacing * 0.75; // Small screens
    } else if (screenWidth < 1200) {
      return baseSpacing; // Medium screens
    } else {
      return baseSpacing * 1.25; // Large screens
    }
  }
}
