import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Central Material 3 themes. HomeScreen paints its own aurora
/// backdrop, so scaffolds here are translucent — the theme owns
/// type, controls and contrast, the backdrop owns atmosphere.
class AppTheme {
  static const _font = null; // system font stack (no network fonts)

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: Brightness.dark,
      primary: AppColors.violet,
      secondary: AppColors.fuchsia,
      tertiary: AppColors.cyan,
      surface: AppColors.surfaceDark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: _font,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: Brightness.light,
      primary: AppColors.violet,
      secondary: AppColors.indigo,
      tertiary: const Color(0xFF0E7490),
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: _font,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
