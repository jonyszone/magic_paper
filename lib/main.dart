import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MagicPaperApp());
}

class MagicPaperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Paper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF6B4EAE),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: MagicPaperScreen(),
    );
  }
}

class MagicPaperScreen extends StatefulWidget {
  @override
  _MagicPaperScreenState createState() => _MagicPaperScreenState();
}

class _MagicPaperScreenState extends State<MagicPaperScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  String _magicSymbol = '';
  Map<int, String> _symbolMap = {};
  final List<int> _multiplesOf9 = [9, 18, 27, 36, 45, 54, 63, 72, 81];
  final List<String> _symbols = [
    '🔮', '✨', '🎩', '🌟', '💎', '🌙', '🔥', '🦋', '⚡',
    '🍀', '🎯', '💜', '🌀', '⭐', '🌈', '🎪', '💠', '🔮'
  ];
  
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _particleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    _generateSymbols();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _generateSymbols() {
    final random = Random();
    _magicSymbol = _symbols[random.nextInt(_symbols.length)];
    _symbolMap.clear();
    
    for (int i = 1; i < 100; i++) {
      if (_multiplesOf9.contains(i)) {
        _symbolMap[i] = _magicSymbol;
      } else {
        _symbolMap[i] = _symbols[random.nextInt(_symbols.length)];
      }
    }
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _revealSymbol() {
    setState(() {
      _currentStep = 3;
    });
  }

  void _resetGame() {
    _generateSymbols();
    setState(() {
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1F3A),
              Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildParticles(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(_particleController.value),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildIntroScreen();
      case 1:
        return _buildInstructionsScreen();
      case 2:
        return _buildSymbolsScreen();
      case 3:
        return _buildRevealScreen();
      default:
        return _buildIntroScreen();
    }
  }

  Widget _buildIntroScreen() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(height: 60),
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: _buildCrystalBall(size: 180),
          ),
          SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFFB388FF), Color(0xFF7C4DFF), Color(0xFFB388FF)],
            ).createShader(bounds),
            child: Text(
              'MAGIC PAPER',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w300,
                letterSpacing: 8,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Mind Reader',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
              color: Colors.white54,
            ),
          ),
          Spacer(),
          _buildButton('BEGIN', _nextStep),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInstructionsScreen() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildStepIndicator(1),
          SizedBox(height: 30),
          _buildInstructionCard(
            'Think of any two-digit number',
            '10 - 99',
            Icons.psychology,
          ),
          SizedBox(height: 20),
          _buildInstructionCard(
            'Add both digits together',
            'Example: 42 → 4 + 2 = 6',
            Icons.calculate,
          ),
          SizedBox(height: 20),
          _buildInstructionCard(
            'Subtract from original number',
            'Example: 42 - 6 = 36',
            Icons.remove_circle_outline,
          ),
          SizedBox(height: 20),
          _buildInstructionCard(
            'Remember the symbol',
            'Find your number in the list',
            Icons.visibility,
          ),
          Spacer(),
          _buildButton('CONTINUE', _nextStep),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSymbolsScreen() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStepIndicator(2),
              SizedBox(height: 16),
              Text(
                'Find your symbol',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF151932),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF2A2F4F), width: 1),
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 99,
              itemBuilder: (context, index) {
                final number = index + 1;
                final symbol = _symbolMap[number] ?? '';
                final isMultiple = _multiplesOf9.contains(number);
                
                return Container(
                  decoration: BoxDecoration(
                    color: isMultiple ? Color(0xFF2A2F4F) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white38,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        symbol,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24),
          child: _buildButton('REVEAL SYMBOL', _revealSymbol),
        ),
      ],
    );
  }

  Widget _buildRevealScreen() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(3),
          SizedBox(height: 40),
          Text(
            'Your symbol is',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
              color: Colors.white54,
            ),
          ),
          SizedBox(height: 30),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFF7C4DFF).withOpacity(0.3),
                        Color(0xFF7C4DFF).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF7C4DFF).withOpacity(0.5),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _magicSymbol,
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 50),
          Text(
            'I knew you would pick this one!',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white38,
            ),
          ),
          SizedBox(height: 50),
          _buildButton('TRY AGAIN', _resetGame),
        ],
      ),
    );
  }

  Widget _buildCrystalBall({double size = 120}) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.8,
                colors: [
                  Color(0xFFB388FF),
                  Color(0xFF7C4DFF),
                  Color(0xFF651FFF),
                  Color(0xFF311B92),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7C4DFF).withOpacity(0.6),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Color(0xFFB388FF).withOpacity(0.3),
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

  Widget _buildStepIndicator(int step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < step;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Color(0xFF7C4DFF) : Colors.white24,
          ),
        );
      }),
    );
  }

  Widget _buildInstructionCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF151932),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF2A2F4F), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF7C4DFF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFFB388FF), size: 26),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7C4DFF).withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final Random _random = Random(42);
  
  ParticlePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFF7C4DFF).withOpacity(0.3);
    
    for (int i = 0; i < 30; i++) {
      final x = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;
      final y = (baseY + animationValue * 100 * (i % 2 == 0 ? 1 : -1)) % size.height;
      final radius = 1 + _random.nextDouble() * 2;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
