import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Premium type scale. All text goes through here so tracking,
/// weight and contrast stay consistent on both themes.
class AppTextStyles {
  // Display — hero headlines.
  static TextStyle display(bool isDark, {double size = 42}) => TextStyle(
        fontSize: size,
        height: 1.06,
        letterSpacing: -1.2,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle displaySm(bool isDark) => TextStyle(
        fontSize: 32,
        height: 1.1,
        letterSpacing: -0.8,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary(isDark),
      );

  // Section title inside a flow.
  static TextStyle headline(bool isDark, {double size = 26}) => TextStyle(
        fontSize: size,
        height: 1.15,
        letterSpacing: -0.4,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary(isDark),
      );

  static TextStyle titleSm(bool isDark) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.textPrimary(isDark),
      );

  // Body copy.
  static TextStyle body(bool isDark, {double size = 15}) => TextStyle(
        fontSize: size,
        height: 1.65,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary(isDark),
      );

  static TextStyle caption(bool isDark) => TextStyle(
        fontSize: 12.5,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary(isDark),
      );

  // Eyebrow / kicker label.
  static TextStyle eyebrow(bool isDark) => TextStyle(
        fontSize: 12,
        letterSpacing: 2.6,
        fontWeight: FontWeight.w700,
        color: AppColors.textTertiary(isDark),
      );

  // Brand wordmark.
  static const TextStyle wordmark = TextStyle(
    fontSize: 13,
    letterSpacing: 3.2,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // Buttons.
  static const TextStyle cta = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: Colors.white,
  );

  static const TextStyle ctaSm = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: Colors.white,
  );

  // Legacy API (kept compiling for older widgets).
  static TextStyle title({bool isDark = true}) =>
      display(isDark, size: 32).copyWith(
        fontWeight: FontWeight.w300,
        letterSpacing: 6,
      );
  static TextStyle subtitle({bool isDark = true}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 4,
        color: isDark ? Colors.white54 : Colors.black45,
      );
  static TextStyle heading({bool isDark = true}) => headline(isDark);
  static TextStyle cardTitle({bool isDark = true}) => titleSm(isDark);
  static TextStyle cardSubtitle({bool isDark = true}) => caption(isDark);
  static const TextStyle button = ctaSm;
}
