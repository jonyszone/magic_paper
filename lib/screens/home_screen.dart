import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../providers/game_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/crystal_ball.dart';
import '../widgets/magic_button.dart';
import '../widgets/step_indicator.dart';
import '../widgets/instruction_card.dart';
import '../widgets/particle_painter.dart';
import '../widgets/confetti_painter.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late GameProvider _gameProvider;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  late AnimationController _confettiController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  bool get isDark => widget.themeProvider.isDarkMode;

  @override
  void initState() {
    super.initState();
    _gameProvider = GameProvider()..game.generateSymbols();
    
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _floatController = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);
    _shimmerController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this)..repeat();
    _particleController = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _confettiController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _confettiController.dispose();
    _gameProvider.dispose();
    super.dispose();
  }

  void _share() {
    Clipboard.setData(ClipboardData(
      text: '🔮 Magic Paper read my mind! The symbol was ${_gameProvider.lastSymbol}\n\nTry it yourself!',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60, height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.primaryLight, AppColors.primary]),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              Text('The Magic of 9', style: AppTextStyles.heading(isDark: isDark)),
              const SizedBox(height: 16),
              Text(
                'When you subtract the sum of digits from any two-digit number, the result is always a multiple of 9.\n\nAll multiples of 9 share the same symbol! ✨',
                style: AppTextStyles.body(isDark: isDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('GOT IT', style: TextStyle(color: AppColors.primaryLight, letterSpacing: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bar_chart, color: AppColors.primaryLight, size: 40),
              const SizedBox(height: 16),
              Text('Your Stats', style: AppTextStyles.heading(isDark: isDark)),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Times Played', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
                Text('${_gameProvider.playCount}', style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Success Rate', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
                const Text('100%', style: TextStyle(color: Colors.green)),
              ]),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE', style: TextStyle(color: AppColors.primaryLight, letterSpacing: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: isDark
                ? [AppColors.backgroundDarkLight, AppColors.backgroundDark]
                : [AppColors.backgroundLightLight, AppColors.backgroundLight],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) => CustomPaint(
                  size: Size.infinite,
                  painter: ParticlePainter(_particleController.value, isDark),
                ),
              ),
              Column(
                children: [
                  _buildAppBar(),
                  Expanded(child: _buildContent()),
                ],
              ),
              if (_gameProvider.showConfetti)
                AnimatedBuilder(
                  animation: _confettiController,
                  builder: (context, child) => CustomPaint(
                    size: Size.infinite,
                    painter: ConfettiPainter(_confettiController.value),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('MAGIC PAPER', style: AppTextStyles.subtitle(isDark: isDark)),
          Row(
            children: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: isDark ? Colors.white54 : Colors.black45),
                onPressed: widget.themeProvider.toggleTheme,
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, color: isDark ? Colors.white54 : Colors.black45),
                onPressed: _showStats,
              ),
              IconButton(
                icon: Icon(Icons.info_outline, color: isDark ? Colors.white54 : Colors.black45),
                onPressed: _showInfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _buildCurrentScreen(),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_gameProvider.currentStep) {
      case 0: return _buildIntroScreen();
      case 1: return _buildInstructionsScreen();
      case 2: return _buildSymbolsScreen();
      case 3: return _buildRevealScreen();
      default: return _buildIntroScreen();
    }
  }

  Widget _buildIntroScreen() {
    return Padding(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(flex: 2),
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            ),
            child: CrystalBall(size: 160, animation: _pulseAnimation),
          ),
          const SizedBox(height: 40),
          Text('I can read your mind', style: AppTextStyles.heading(isDark: isDark)),
          const SizedBox(height: 12),
          Text('Think of a number and I\'ll guess\nthe symbol you\'re thinking of', style: AppTextStyles.body(isDark: isDark), textAlign: TextAlign.center),
          const Spacer(flex: 3),
          MagicButton(text: 'START', onPressed: () => setState(() => _gameProvider.nextStep())),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInstructionsScreen() {
    return Padding(
      key: const ValueKey('instructions'),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          StepIndicator(currentStep: 1, isDark: isDark),
          const SizedBox(height: 30),
          InstructionCard(title: 'Think of any two-digit number', subtitle: 'Between 10 and 99', icon: Icons.psychology, isDark: isDark),
          const SizedBox(height: 14),
          InstructionCard(title: 'Add both digits together', subtitle: 'e.g., 42 → 4 + 2 = 6', icon: Icons.calculate, isDark: isDark),
          const SizedBox(height: 14),
          InstructionCard(title: 'Subtract from original', subtitle: 'e.g., 42 - 6 = 36', icon: Icons.remove_circle_outline, isDark: isDark),
          const SizedBox(height: 14),
          InstructionCard(title: 'Find your symbol', subtitle: 'Remember it carefully', icon: Icons.visibility, isDark: isDark),
          const Spacer(),
          MagicButton(text: 'I\'M READY', onPressed: () => setState(() => _gameProvider.nextStep())),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSymbolsScreen() {
    return Column(
      key: const ValueKey('symbols'),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StepIndicator(currentStep: 2, isDark: isDark),
              const SizedBox(height: 12),
              Text('Find your symbol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300, letterSpacing: 1, color: isDark ? Colors.white70 : Colors.black54)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 1),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 1, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: 99,
              itemBuilder: (context, index) {
                final number = index + 1;
                final symbol = _gameProvider.symbolMap[number] ?? '';
                final isMultiple = _gameProvider.game.isMultipleOf9Number(number);
                return Container(
                  decoration: BoxDecoration(
                    color: isMultiple ? (isDark ? AppColors.borderDark : AppColors.backgroundLightLight) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$number', style: TextStyle(fontSize: 9, color: isDark ? Colors.white38 : Colors.black38)),
                      Text(symbol, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: MagicButton(text: 'REVEAL', onPressed: () {
            _confettiController.forward();
            setState(() => _gameProvider.revealSymbol());
          }),
        ),
      ],
    );
  }

  Widget _buildRevealScreen() {
    return Padding(
      key: const ValueKey('reveal'),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StepIndicator(currentStep: 3, isDark: isDark),
          const SizedBox(height: 30),
          Text('Your symbol is', style: TextStyle(fontSize: 18, color: isDark ? Colors.white54 : Colors.black45, letterSpacing: 1)),
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0.1), Colors.transparent]),
                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 50, spreadRadius: 15)],
                ),
                child: Center(child: Text(_gameProvider.magicSymbol, style: const TextStyle(fontSize: 90))),
              ),
            ),
          ),
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) => ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Colors.white38, Colors.white, Colors.white38],
                stops: [_shimmerController.value - 0.3, _shimmerController.value, _shimmerController.value + 0.3],
              ).createShader(bounds),
              child: const Text('✨ Amazing, right? ✨', style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: MagicButton(text: 'SHARE', icon: Icons.share, isOutlined: true, onPressed: _share)),
              const SizedBox(width: 12),
              Expanded(child: MagicButton(text: 'TRY AGAIN', onPressed: () {
                _confettiController.reset();
                _gameProvider.game.generateSymbols();
                setState(() => _gameProvider.resetGame());
              })),
            ],
          ),
        ],
      ),
    );
  }
}
