import 'package:flutter/material.dart';

class AppBorderRadius {
  // Base radius unit (4dp)
  static const double _baseUnit = 4.0;
  
  // Border radius scale following Material Design principles
  static const double none = 0.0;
  static const double xs = _baseUnit; // 4dp
  static const double sm = _baseUnit * 2; // 8dp
  static const double md = _baseUnit * 3; // 12dp
  static const double lg = _baseUnit * 4; // 16dp
  static const double xl = _baseUnit * 6; // 24dp
  static const double xxl = _baseUnit * 7; // 28dp
  static const double xxxl = _baseUnit * 8; // 32dp
  static const double round = _baseUnit * 12; // 48dp
  static const double circular = _baseUnit * 16; // 64dp

  // Predefined BorderRadius objects for common use cases
  static const BorderRadius noneRadius = BorderRadius.zero;
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlRadius = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius xxxlRadius = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius roundRadius = BorderRadius.all(Radius.circular(round));
  static const BorderRadius circularRadius = BorderRadius.all(Radius.circular(circular));

  // Specific component radius values
  static const double buttonRadius = sm; // 8dp
  static const double cardRadius = md; // 12dp
  static const double chipRadius = sm; // 8dp
  static const double fabRadius = lg; // 16dp
  static const double textFieldRadius = xxl; // 28dp
  static const double dialogRadius = md; // 12dp
  static const double bottomSheetRadius = md; // 12dp
  static const double appBarRadius = none; // 0dp
  static const double listTileRadius = round; // 48dp

  // Predefined BorderRadius for components
  static const BorderRadius buttonRadiusObj = BorderRadius.all(Radius.circular(buttonRadius));
  static const BorderRadius cardRadiusObj = BorderRadius.all(Radius.circular(cardRadius));
  static const BorderRadius chipRadiusObj = BorderRadius.all(Radius.circular(chipRadius));
  static const BorderRadius fabRadiusObj = BorderRadius.all(Radius.circular(fabRadius));
  static const BorderRadius textFieldRadiusObj = BorderRadius.all(Radius.circular(textFieldRadius));
  static const BorderRadius dialogRadiusObj = BorderRadius.all(Radius.circular(dialogRadius));
  static const BorderRadius bottomSheetRadiusObj = BorderRadius.all(Radius.circular(bottomSheetRadius));
  static const BorderRadius appBarRadiusObj = BorderRadius.all(Radius.circular(appBarRadius));
  static const BorderRadius listTileRadiusObj = BorderRadius.all(Radius.circular(listTileRadius));

  // Utility methods for creating custom border radius
  static BorderRadius all(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  static BorderRadius only({
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  static BorderRadius symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(horizontal),
      topRight: Radius.circular(horizontal),
      bottomLeft: Radius.circular(vertical),
      bottomRight: Radius.circular(vertical),
    );
  }

  // Top radius only
  static BorderRadius topOnly(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    );
  }

  // Bottom radius only
  static BorderRadius bottomOnly(double radius) {
    return BorderRadius.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  // Left radius only
  static BorderRadius leftOnly(double radius) {
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    );
  }

  // Right radius only
  static BorderRadius rightOnly(double radius) {
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
  }

  // Responsive border radius based on screen size
  static double responsiveRadius(double baseRadius, double screenWidth) {
    if (screenWidth < 600) {
      return baseRadius * 0.75; // Small screens
    } else if (screenWidth < 1200) {
      return baseRadius; // Medium screens
    } else {
      return baseRadius * 1.25; // Large screens
    }
  }
}
