import 'package:flutter/material.dart';

/// Theme mode selection for the Daily Basket Admin app.
enum AppThemeMode { light, dark, system }

/// Single source of truth for the app's theme mode.
///
/// Defaults to [AppThemeMode.system] so the app follows the device's
/// preference out of the box, exactly like modern top apps. The user can
/// switch to a pinned Light or Dark mode from the Settings screen.
class ThemeProvider extends ChangeNotifier {
  AppThemeMode _mode = AppThemeMode.system;

  AppThemeMode get mode => _mode;

  /// Resolves the active [ThemeMode] from the stored [AppThemeMode].
  ThemeMode get themeMode {
    switch (_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  bool get isSystem => _mode == AppThemeMode.system;
  bool get isLight => _mode == AppThemeMode.light;
  bool get isDark => _mode == AppThemeMode.dark;

  void setMode(AppThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void setLight() => setMode(AppThemeMode.light);
  void setDark() => setMode(AppThemeMode.dark);
  void setSystem() => setMode(AppThemeMode.system);
}