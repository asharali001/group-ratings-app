import 'package:flutter/material.dart';

class AppAnimations {
  
  // Duration scale following Material Design principles
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fastest = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 400);
  static const Duration slowest = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 700);

  // Component-specific durations
  static const Duration buttonPressDuration = fastest;
  static const Duration cardHoverDuration = fast;
  static const Duration pageTransitionDuration = normal;
  static const Duration dialogOpenDuration = slow;
  static const Duration bottomSheetSlideDuration = slow;
  static const Duration listItemAnimationDuration = fast;
  static const Duration inputFocusDuration = fastest;
  static const Duration rippleEffectDuration = normal;
  static const Duration snackbarShowDuration = slow;
  static const Duration loadingSpinnerDuration = slower;

  // Predefined curves for common animations
  static const Curve linear = Curves.linear;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;

  // Custom curves for specific use cases
  static const Curve buttonPressCurve = Curves.easeInOut;
  static const Curve cardHoverCurve = Curves.easeOut;
  static const Curve pageTransitionCurve = Curves.fastOutSlowIn;
  static const Curve dialogOpenCurve = Curves.easeOut;
  static const Curve bottomSheetCurve = Curves.easeOut;
  static const Curve listItemCurve = Curves.easeOut;
  static const Curve inputFocusCurve = Curves.easeInOut;
  static const Curve rippleCurve = Curves.easeOut;
  static const Curve snackbarCurve = Curves.easeOut;
  static const Curve loadingCurve = Curves.linear;



  // Utility methods for creating custom animations
  static Duration customDuration(int milliseconds) {
    return Duration(milliseconds: milliseconds);
  }

  static Duration responsiveDuration(
    Duration baseDuration,
    double screenWidth,
  ) {
    if (screenWidth < 600) {
      // Faster animations for small screens
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.75).round());
    } else if (screenWidth < 1200) {
      return baseDuration; // Medium screens
    } else {
      // Slower animations for large screens
      return Duration(milliseconds: (baseDuration.inMilliseconds * 1.25).round());
    }
  }

  // Predefined animation configurations
  static const AnimationConfig buttonPress = AnimationConfig(
    duration: fastest,
    curve: easeInOut,
  );

  static const AnimationConfig cardHover = AnimationConfig(
    duration: fast,
    curve: easeOut,
  );

  static const AnimationConfig pageTransition = AnimationConfig(
    duration: normal,
    curve: fastOutSlowIn,
  );

  static const AnimationConfig dialogOpen = AnimationConfig(
    duration: slow,
    curve: easeOut,
  );

  static const AnimationConfig bottomSheetSlide = AnimationConfig(
    duration: slow,
    curve: easeOut,
  );

  static const AnimationConfig listItemAnimation = AnimationConfig(
    duration: fast,
    curve: easeOut,
  );

  static const AnimationConfig inputFocus = AnimationConfig(
    duration: fastest,
    curve: easeInOut,
  );

  static const AnimationConfig rippleEffect = AnimationConfig(
    duration: normal,
    curve: easeOut,
  );

  static const AnimationConfig snackbarShow = AnimationConfig(
    duration: slow,
    curve: easeOut,
  );

  static const AnimationConfig loadingSpinner = AnimationConfig(
    duration: slower,
    curve: linear,
  );
}

// Helper class for animation configurations
class AnimationConfig {
  final Duration duration;
  final Curve curve;

  const AnimationConfig({
    required this.duration,
    required this.curve,
  });

  // Utility method to create a copy with modified values
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  // Utility method to create a copy with modified duration
  AnimationConfig withDuration(Duration duration) {
    return copyWith(duration: duration);
  }

  // Utility method to create a copy with modified curve
  AnimationConfig withCurve(Curve curve) {
    return copyWith(curve: curve);
  }
}
