import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../widgets/aurora_painter.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const SplashScreen({super.key, required this.themeProvider});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _aurora;
  late final AnimationController _enter;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _aurora = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _enter  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

    _fade       = CurvedAnimation(parent: _enter, curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _scale      = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _enter, curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)));
    _taglineFade = CurvedAnimation(parent: _enter, curve: const Interval(0.5, 1.0, curve: Curves.easeOut));

    _enter.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomeScreen(themeProvider: widget.themeProvider),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      ));
    });
  }

  @override
  void dispose() {
    _aurora.dispose(); _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060412),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _aurora,
            builder: (_, __) => CustomPaint(size: Size.infinite, painter: AuroraPainter(_aurora.value * 2 * pi)),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _enter,
              builder: (_, __) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Orb
                  Opacity(
                    opacity: _fade.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: _buildOrb(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  Opacity(
                    opacity: _fade.value,
                    child: ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [Color(0xFFE879F9), Color(0xFFD8B4FE), Color(0xFF818CF8)],
                      ).createShader(b),
                      child: const Text(
                        'MAGIC PAPER',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tagline
                  Opacity(
                    opacity: _taglineFade.value,
                    child: Text(
                      'Mind Reader',
                      style: TextStyle(fontSize: 14, letterSpacing: 4, color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.w300),
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

  Widget _buildOrb() {
    return Container(
      width: 130, height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 0.85,
          colors: [Color(0xFFD8B4FE), Color(0xFF7C3AED), Color(0xFF3730A3), Color(0xFF1E1B4B)],
          stops: [0.0, 0.4, 0.75, 1.0],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.7), blurRadius: 60, spreadRadius: 10),
          BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.4), blurRadius: 100, spreadRadius: 30),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: 130 * 0.12, left: 130 * 0.18,
          child: Container(
            width: 130 * 0.28, height: 130 * 0.16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ]),
    );
  }
}
