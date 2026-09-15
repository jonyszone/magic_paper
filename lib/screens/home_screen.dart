import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/theme_provider.dart';
import '../providers/game_provider.dart';
import '../utils/haptics.dart';
import '../widgets/aurora_painter.dart';
import '../widgets/confetti_painter.dart';
import '../widgets/crystal_orb.dart';
import '../widgets/magic_chrome.dart';
import '../widgets/magic_dialogs.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final GameProvider _game;
  late final AnimationController _aurora;
  late final AnimationController _pulse;
  late final AnimationController _float;
  late final AnimationController _spin;
  late final AnimationController _shimmer;
  late final AnimationController _confetti;
  late final AnimationController _pageIn;
  late final AnimationController _scan;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pageInAnim;

  int _example = 42;
  bool _revealed = false;
  Timer? _scanTimer;

  bool get _isDark => widget.themeProvider.isDarkMode;

  @override
  void initState() {
    super.initState();
    _game = GameProvider()..game.generateSymbols();
    _aurora = AnimationController(
        vsync: this, duration: const Duration(seconds: 9))
      ..repeat();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _float = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _spin = AnimationController(
        vsync: this, duration: const Duration(seconds: 24))
      ..repeat();
    _shimmer = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1900))
      ..repeat();
    _confetti = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));
    _scan = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _pageIn = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 520))
      ..forward();

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: _float, curve: Curves.easeInOut));
    _pageInAnim =
        CurvedAnimation(parent: _pageIn, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _game.dispose();
    _aurora.dispose();
    _pulse.dispose();
    _float.dispose();
    _spin.dispose();
    _shimmer.dispose();
    _confetti.dispose();
    _scan.dispose();
    _pageIn.dispose();
    super.dispose();
  }

  // ── Flow actions ───────────────────────────────────────
  void _animatePage() {
    _pageIn.forward(from: 0);
  }

  void _goNext() {
    MagicHaptics.step();
    _animatePage();
    setState(() => _game.nextStep());
  }

  void _goBack() {
    MagicHaptics.tap();
    _animatePage();
    setState(() => _game.goBack());
  }

  void _reveal() {
    MagicHaptics.reveal();
    setState(() {
      _game.revealSymbol();
      _revealed = false;
    });
    _animatePage();
    _scan.forward(from: 0);
    _scanTimer?.cancel();
    _scanTimer = Timer(const Duration(milliseconds: 2050), () {
      if (!mounted) return;
      setState(() => _revealed = true);
      _confetti.forward(from: 0);
      MagicHaptics.magic();
    });
  }

  void _reset() {
    MagicHaptics.step();
    _scanTimer?.cancel();
    _scan.reset();
    _confetti.reset();
    _revealed = false;
    _game.game.generateSymbols();
    _animatePage();
    setState(() => _game.resetGame());
  }

  void _backToGrid() {
    MagicHaptics.tap();
    _scanTimer?.cancel();
    _scan.reset();
    _confetti.reset();
    setState(() {
      _revealed = false;
      _game.goTo(2);
    });
    _animatePage();
  }

  Future<void> _share() async {
    MagicHaptics.tap();
    await Clipboard.setData(ClipboardData(
        text:
            '🔮 Magic Paper read my mind! My symbol was ${_game.lastSymbol} — can it read yours?'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: Colors.white, size: 18),
          SizedBox(width: 10),
          Text('Copied — dare a friend to try'),
        ],
      ),
      backgroundColor: AppColors.violet,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Shell ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDark ? AppColors.bgDark : AppColors.bgLight,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _aurora,
            builder: (_, __) => CustomPaint(
              size: Size.infinite,
              painter: AuroraPainter(
                _aurora.value * 2 * pi,
                isDark: _isDark,
              ),
            ),
          ),
          if (_isDark)
            AnimatedBuilder(
              animation: _aurora,
              builder: (_, __) => CustomPaint(
                size: Size.infinite,
                painter:
                    StarfieldPainter(_aurora.value * 2 * pi),
              ),
            ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    _appBar(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(
                            milliseconds: 380),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder:
                            (child, anim) =>
                                FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin:
                                  const Offset(0, 0.045),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(
                              '${_game.currentStep}-$_revealed'),
                          child: FadeTransition(
                            opacity: _pageInAnim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin:
                                    const Offset(0, 0.03),
                                end: Offset.zero,
                              ).animate(_pageInAnim),
                              child: _screen(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_game.showConfetti && _revealed)
            IgnorePointer(
              child: AnimatedBuilder(
                animation: _confetti,
                builder: (_, __) => CustomPaint(
                  size: Size.infinite,
                  painter:
                      ConfettiPainter(_confetti.value),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appBar() {
    final canBack = _game.canGoBack;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 2),
      child: Row(
        children: [
          // Back / brand slot keeps title centered.
          SizedBox(
            width: 44,
            child: canBack
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 21,
                      color: AppColors.textSecondary(_isDark),
                    ),
                    splashRadius: 20,
                    tooltip: 'Back',
                    onPressed: _goBack,
                  )
                : Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            AppColors.brandGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.violet
                                .withOpacity(0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🔮',
                            style:
                                TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (b) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFE879F9),
                  Color(0xFF818CF8)
                ],
              ).createShader(b),
              child: Text(
                '✦ MAGIC PAPER',
                textAlign: TextAlign.center,
                style: AppTextStyles.wordmark.copyWith(
                  color: _isDark
                      ? Colors.white
                      : AppColors.violet,
                ),
              ),
            ),
          ),
          _iconBtn(Icons.bar_chart_rounded, 'Stats',
              () => showMagicStats(context, _isDark, _game)),
          _iconBtn(Icons.auto_awesome_outlined, 'How it works',
              () => showMagicInfo(context, _isDark)),
          _iconBtn(
            _isDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            'Toggle theme',
            () {
              MagicHaptics.tap();
              widget.themeProvider.toggleTheme();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(
      IconData icon, String tip, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: AppColors.textTertiary(_isDark),
      splashRadius: 20,
      tooltip: tip,
      onPressed: onTap,
    );
  }

  Widget _screen() {
    switch (_game.currentStep) {
      case 0:
        return _introScreen();
      case 1:
        return _instructionsScreen();
      case 2:
        return _symbolsScreen();
      case 3:
        return _revealScreen();
      default:
        return _introScreen();
    }
  }

  // ── 0 · Intro ──────────────────────────────────────────
  Widget _introScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          AnimatedBuilder(
            animation: Listenable.merge(
                [_pulse, _float, _spin]),
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: CrystalOrb(
                size: 172,
                pulse: _pulseAnim.value,
                spin: _spin.value * 2 * pi,
                glyph: '🔮',
              ),
            ),
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _isDark
                  ? Colors.white.withOpacity(0.07)
                  : AppColors.violet.withOpacity(0.08),
              border: Border.all(
                  color: AppColors.glassBorder(_isDark)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF4ADE80),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_game.playCount == 0 ? 'Loved by curious minds' : '${_game.playCount} minds read so far'} · 100% mystic accuracy',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color:
                        AppColors.textSecondary(_isDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'I Can Read\nYour Mind',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.display(_isDark, size: 44),
          ),
          const SizedBox(height: 14),
          Text(
            'Think of a number. Follow three\ntiny steps. Watch the magic unfold.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body(_isDark),
          ),
          const Spacer(flex: 3),
          GradientButton(
            label: 'Begin the Magic',
            icon: Icons.auto_awesome_rounded,
            onTap: _goNext,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              MagicHaptics.tap();
              showMagicInfo(context, _isDark);
            },
            child: Text(
              'How does it work?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _isDark
                    ? AppColors.lavender
                    : AppColors.violet,
              ),
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }

  // ── 1 · Instructions + playground ──────────────────────
  Widget _instructionsScreen() {
    final tens = _example ~/ 10;
    final ones = _example % 10;
    final sum = tens + ones;
    final result = _example - sum;
    return LayoutBuilder(builder: (context, c) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            StepProgress(active: 1, isDark: _isDark),
            const SizedBox(height: 22),
            Text('Follow\nThese Steps',
                style: AppTextStyles.displaySm(_isDark)),
            const SizedBox(height: 10),
            Text(
              'Do it in your head — the example below updates live.',
              style: AppTextStyles.body(_isDark, size: 14),
            ),
            const SizedBox(height: 18),
            GlassCard(
              isDark: _isDark,
              padding: const EdgeInsets.fromLTRB(
                  18, 8, 18, 8),
              child: Column(
                children: [
                  _step('01', 'Think of a number',
                      'Any two-digit number, 10–99'),
                  _divider(),
                  _step('02', 'Add the digits',
                      'e.g.  $_example  →  $tens + $ones = $sum'),
                  _divider(),
                  _step('03', 'Subtract the sum',
                      'e.g.  $_example − $sum = $result'),
                  _divider(),
                  _step('04', 'Find your symbol',
                      'Locate $result in the grid & memorize it'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Interactive playground.
            GlassCard(
              isDark: _isDark,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('TRY IT LIVE',
                          style: AppTextStyles
                                  .eyebrow(_isDark)
                              .copyWith(fontSize: 11)),
                      const Spacer(),
                      _stepperBtn(Icons.remove_rounded,
                          () {
                        if (_example <= 10) return;
                        MagicHaptics.tap();
                        setState(() => _example--);
                      }),
                      Container(
                        width: 64,
                        alignment: Alignment.center,
                        child: Text(
                          '$_example',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors
                                .textPrimary(_isDark),
                          ),
                        ),
                      ),
                      _stepperBtn(Icons.add_rounded, () {
                        if (_example >= 99) return;
                        MagicHaptics.tap();
                        setState(() => _example++);
                      }),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.violet,
                      inactiveTrackColor:
                          AppColors.track(_isDark),
                      thumbColor: Colors.white,
                      overlayColor: AppColors.violet
                          .withOpacity(0.15),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _example.toDouble(),
                      min: 10,
                      max: 99,
                      divisions: 89,
                      label: '$_example',
                      onChanged: (v) => setState(
                          () => _example = v.round()),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: _isDark
                            ? [
                                AppColors.violet
                                    .withOpacity(0.22),
                                AppColors.indigo
                                    .withOpacity(0.12)
                              ]
                            : [
                                AppColors.violet
                                    .withOpacity(0.10),
                                AppColors.fuchsia
                                    .withOpacity(0.08)
                              ],
                      ),
                      border: Border.all(
                          color: AppColors.glassBorder(
                              _isDark)),
                    ),
                    child: Text(
                      '$_example  →  $tens + $ones = $sum  →  $_example − $sum = $result',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: AppColors
                            .textPrimary(_isDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Now find $result on the next screen — that is the number the trick always lands on.',
                    style:
                        AppTextStyles.caption(_isDark),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: "I've Got My Symbol",
              icon: Icons.arrow_forward_rounded,
              onTap: _goNext,
            ),
          ],
        ),
      );
    });
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: _isDark
          ? Colors.white.withOpacity(0.08)
          : AppColors.violet.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon,
              size: 18,
              color: _isDark
                  ? Colors.white
                  : AppColors.violet),
        ),
      ),
    );
  }

  Widget _step(String num, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 13, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
            ),
            child: Center(
                child: Text(num,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        AppTextStyles.titleSm(_isDark)),
                const SizedBox(height: 2),
                Text(sub,
                    style: AppTextStyles.caption(
                        _isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
      height: 1,
      color: (_isDark ? Colors.white : AppColors.violet)
          .withOpacity(0.09),
      indent: 4,
      endIndent: 4);

  // ── 2 · Symbols grid ───────────────────────────────────
  Widget _symbolsScreen() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              StepProgress(active: 2, isDark: _isDark),
              const SizedBox(height: 16),
              Text('Find Your Symbol',
                  style: AppTextStyles.headline(_isDark)),
              const SizedBox(height: 6),
              Text(
                'Locate your number. Stare at its symbol for 3 seconds.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(_isDark)
                    .copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16),
            child: GlassCard(
              isDark: _isDark,
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics:
                    const BouncingScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.92,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: 99,
                itemBuilder: (_, i) {
                  final n = i + 1;
                  final sym =
                      _game.symbolMap[n] ?? '✨';
                  return Semantics(
                    label: 'Number $n, symbol $sym',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10),
                        color: _isDark
                            ? Colors.white
                                .withOpacity(0.03)
                            : AppColors.violet
                                .withOpacity(0.04),
                        border: Border.all(
                          color: AppColors.glassBorder(
                              _isDark),
                          width: 0.7,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text('$n',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w600,
                                color: AppColors
                                    .textTertiary(
                                        _isDark),
                              )),
                          const SizedBox(height: 1),
                          Text(sym,
                              style: const TextStyle(
                                  fontSize: 17)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 12, 20, 26),
          child: Column(
            children: [
              _HoldToReveal(
                  isDark: _isDark, onHold: _reveal),
              const SizedBox(height: 8),
              Text(
                'Press & hold to let me peek',
                style: AppTextStyles.caption(_isDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 3 · Reveal ─────────────────────────────────────────
  Widget _revealScreen() {
    if (!_revealed) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StepProgress(active: 3, isDark: _isDark),
            const SizedBox(height: 48),
            AnimatedBuilder(
              animation: _spin,
              builder: (_, __) => CrystalOrb(
                size: 150,
                pulse: _pulseAnim.value,
                spin: _spin.value * 2 * pi,
                glyph: '👁',
              ),
            ),
            const SizedBox(height: 36),
            Text(
              'Tuning into your mind…',
              style:
                  AppTextStyles.titleSm(_isDark).copyWith(
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Hold that symbol in your head.\nDo not look away.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body(_isDark,
                  size: 14),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              child: AnimatedBuilder(
                animation: _scan,
                builder: (_, __) => ClipRRect(
                  borderRadius:
                      BorderRadius.circular(3),
                  child: Container(
                    height: 5,
                    color: AppColors.track(_isDark),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _scan.value
                            .clamp(0.0, 1.0),
                        child: Container(
                          decoration:
                              const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.violet,
                                AppColors.fuchsia
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Revealed state.
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('YOUR SYMBOL',
              style: AppTextStyles.eyebrow(_isDark)),
          const SizedBox(height: 28),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 196,
                height: 196,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.violet
                          .withOpacity(_isDark ? 0.4 : 0.22),
                      AppColors.indigo.withOpacity(
                          _isDark ? 0.16 : 0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violet
                          .withOpacity(
                              _isDark ? 0.55 : 0.3),
                      blurRadius: 80,
                      spreadRadius: 18,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(
                        _isDark ? 0.18 : 0.6),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _game.magicSymbol,
                    style: const TextStyle(fontSize: 92),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          AnimatedBuilder(
            animation: _shimmer,
            builder: (_, __) {
              final v = _shimmer.value;
              return ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: const [
                    Color(0xFFE879F9),
                    Colors.white,
                    Color(0xFF818CF8)
                  ],
                  stops: [
                    (v - 0.4).clamp(0.0, 1.0),
                    v.clamp(0.0, 1.0),
                    (v + 0.4).clamp(0.0, 1.0)
                  ],
                ).createShader(b),
                child: Text(
                  '✦ I knew it all along ✦',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: _isDark
                        ? Colors.white
                        : AppColors.violet,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Reading #${_game.playCount} · ${_game.magicSymbol} was yours',
            style: AppTextStyles.caption(_isDark),
          ),
          const SizedBox(height: 36),
          Row(
            children: [
              Expanded(
                child: GhostButton(
                  label: 'Share',
                  icon: Icons.share_rounded,
                  isDark: _isDark,
                  onTap: _share,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  label: 'Again',
                  icon: Icons.refresh_rounded,
                  expanded: false,
                  onTap: _reset,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _backToGrid,
            child: Text(
              'Back to the symbols',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary(_isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Press-and-hold CTA: fills over 900ms, then fires.
/// Prevents accidental reveals and adds ritual suspense.
class _HoldToReveal extends StatefulWidget {
  final bool isDark;
  final VoidCallback onHold;
  const _HoldToReveal(
      {required this.isDark, required this.onHold});

  @override
  State<_HoldToReveal> createState() =>
      _HoldToRevealState();
}

class _HoldToRevealState extends State<_HoldToReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hold;

  @override
  void initState() {
    super.initState();
    _hold = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900));
    _hold.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onHold();
        _hold.reset();
      }
    });
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        _hold.forward(from: 0);
      },
      onTapUp: (_) {
        if (_hold.status != AnimationStatus.completed) {
          _hold.reverse();
        }
      },
      onTapCancel: () => _hold.reverse(),
      child: AnimatedBuilder(
        animation: _hold,
        builder: (_, __) => Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29),
            gradient: AppColors.brandGradient,
            boxShadow: [
              BoxShadow(
                color:
                    AppColors.violet.withOpacity(0.45),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: Stack(
              children: [
                // Fill progress.
                FractionallySizedBox(
                  widthFactor:
                      _hold.value.clamp(0.0, 1.0),
                  child: Container(
                      color: Colors.white
                          .withOpacity(0.22)),
                ),
                const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility_rounded,
                          size: 19, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Hold to Reveal',
                          style: AppTextStyles.cta),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
