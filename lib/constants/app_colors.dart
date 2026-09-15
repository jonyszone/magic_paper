import 'package:flutter/material.dart';

/// Magic Paper design tokens — single source of truth for color.
///
/// Dark is the hero theme (midnight mystic). Light is a soft
/// lavender-paper theme with the same hue family so the brand
/// survives the mode switch.
class AppColors {
  // ── Brand ──────────────────────────────────────────────
  static const Color violet = Color(0xFF7C3AED);
  static const Color indigo = Color(0xFF4F46E5);
  static const Color fuchsia = Color(0xFFE879F9);
  static const Color lavender = Color(0xFFD8B4FE);
  static const Color iceBlue = Color(0xFF818CF8);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color gold = Color(0xFFFACC15);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [violet, indigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandTextGradient = LinearGradient(
    colors: [fuchsia, iceBlue],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFACC15), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Dark surfaces ──────────────────────────────────────
  static const Color bgDark = Color(0xFF060412);
  static const Color bgDarkTop = Color(0xFF0D0B2B);
  static const Color surfaceDark = Color(0xFF140F2E);
  static const Color cardDark = Color(0xFF151932);

  // ── Light surfaces ─────────────────────────────────────
  static const Color bgLight = Color(0xFFF6F2FF);
  static const Color bgLightTop = Color(0xFFFFFFFF);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;

  // Legacy aliases (kept so older widgets keep compiling).
  static const Color primary = violet;
  static const Color primaryLight = lavender;
  static const Color primaryDark = Color(0xFF651FFF);
  static const Color backgroundDark = Color(0xFF0A0E21);
  static const Color backgroundDarkLight = Color(0xFF1A1F3A);
  static const Color backgroundLight = bgLight;
  static const Color backgroundLightLight = Color(0xFFE8E0FF);
  static const Color borderDark = Color(0xFF2A2F4F);
  static const Color borderLight = Color(0xFFE0D0FF);

  // ── Helpers ────────────────────────────────────────────
  static Color textPrimary(bool isDark) =>
      isDark ? Colors.white : const Color(0xFF1E1B3A);

  static Color textSecondary(bool isDark) => isDark
      ? Colors.white.withOpacity(0.6)
      : const Color(0xFF1E1B3A).withOpacity(0.6);

  static Color textTertiary(bool isDark) => isDark
      ? Colors.white.withOpacity(0.38)
      : const Color(0xFF1E1B3A).withOpacity(0.42);

  static Color glassFill(bool isDark) => isDark
      ? Colors.white.withOpacity(0.055)
      : Colors.white.withOpacity(0.75);

  static Color glassBorder(bool isDark) => isDark
      ? Colors.white.withOpacity(0.11)
      : const Color(0xFF7C3AED).withOpacity(0.14);

  static Color track(bool isDark) =>
      isDark ? Colors.white.withOpacity(0.1) : const Color(0xFF1E1B3A).withOpacity(0.08);
}
