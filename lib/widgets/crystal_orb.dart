import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Hero crystal orb: layered radial gradients, orbiting rune ring,
/// specular highlight and ambient halo. Pure decoration — pass a
/// [pulse] + [spin] animation value from the parent.
class CrystalOrb extends StatelessWidget {
  final double size;
  final double pulse; // 0.94..1.06 typically
  final double spin; // radians
  final String? glyph; // optional emoji floating inside

  const CrystalOrb({
    super.key,
    this.size = 200,
    required this.pulse,
    required this.spin,
    this.glyph,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.35,
      height: size * 1.35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient halo.
          Container(
            width: size * 1.3,
            height: size * 1.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.violet.withOpacity(0.28),
                AppColors.indigo.withOpacity(0.1),
                Colors.transparent,
              ]),
            ),
          ),
          // Orbiting ring with rune dots.
          Transform.rotate(
            angle: spin,
            child: CustomPaint(
              size: Size(size * 1.22, size * 1.22),
              painter: _OrbitPainter(),
            ),
          ),
          Transform.rotate(
            angle: -spin * 0.6,
            child: Container(
              width: size * 1.05,
              height: size * 1.05,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.09),
                  width: 1,
                ),
              ),
            ),
          ),
          // The orb itself.
          Transform.scale(
            scale: pulse,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.32, -0.42),
                  radius: 0.9,
                  colors: [
                    Color(0xFFE9D5FF),
                    Color(0xFFA855F7),
                    Color(0xFF6D28D9),
                    Color(0xFF2E1065),
                    Color(0xFF170A33),
                  ],
                  stops: [0.0, 0.22, 0.48, 0.78, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.violet.withOpacity(0.65),
                    blurRadius: 60,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: AppColors.indigo.withOpacity(0.35),
                    blurRadius: 110,
                    spreadRadius: 26,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Inner nebula glow.
                  Center(
                    child: Container(
                      width: size * 0.62,
                      height: size * 0.62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          Colors.white.withOpacity(0.14),
                          AppColors.fuchsia.withOpacity(0.06),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                  // Specular highlight.
                  Positioned(
                    top: size * 0.11,
                    left: size * 0.17,
                    child: Transform.rotate(
                      angle: -0.45,
                      child: Container(
                        width: size * 0.3,
                        height: size * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.32),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size * 0.26,
                    left: size * 0.14,
                    child: Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.35),
                      ),
                    ),
                  ),
                  // Rim light (bottom).
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            AppColors.cyan.withOpacity(0.12),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  if (glyph != null)
                    Center(
                      child: Text(
                        glyph!,
                        style: TextStyle(
                          fontSize: size * 0.36,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    final ring = Paint()
      ..color = Colors.white.withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(c, r, ring);

    const runes = ['✦', '✧', '⋆', '✦', '⋆', '✧'];
    for (int i = 0; i < runes.length; i++) {
      final a = (i / runes.length) * 2 * pi - pi / 2;
      final p = c + Offset(cos(a) * r, sin(a) * r);
      final tp = TextPainter(
        text: TextSpan(
          text: runes[i],
          style: TextStyle(
            fontSize: 11,
            color: AppColors.lavender.withOpacity(0.85),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
