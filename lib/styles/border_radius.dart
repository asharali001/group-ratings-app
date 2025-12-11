import 'package:flutter/material.dart';

class AppBorderRadius {
  // Radius Scale
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double full = 999.0;

  // BorderRadius Objects
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(full));

  // Top Only
  static const BorderRadius topSm = BorderRadius.vertical(top: Radius.circular(sm));
  static const BorderRadius topMd = BorderRadius.vertical(top: Radius.circular(md));
  static const BorderRadius topLg = BorderRadius.vertical(top: Radius.circular(lg));
  static const BorderRadius topXl = BorderRadius.vertical(top: Radius.circular(xl));

  // Bottom Only
  static const BorderRadius bottomSm = BorderRadius.vertical(bottom: Radius.circular(sm));
  static const BorderRadius bottomMd = BorderRadius.vertical(bottom: Radius.circular(md));
  static const BorderRadius bottomLg = BorderRadius.vertical(bottom: Radius.circular(lg));
  static const BorderRadius bottomXl = BorderRadius.vertical(bottom: Radius.circular(xl));

  // Left Only
  static const BorderRadius leftSm = BorderRadius.horizontal(left: Radius.circular(sm));
  static const BorderRadius leftMd = BorderRadius.horizontal(left: Radius.circular(md));
  static const BorderRadius leftLg = BorderRadius.horizontal(left: Radius.circular(lg));
  static const BorderRadius leftXl = BorderRadius.horizontal(left: Radius.circular(xl));

  // Right Only
  static const BorderRadius rightSm = BorderRadius.horizontal(right: Radius.circular(sm));
  static const BorderRadius rightMd = BorderRadius.horizontal(right: Radius.circular(md));
  static const BorderRadius rightLg = BorderRadius.horizontal(right: Radius.circular(lg));
  static const BorderRadius rightXl = BorderRadius.horizontal(right: Radius.circular(xl));
}
