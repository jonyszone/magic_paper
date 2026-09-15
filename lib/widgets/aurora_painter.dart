import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Layered aurora backdrop. Adapts to light / dark so light mode
/// feels like dawn-lavender instead of a broken dark screen.
class AuroraPainter extends CustomPainter {
  final double t;
  final bool isDark;
  AuroraPainter(this.t, {this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base wash.
    final bg = Paint()
      ..shader = (isDark
              ? const RadialGradient(
                  center: Alignment(0, -0.35),
                  radius: 1.25,
                  colors: [Color(0xFF0D0B2B), Color(0xFF060412)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF1E8FF)],
                ))
          .createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);

    // Nebula blobs.
    if (isDark) {
      _blob(canvas, size, Offset(w * 0.18, h * 0.22), w * 0.75,
          const Color(0xFF6B21A8), 0.20, t);
      _blob(canvas, size, Offset(w * 0.8, h * 0.12), w * 0.6,
          const Color(0xFF4F46E5), 0.16, t + 1.2);
      _blob(canvas, size, Offset(w * 0.5, h * 0.62), w * 0.65,
          const Color(0xFF7C3AED), 0.13, t + 2.4);
      _blob(canvas, size, Offset(w * 0.08, h * 0.72), w * 0.5,
          const Color(0xFF2563EB), 0.11, t + 0.8);
      _blob(canvas, size, Offset(w * 0.9, h * 0.55), w * 0.4,
          const Color(0xFFE879F9), 0.07, t + 3.4);
    } else {
      _blob(canvas, size, Offset(w * 0.2, h * 0.18), w * 0.8,
          const Color(0xFFDDD6FE), 0.9, t);
      _blob(canvas, size, Offset(w * 0.82, h * 0.1), w * 0.6,
          const Color(0xFFF5D0FE), 0.8, t + 1.2);
      _blob(canvas, size, Offset(w * 0.5, h * 0.6), w * 0.7,
          const Color(0xFFE0E7FF), 0.9, t + 2.4);
    }

    // Vignette for depth (dark only).
    if (isDark) {
      final vig = Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, 0),
          radius: 1.05,
          colors: [Colors.transparent, Colors.black.withOpacity(0.42)],
          stops: const [0.55, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawRect(Rect.fromLTWH(0, 0, w, h), vig);
    }
  }

  void _blob(Canvas canvas, Size size, Offset center, double radius,
      Color color, double opacity, double phase) {
    final dx = sin(phase * 0.7) * size.width * 0.07;
    final dy = cos(phase * 0.5) * size.height * 0.045;
    final c = center + Offset(dx, dy);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(opacity), color.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: c, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(AuroraPainter old) =>
      old.t != t || old.isDark != isDark;
}

/// Twinkling starfield drawn above the aurora (dark mode only).
class StarfieldPainter extends CustomPainter {
  final double t;
  final int count;
  final int seed;
  StarfieldPainter(this.t, {this.count = 90, this.seed = 99});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rng = Random(seed);
    final paint = Paint();
    for (int i = 0; i < count; i++) {
      final x = rng.nextDouble() * w;
      final y = rng.nextDouble() * h * 0.85;
      final base = 0.5 + rng.nextDouble() * 1.1;
      final tw = 0.5 + 0.5 * sin(t * 2.4 + i * 1.7);
      paint.color = Colors.white.withOpacity(0.08 + tw * 0.5);
      canvas.drawCircle(Offset(x, y), base * (0.6 + tw * 0.6), paint);
      // A few plus-shaped sparkles.
      if (i % 18 == 0) {
        final s = 3 + tw * 3;
        paint
          ..color = AppColors.lavender.withOpacity(0.35 * tw)
          ..strokeWidth = 1;
        canvas.drawLine(
            Offset(x - s, y), Offset(x + s, y), paint);
        canvas.drawLine(
            Offset(x, y - s), Offset(x, y + s), paint);
      }
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter old) => old.t != t;
}
