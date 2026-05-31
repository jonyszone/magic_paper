import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Random _random = Random();
  final List<Color> _colors = [
    const Color(0xFF7C4DFF),
    const Color(0xFFB388FF),
    const Color(0xFF651FFF),
    const Color(0xFFFFD700),
    const Color(0xFFFF69B4),
  ];

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 50; i++) {
      final paint = Paint()..color = _colors[i % _colors.length].withOpacity(1 - animationValue);
      final x = _random.nextDouble() * size.width;
      final y = -50 + (animationValue * size.height * 1.5) + (_random.nextDouble() * 100);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(_random.nextDouble() * 3.14 * 2);
      canvas.drawRect(const Rect.fromLTWH(-4, -4, 8, 8), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
