import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

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
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.8,
                colors: [
                  AppColors.primaryLight,
                  AppColors.primary,
                  AppColors.primaryDark,
                  const Color(0xFF311B92),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: size * 0.15,
                  left: size * 0.2,
                  child: Container(
                    width: size * 0.25,
                    height: size * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
