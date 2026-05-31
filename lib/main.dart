import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MagicPaperApp());
}

class MagicPaperApp extends StatefulWidget {
  const MagicPaperApp({super.key});

  @override
  State<MagicPaperApp> createState() => _MagicPaperAppState();
}

class _MagicPaperAppState extends State<MagicPaperApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Magic Paper',
          debugShowCheckedModeBanner: false,
          theme: _themeProvider.theme,
          home: SplashScreen(themeProvider: _themeProvider),
        );
      },
    );
  }
}
