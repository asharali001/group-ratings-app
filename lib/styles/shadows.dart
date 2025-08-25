import 'package:flutter/material.dart';

class AppShadows {
  // Base shadow values following Material Design elevation system
  static const double _baseBlurRadius = 4.0;
  static const double _baseSpreadRadius = 0.0;
  static const Offset _baseOffset = Offset(0, 1);

  // Elevation levels (0-24dp)
  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 3.0;
  static const double level3 = 6.0;
  static const double level4 = 8.0;
  static const double level5 = 12.0;
  static const double level6 = 16.0;
  static const double level7 = 24.0;

  // Predefined shadows for different elevation levels
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> level1Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 1,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level2Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 5,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level3Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 3),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level4Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 2),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 5,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level5Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 3),
      blurRadius: 14,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 6),
      blurRadius: 7,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level6Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 18,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 9,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> level7Shadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 5),
      blurRadius: 22,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 11,
      spreadRadius: 0,
    ),
  ];

  // Component-specific shadows
  static const List<BoxShadow> cardShadow = level1Shadow;
  static const List<BoxShadow> buttonShadow = level1Shadow;
  static const List<BoxShadow> fabShadow = level3Shadow;
  static const List<BoxShadow> dialogShadow = level5Shadow;
  static const List<BoxShadow> bottomSheetShadow = level4Shadow;
  static const List<BoxShadow> appBarShadow = level2Shadow;
  static const List<BoxShadow> chipShadow = level1Shadow;
  static const List<BoxShadow> inputShadow = level1Shadow;

  // Utility methods for creating custom shadows
  static List<BoxShadow> createShadow({
    double elevation = level1,
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    if (elevation == level0) return none;

    final shadowColor = color ?? const Color(0x1F000000);
    final shadowOffset = offset ?? _baseOffset;
    final shadowBlurRadius = blurRadius ?? (elevation * _baseBlurRadius);
    final shadowSpreadRadius = spreadRadius ?? _baseSpreadRadius;

    return [
      BoxShadow(
        color: shadowColor,
        offset: shadowOffset,
        blurRadius: shadowBlurRadius,
        spreadRadius: shadowSpreadRadius,
      ),
    ];
  }

  static List<BoxShadow> createMultiShadow({
    required List<double> elevations,
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    final shadows = <BoxShadow>[];
    
    for (final elevation in elevations) {
      if (elevation > 0) {
        shadows.addAll(createShadow(
          elevation: elevation,
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ));
      }
    }
    
    return shadows;
  }

  // Custom shadow presets
  static List<BoxShadow> get softShadow => [
    const BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get hardShadow => [
    const BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get innerShadow => [
    const BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  // Responsive shadows based on screen size
  static List<BoxShadow> responsiveShadow(
    List<BoxShadow> baseShadow,
    double screenWidth,
  ) {
    if (screenWidth < 600) {
      // Reduce shadow intensity for small screens
      return baseShadow.map((shadow) => shadow.copyWith(
        blurRadius: shadow.blurRadius * 0.75,
        spreadRadius: shadow.spreadRadius * 0.75,
      )).toList();
    } else if (screenWidth < 1200) {
      return baseShadow; // Medium screens
    } else {
      // Increase shadow intensity for large screens
      return baseShadow.map((shadow) => shadow.copyWith(
        blurRadius: shadow.blurRadius * 1.25,
        spreadRadius: shadow.spreadRadius * 1.25,
      )).toList();
    }
  }
}
