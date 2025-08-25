import 'package:flutter/material.dart';

class AppBreakpoints {
  // Material Design breakpoints
  static const double mobile = 600.0; // 0-599dp
  static const double tablet = 900.0; // 600-899dp
  static const double desktop = 1200.0; // 900-1199dp
  static const double largeDesktop = 1600.0; // 1200-1599dp
  static const double extraLargeDesktop = 2000.0; // 1600+dp

  // Custom breakpoints for specific use cases
  static const double smallMobile = 360.0; // Very small mobile devices
  static const double mediumMobile = 480.0; // Medium mobile devices
  static const double largeMobile = 600.0; // Large mobile devices
  static const double smallTablet = 768.0; // Small tablets
  static const double mediumTablet = 900.0; // Medium tablets
  static const double largeTablet = 1024.0; // Large tablets
  static const double smallDesktop = 1200.0; // Small desktop screens
  static const double mediumDesktop = 1440.0; // Medium desktop screens
  static const double largeDesktopScreen = 1600.0; // Large desktop screens

  // Utility methods for responsive design
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
  static bool isLargeDesktop(double width) => width >= largeDesktop;

  static bool isSmallMobile(double width) => width < smallMobile;
  static bool isMediumMobile(double width) => width >= smallMobile && width < mediumMobile;
  static bool isLargeMobile(double width) => width >= mediumMobile && width < largeMobile;
  static bool isSmallTablet(double width) => width >= largeMobile && width < smallTablet;
  static bool isMediumTablet(double width) => width >= smallTablet && width < mediumTablet;
  static bool isLargeTablet(double width) => width >= mediumTablet && width < largeTablet;

  // Responsive value helper
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= AppBreakpoints.largeDesktop && largeDesktop != null) {
      return largeDesktop;
    } else if (width >= AppBreakpoints.desktop && desktop != null) {
      return desktop;
    } else if (width >= AppBreakpoints.tablet && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Responsive double value helper
  static double responsiveDouble({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Responsive int value helper
  static int responsiveInt({
    required BuildContext context,
    required int mobile,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Responsive EdgeInsets helper
  static EdgeInsets responsivePadding({
    required BuildContext context,
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Responsive BorderRadius helper
  static BorderRadius responsiveBorderRadius({
    required BuildContext context,
    required BorderRadius mobile,
    BorderRadius? tablet,
    BorderRadius? desktop,
    BorderRadius? largeDesktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Responsive TextStyle helper
  static TextStyle responsiveTextStyle({
    required BuildContext context,
    required TextStyle mobile,
    TextStyle? tablet,
    TextStyle? desktop,
    TextStyle? largeDesktop,
  }) {
    return responsiveValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Screen size categories
  static String getScreenSizeCategory(double width) {
    if (width < mobile) return 'mobile';
    if (width < desktop) return 'tablet';
    if (width < largeDesktop) return 'desktop';
    return 'large-desktop';
  }

  // Orientation helpers
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Device pixel ratio helpers
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static bool isHighDensity(BuildContext context) {
    return getDevicePixelRatio(context) >= 2.0;
  }

  static bool isLowDensity(BuildContext context) {
    return getDevicePixelRatio(context) < 1.5;
  }

  // Safe area helpers
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double getTopPadding(BuildContext context) {
    return getSafeAreaPadding(context).top;
  }

  static double getBottomPadding(BuildContext context) {
    return getSafeAreaPadding(context).bottom;
  }

  static double getLeftPadding(BuildContext context) {
    return getSafeAreaPadding(context).left;
  }

  static double getRightPadding(BuildContext context) {
    return getSafeAreaPadding(context).right;
  }
}
