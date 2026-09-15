import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Single source of truth for light / dark. Exposes [isDark] so
/// custom-painted backdrops can adapt instead of hard-coding night.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;
  bool get isDark => _isDarkMode;
  ThemeData get theme => _isDarkMode ? AppTheme.dark : AppTheme.light;
  ThemeMode get mode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDark(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
  }
}
