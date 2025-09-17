import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/styles/__styles.dart';

class LightAppTheme {
  static final themeData = ThemeData.light(
    useMaterial3: true,
  ).copyWith(textTheme: _textTheme, scaffoldBackgroundColor: AppColors.surface);

  static final _textTheme = GoogleFonts.outfitTextTheme().apply();
}
