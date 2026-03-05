import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static final _box = GetStorage();
  static const _key = 'appearanceMode';

  static ThemeMode get theme {
    final mode = appearenceMode;
    if (mode == ThemeMode.dark.name) return ThemeMode.dark;
    if (mode == ThemeMode.light.name) return ThemeMode.light;
    return ThemeMode.system;
  }

  static String get appearenceMode => _box.read(_key) ?? ThemeMode.system.name;

  static _saveThemeToBox(String appearanceMode) =>
      _box.write(_key, appearanceMode);

  static void switchTheme(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    _saveThemeToBox(themeMode.name);
  }
}
