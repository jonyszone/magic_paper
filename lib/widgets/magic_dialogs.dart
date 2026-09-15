import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/game_provider.dart';

/// Premium bottom-sheet-style dialogs with glass + CTA.
Future<void> showMagicInfo(BuildContext context, bool isDark) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _MagicDialog(
      isDark: isDark,
      glyph: '✨',
      title: 'The Magic of 9',
      body:
          'Pick any two-digit number, add its digits, then subtract that sum from the original.\n\nYou always land on a multiple of 9 — and every multiple of 9 shares one secret symbol. That is how I read your mind. 🔮',
      cta: 'Got it',
    ),
    transitionBuilder: (_, anim, __, child) => ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: anim, child: child),
    ),
  );
}

Future<void> showMagicStats(
    BuildContext context, bool isDark, GameProvider game) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => _MagicDialog(
      isDark: isDark,
      glyph: game.lastSymbol.isEmpty ? '📊' : game.lastSymbol,
      title: 'Your Journey',
      customBody: Row(
        children: [
          _StatTile(
            isDark: isDark,
            value: '${game.playCount}',
            label: 'Readings',
          ),
          const SizedBox(width: 10),
          _StatTile(
            isDark: isDark,
            value: '100%',
            label: 'Accuracy',
          ),
          const SizedBox(width: 10),
          _StatTile(
            isDark: isDark,
            value: game.lastSymbol.isEmpty ? '—' : game.lastSymbol,
            label: 'Last',
          ),
        ],
      ),
      cta: 'Continue',
    ),
    transitionBuilder: (_, anim, __, child) => ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: anim, child: child),
    ),
  );
}

class _StatTile extends StatelessWidget {
  final bool isDark;
  final String value;
  final String label;
  const _StatTile(
      {required this.isDark, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppColors.violet.withOpacity(0.07),
          border: Border.all(color: AppColors.glassBorder(isDark)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption(isDark)),
          ],
        ),
      ),
    );
  }
}

class _MagicDialog extends StatelessWidget {
  final bool isDark;
  final String glyph;
  final String title;
  final String? body;
  final Widget? customBody;
  final String cta;

  const _MagicDialog({
    required this.isDark,
    required this.glyph,
    required this.title,
    this.body,
    this.customBody,
    required this.cta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(26, 30, 26, 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: isDark
                      ? const Color(0xFF1A1040).withOpacity(0.88)
                      : Colors.white.withOpacity(0.94),
                  border: Border.all(
                      color: AppColors.glassBorder(isDark)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.brandGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violet.withOpacity(0.5),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(glyph,
                              style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: AppTextStyles.titleSm(isDark)
                            .copyWith(fontSize: 21),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      if (body != null)
                        Text(
                          body!,
                          style: AppTextStyles.body(isDark,
                              size: 14),
                          textAlign: TextAlign.center,
                        ),
                      if (customBody != null) ...[
                        const SizedBox(height: 6),
                        customBody!,
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: AppColors.brandGradient,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(cta,
                                    style: AppTextStyles.ctaSm),
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
          ),
        ),
      ),
    );
  }
}
