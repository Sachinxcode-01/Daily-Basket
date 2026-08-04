import 'package:flutter/material.dart';

/// State management provider for App Theme settings (System, Light, Dark)
class AppThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedThemeKey = 'light'; // 'system', 'light', 'dark'
  String _selectedThemeLabel = 'Light Mode';

  ThemeMode get themeMode => _themeMode;
  String get selectedThemeKey => _selectedThemeKey;
  String get selectedThemeLabel => _selectedThemeLabel;

  void setTheme(String key) {
    _selectedThemeKey = key;
    if (key == 'system') {
      _themeMode = ThemeMode.system;
      _selectedThemeLabel = 'System Default';
    } else if (key == 'dark') {
      _themeMode = ThemeMode.dark;
      _selectedThemeLabel = 'Dark Mode';
    } else {
      _themeMode = ThemeMode.light;
      _selectedThemeLabel = 'Light Mode';
    }
    notifyListeners();
  }
}
