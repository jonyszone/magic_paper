import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  final Random _random = Random(42);

  ParticlePainter(this.animationValue, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(isDark ? 0.15 : 0.1);

    for (int i = 0; i < 50; i++) {
      final x = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;
      final y = (baseY + animationValue * 200 * (i % 2 == 0 ? 1 : -1)) % size.height;
      canvas.drawCircle(Offset(x, y), 0.5 + _random.nextDouble() * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
