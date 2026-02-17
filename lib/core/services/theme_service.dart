import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static const String _boxName = 'themeBox';
  static const String _primaryColorKey = 'primaryColor';
  static const String _themeModeKey = 'themeMode';

  static const String _defaultPrimaryColor = '#3713EC';

  Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  String getPrimaryColor() {
    final box = Hive.box(_boxName);
    return box.get(_primaryColorKey, defaultValue: _defaultPrimaryColor)
        as String;
  }

  Future<void> savePrimaryColor(String hexColor) async {
    final box = Hive.box(_boxName);
    await box.put(_primaryColorKey, hexColor);
  }

  ThemeMode getThemeMode() {
    final box = Hive.box(_boxName);
    final modeIndex =
        box.get(_themeModeKey, defaultValue: ThemeMode.system.index) as int;
    return ThemeMode.values[modeIndex];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final box = Hive.box(_boxName);
    await box.put(_themeModeKey, mode.index);
  }
}
