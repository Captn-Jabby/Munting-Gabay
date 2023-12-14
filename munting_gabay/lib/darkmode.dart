import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void updateThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
