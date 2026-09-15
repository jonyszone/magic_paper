import 'dart:math';
import 'package:flutter/material.dart';

/// Deterministic celebration confetti with real fall physics.
///
/// Particles are seeded once, so frames don't flicker. Each piece
/// has its own delay, drift, tumble and shape (rect / circle) and
/// eases out over [progress] 0→1.
class ConfettiPainter extends CustomPainter {
  final double progress;
  final int count;
  final int seed;

  static const List<Color> _colors = [
    Color(0xFF7C3AED),
    Color(0xFFE879F9),
    Color(0xFF818CF8),
    Color(0xFFFACC15),
    Color(0xFF22D3EE),
    Color(0xFFFFFFFF),
  ];

  ConfettiPainter(this.progress, {this.count = 110, this.seed = 7});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    // Pre-roll so layout is stable across frames.
    final parts = List.generate(count, (_) {
      return (
        x: rng.nextDouble(),
        delay: rng.nextDouble() * 0.35,
        dur: 0.65 + rng.nextDouble() * 0.35,
        drift: (rng.nextDouble() - 0.5) * 140,
        size: 4 + rng.nextDouble() * 6,
        spin: rng.nextDouble() * pi * 2,
        spinSpeed: 3 + rng.nextDouble() * 6,
        color: _colors[rng.nextInt(_colors.length)],
        circle: rng.nextBool(),
      );
    });

    for (final p in parts) {
      final local =
          ((progress - p.delay) / p.dur).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final eased = 1 - pow(1 - local, 2).toDouble();
      final startY = -30.0;
      final endY = size.height * 0.85;
      final sway =
          sin(local * p.spinSpeed + p.spin) * 26 * (1 - local * 0.4);
      final x = p.x * size.width + p.drift * eased + sway;
      final y = startY + (endY - startY) * eased;
      final alpha = (1 - local * local).clamp(0.0, 1.0);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin + local * p.spinSpeed * 2);
      final paint = Paint()..color = p.color.withOpacity(alpha);
      if (p.circle) {
        canvas.drawCircle(Offset.zero, p.size / 2.2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero,
                width: p.size,
                height: p.size * 0.62),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter old) =>
      old.progress != progress;
}
