import 'package:flutter/services.dart';

/// One-liner haptics so every CTA feels tactile without littering
/// `HapticFeedback` calls across screens.
class MagicHaptics {
  static void tap() => HapticFeedback.selectionClick();
  static void step() => HapticFeedback.lightImpact();
  static void reveal() => HapticFeedback.mediumImpact();
  static void magic() => HapticFeedback.heavyImpact();
}
