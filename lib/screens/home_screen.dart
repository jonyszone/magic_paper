import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/aurora_painter.dart';
import '../widgets/confetti_painter.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final GameProvider _game;
  late final AnimationController _aurora;
  late final AnimationController _pulse;
  late final AnimationController _float;
  late final AnimationController _shimmer;
  late final AnimationController _confetti;
  late final AnimationController _pageIn;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pageInAnim;

  @override
  void initState() {
    super.initState();
    _game = GameProvider()..game.generateSymbols();
    _aurora  = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _pulse   = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _float   = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    _confetti = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _pageIn  = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();

    _pulseAnim  = Tween<double>(begin: 0.94, end: 1.06).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _floatAnim  = Tween<double>(begin: -12, end: 12).animate(CurvedAnimation(parent: _float, curve: Curves.easeInOut));
    _pageInAnim = CurvedAnimation(parent: _pageIn, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _game.dispose(); _aurora.dispose(); _pulse.dispose(); _float.dispose();
    _shimmer.dispose(); _confetti.dispose(); _pageIn.dispose();
    super.dispose();
  }

  void _goNext() {
    _pageIn.forward(from: 0);
    setState(() => _game.nextStep());
  }

  void _reveal() {
    _pageIn.forward(from: 0);
    _confetti.forward(from: 0);
    setState(() => _game.revealSymbol());
  }

  void _reset() {
    _confetti.reset();
    _game.game.generateSymbols();
    _pageIn.forward(from: 0);
    setState(() => _game.resetGame());
  }

  void _share() {
    Clipboard.setData(ClipboardData(text: '🔮 Magic Paper read my mind! Symbol: ${_game.lastSymbol} — Try it!'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('✨ Copied to clipboard!'),
      backgroundColor: const Color(0xFF7C3AED),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060412),
      body: Stack(
        children: [
          // Aurora background
          AnimatedBuilder(
            animation: _aurora,
            builder: (_, __) => CustomPaint(
              size: Size.infinite,
              painter: AuroraPainter(_aurora.value * 2 * pi),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: FadeTransition(
                  opacity: _pageInAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
                        .animate(_pageInAnim),
                    child: Column(children: [_appBar(), Expanded(child: _screen())]),
                  ),
                ),
              ),
            ),
          ),
          // Confetti
          if (_game.showConfetti)
            AnimatedBuilder(
              animation: _confetti,
              builder: (_, __) => CustomPaint(size: Size.infinite, painter: ConfettiPainter(_confetti.value)),
            ),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────
  Widget _appBar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
    child: Row(
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Color(0xFFE879F9), Color(0xFF818CF8)],
          ).createShader(b),
          child: const Text('✦ MAGIC PAPER', style: TextStyle(fontSize: 13, letterSpacing: 3, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        const Spacer(),
        _iconBtn(Icons.bar_chart_rounded, _showStats),
        _iconBtn(Icons.auto_awesome_outlined, _showInfo),
        _iconBtn(
          widget.themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          widget.themeProvider.toggleTheme,
        ),
      ],
    ),
  );

  Widget _iconBtn(IconData icon, VoidCallback onTap) => IconButton(
    icon: Icon(icon, size: 20),
    color: Colors.white38,
    splashRadius: 20,
    onPressed: onTap,
  );

  // ── Screen Router ─────────────────────────────────────────────────────────
  Widget _screen() {
    switch (_game.currentStep) {
      case 0: return _introScreen();
      case 1: return _instructionsScreen();
      case 2: return _symbolsScreen();
      case 3: return _revealScreen();
      default: return _introScreen();
    }
  }

  // ── Intro ─────────────────────────────────────────────────────────────────
  Widget _introScreen() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      children: [
        const Spacer(flex: 2),
        // Crystal orb
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnim, _float]),
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: Transform.scale(
              scale: _pulseAnim.value,
              child: _crystalOrb(200),
            ),
          ),
        ),
        const SizedBox(height: 48),
        const Text(
          'I Can Read\nYour Mind',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1, letterSpacing: -1),
        ),
        const SizedBox(height: 16),
        Text(
          'Think of a number. Follow the steps.\nWatch the magic unfold.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.45), height: 1.6),
        ),
        const Spacer(flex: 3),
        _primaryBtn('Begin the Magic', _goNext),
        const SizedBox(height: 36),
      ],
    ),
  );

  // ── Instructions ──────────────────────────────────────────────────────────
  Widget _instructionsScreen() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepDots(1),
        const SizedBox(height: 24),
        const Text('Follow\nThese Steps', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
        const SizedBox(height: 28),
        _glassCard(child: Column(children: [
          _step('01', 'Think of a number', 'Any two-digit number between 10–99'),
          _divider(),
          _step('02', 'Add the digits', 'e.g.  42  →  4 + 2 = 6'),
          _divider(),
          _step('03', 'Subtract the sum', 'e.g.  42 − 6 = 36'),
          _divider(),
          _step('04', 'Find your symbol', 'Locate your result in the grid'),
        ])),
        const Spacer(),
        _primaryBtn("I'm Ready", _goNext),
        const SizedBox(height: 36),
      ],
    ),
  );

  Widget _step(String num, String title, String sub) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)]),
          ),
          child: Center(child: Text(num, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.45))),
          ],
        )),
      ],
    ),
  );

  Widget _divider() => Divider(height: 1, color: Colors.white.withOpacity(0.07), indent: 18, endIndent: 18);

  // ── Symbols Grid ──────────────────────────────────────────────────────────
  Widget _symbolsScreen() {
    const multiples = [9, 18, 27, 36, 45, 54, 63, 72, 81];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(children: [
            _stepDots(2),
            const SizedBox(height: 16),
            const Text('Find Your Symbol', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4),
            Text('Locate your calculated number', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4))),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _glassCard(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 1, crossAxisSpacing: 4, mainAxisSpacing: 4,
                ),
                itemCount: 99,
                itemBuilder: (_, i) {
                  final n = i + 1;
                  final sym = _game.symbolMap[n] ?? '';
                  final hot = multiples.contains(n);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: hot ? const LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [Color(0x337C3AED), Color(0x224F46E5)],
                      ) : null,
                      border: hot ? Border.all(color: const Color(0x557C3AED), width: 1) : null,
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('$n', style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(hot ? 0.6 : 0.25))),
                      Text(sym, style: const TextStyle(fontSize: 15)),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: _primaryBtn('Reveal My Symbol', _reveal),
        ),
      ],
    );
  }

  // ── Reveal ────────────────────────────────────────────────────────────────
  Widget _revealScreen() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepDots(3),
        const SizedBox(height: 32),
        Text('Your Symbol', style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white.withOpacity(0.4))),
        const SizedBox(height: 32),
        // Big glowing symbol
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Transform.scale(
            scale: _pulseAnim.value,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF7C3AED).withOpacity(0.35),
                  const Color(0xFF4F46E5).withOpacity(0.15),
                  Colors.transparent,
                ]),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 80, spreadRadius: 20),
                  BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 120, spreadRadius: 40),
                ],
              ),
              child: Center(child: Text(_game.magicSymbol, style: const TextStyle(fontSize: 96))),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Shimmer tagline
        AnimatedBuilder(
          animation: _shimmer,
          builder: (_, __) {
            final v = _shimmer.value;
            return ShaderMask(
              shaderCallback: (b) => LinearGradient(
                colors: const [Color(0xFFE879F9), Colors.white, Color(0xFF818CF8)],
                stops: [(v - 0.4).clamp(0.0, 1.0), v.clamp(0.0, 1.0), (v + 0.4).clamp(0.0, 1.0)],
              ).createShader(b),
              child: const Text('✦ I knew it all along ✦', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 1)),
            );
          },
        ),
        const SizedBox(height: 48),
        Row(children: [
          Expanded(child: _outlineBtn(Icons.share_rounded, 'Share', _share)),
          const SizedBox(width: 12),
          Expanded(child: _primaryBtn('Play Again', _reset)),
        ]),
      ],
    ),
  );

  // ── Shared Widgets ────────────────────────────────────────────────────────
  Widget _crystalOrb(double size) {
    return Container(
      width: size, height: size,
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
        // Highlight
        Positioned(
          top: size * 0.12, left: size * 0.18,
          child: Container(
            width: size * 0.28, height: size * 0.16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        // Inner glow
        Center(child: Container(
          width: size * 0.5, height: size * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [Colors.white.withOpacity(0.08), Colors.transparent]),
          ),
        )),
      ]),
    );
  }

  Widget _glassCard({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _stepDots(int active) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (i) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: i < active ? 28 : 8, height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: i < active
            ? const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF818CF8)])
            : null,
        color: i < active ? null : Colors.white12,
      ),
    )),
  );

  Widget _primaryBtn(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity, height: 56,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)]),
        boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Center(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5))),
        ),
      ),
    ),
  );

  Widget _outlineBtn(IconData icon, String label, VoidCallback onTap) => SizedBox(
    height: 56,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70)),
          ]),
        ),
      ),
    ),
  );

  // ── Dialogs ───────────────────────────────────────────────────────────────
  void _showInfo() => showDialog(context: context, builder: (_) => _dialog(
    icon: '✨',
    title: 'The Magic of 9',
    body: 'Subtract the digit sum from any two-digit number and you always get a multiple of 9.\n\nAll multiples of 9 share the same symbol — so I always know! 🔮',
  ));

  void _showStats() => showDialog(context: context, builder: (_) => _dialog(
    icon: '📊',
    title: 'Your Stats',
    body: 'Times Played: ${_game.playCount}\nSuccess Rate: 100%\nLast Symbol: ${_game.lastSymbol.isEmpty ? "—" : _game.lastSymbol}',
  ));

  Widget _dialog({required String icon, required String title, required String body}) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: const Color(0xFF1A1040).withOpacity(0.85),
              border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(icon, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 14),
                Text(body, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6), height: 1.7), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it', style: TextStyle(color: Color(0xFFD8B4FE), fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
