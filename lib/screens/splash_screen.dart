import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../providers/theme_provider.dart';
import '../widgets/aurora_painter.dart';
import '../widgets/crystal_orb.dart';
import 'home_screen.dart';

/// Cinematic entry: orb scales in with elastic ease, wordmark
/// fades up, thin progress line fills. Tap anywhere to skip.
class SplashScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const SplashScreen({super.key, required this.themeProvider});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _aurora;
  late final AnimationController _enter;
  late final AnimationController _progress;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _rise;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _aurora = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _enter = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _progress = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400));

    _fade = CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.55, end: 1.0).animate(
        CurvedAnimation(
            parent: _enter,
            curve:
                const Interval(0.0, 0.7, curve: Curves.elasticOut)));
    _rise = Tween<double>(begin: 18, end: 0).animate(CurvedAnimation(
        parent: _enter,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)));

    _enter.forward();
    _progress.forward();
    Future.delayed(const Duration(milliseconds: 2500), _go);
  }

  void _go() {
    if (_navigated || !mounted) return;
    _navigated = true;
    HapticFeedback.lightImpact();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            HomeScreen(themeProvider: widget.themeProvider),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 650),
      ),
    );
  }

  @override
  void dispose() {
    _aurora.dispose();
    _enter.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeProvider.isDarkMode;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.bgDark : AppColors.bgLight,
      body: GestureDetector(
        onTap: _go,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _aurora,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter: AuroraPainter(
                    _aurora.value * 2 * pi,
                    isDark: isDark),
              ),
            ),
            if (isDark)
              AnimatedBuilder(
                animation: _aurora,
                builder: (_, __) => CustomPaint(
                  size: Size.infinite,
                  painter: StarfieldPainter(
                      _aurora.value * 2 * pi),
                ),
              ),
            Center(
              child: AnimatedBuilder(
                animation: _enter,
                builder: (_, __) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _fade.value,
                      child: Transform.scale(
                        scale: _scale.value,
                        child: CrystalOrb(
                          size: 128,
                          pulse: 1.0,
                          spin: _aurora.value * 2 * pi,
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    Opacity(
                      opacity: _fade.value,
                      child: Transform.translate(
                        offset: Offset(0, _rise.value),
                        child: ShaderMask(
                          shaderCallback: (b) =>
                              const LinearGradient(
                            colors: [
                              Color(0xFFE879F9),
                              Color(0xFFD8B4FE),
                              Color(0xFF818CF8)
                            ],
                          ).createShader(b),
                          child: Text(
                            'MAGIC PAPER',
                            style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.violet,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity:
                          _fade.value.clamp(0.0, 1.0) * 0.9,
                      child: Transform.translate(
                        offset: Offset(0, _rise.value),
                        child: Text(
                          'M I N D   R E A D E R',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white.withOpacity(0.4)
                                : AppColors.violet
                                    .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Progress hairline.
                    SizedBox(
                      width: 140,
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (_, __) => ClipRRect(
                          borderRadius:
                              BorderRadius.circular(2),
                          child: Container(
                            height: 3,
                            color: (isDark
                                    ? Colors.white
                                    : AppColors.violet)
                                .withOpacity(0.12),
                            child: Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: _progress.value
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  decoration:
                                      const BoxDecoration(
                                    gradient: AppColors
                                        .brandGradient,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'tap to skip',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.4,
                        color: (isDark
                                ? Colors.white
                                : AppColors.violet)
                            .withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
