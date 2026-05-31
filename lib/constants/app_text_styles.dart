import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle title({bool isDark = true}) => TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w300,
    letterSpacing: 8,
    color: Colors.white,
  );

  static TextStyle subtitle({bool isDark = true}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    letterSpacing: 4,
    color: isDark ? Colors.white54 : Colors.black45,
  );

  static TextStyle heading({bool isDark = true}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: isDark ? Colors.white : Colors.black87,
  );

  static TextStyle body({bool isDark = true}) => TextStyle(
    fontSize: 14,
    color: isDark ? Colors.white54 : Colors.black45,
    height: 1.6,
  );

  static TextStyle cardTitle({bool isDark = true}) => TextStyle(
    fontSize: 14,
    color: isDark ? Colors.white : Colors.black87,
  );

  static TextStyle cardSubtitle({bool isDark = true}) => TextStyle(
    fontSize: 11,
    color: isDark ? Colors.white38 : Colors.black38,
  );

  static TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
    color: Colors.white,
  );
}
