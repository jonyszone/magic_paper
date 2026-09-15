// Legacy compatibility: CrystalBall now delegates to CrystalOrb.
import 'package:flutter/material.dart';
import 'crystal_orb.dart';

class CrystalBall extends StatelessWidget {
  final double size;
  final Animation<double> animation;

  const CrystalBall({
    super.key,
    this.size = 120,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => CrystalOrb(
        size: size,
        pulse: animation.value,
        spin: animation.value * 2,
      ),
    );
  }
}
