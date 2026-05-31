import 'dart:math';
import 'package:flutter/material.dart';

class AuroraPainter extends CustomPainter {
  final double t;
  AuroraPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Deep space base
    final bg = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.3),
        radius: 1.2,
        colors: const [Color(0xFF0D0B2B), Color(0xFF060412)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);

    // Aurora blobs
    _drawAurora(canvas, size, Offset(w * 0.2, h * 0.25), w * 0.7, const Color(0xFF6B21A8), 0.18, t);
    _drawAurora(canvas, size, Offset(w * 0.75, h * 0.15), w * 0.55, const Color(0xFF4F46E5), 0.14, t + 1.2);
    _drawAurora(canvas, size, Offset(w * 0.5, h * 0.6), w * 0.6, const Color(0xFF7C3AED), 0.12, t + 2.4);
    _drawAurora(canvas, size, Offset(w * 0.1, h * 0.7), w * 0.45, const Color(0xFF2563EB), 0.10, t + 0.8);

    // Stars
    final starPaint = Paint()..color = Colors.white;
    final rng = Random(99);
    for (int i = 0; i < 80; i++) {
      final x = rng.nextDouble() * w;
      final y = rng.nextDouble() * h * 0.7;
      final r = rng.nextDouble() * 1.2;
      final twinkle = (sin(t * 3 + i) * 0.5 + 0.5);
      starPaint.color = Colors.white.withOpacity(twinkle * 0.6 + 0.1);
      canvas.drawCircle(Offset(x, y), r, starPaint);
    }
  }

  void _drawAurora(Canvas canvas, Size size, Offset center, double radius, Color color, double opacity, double phase) {
    final dx = sin(phase * 0.7) * size.width * 0.08;
    final dy = cos(phase * 0.5) * size.height * 0.05;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(opacity), color.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: center + Offset(dx, dy), radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    canvas.drawCircle(center + Offset(dx, dy), radius, paint);
  }

  @override
  bool shouldRepaint(AuroraPainter old) => old.t != t;
}
