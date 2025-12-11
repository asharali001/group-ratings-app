import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing Scale
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Insets (All)
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  // Insets (Horizontal)
  static const EdgeInsets paddingHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);

  // Insets (Vertical)
  static const EdgeInsets paddingVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);

  // Gaps (SizedBox)
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);

  // Semantic Spacing
  static const double pageSpacing = lg;
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
}
