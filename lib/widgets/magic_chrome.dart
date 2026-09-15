import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Frosted-glass card used for steps, grids and dialogs.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool isDark;

  const GlassCard({
    super.key,
    required this.child,
    required this.isDark,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: AppColors.glassFill(isDark),
            border:
                Border.all(color: AppColors.glassBorder(isDark), width: 1),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.10),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Primary gradient CTA + ghost secondary. 56px tall, 28px radius,
/// full-width by default — thumb-friendly on any phone.
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool expanded;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final btn = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: onTap == null
            ? LinearGradient(colors: [
                Colors.grey.withOpacity(0.4),
                Colors.grey.withOpacity(0.3)
              ])
            : AppColors.brandGradient,
        boxShadow: onTap == null
            ? null
            : [
                BoxShadow(
                  color: AppColors.violet.withOpacity(0.45),
                  blurRadius: 26,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 19, color: Colors.white),
                  const SizedBox(width: 10),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cta,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (expanded) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const GhostButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.8),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.18)
                : AppColors.violet.withOpacity(0.25),
            width: 1.4,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      size: 18,
                      color: isDark
                          ? Colors.white70
                          : AppColors.violet),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Colors.white.withOpacity(0.85)
                          : AppColors.violet,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Labeled 4-step progress rail: Imagine → Calculate → Memorize → Reveal.
class StepProgress extends StatelessWidget {
  final int active; // 1..3 for steps 2..4 (0 hides on intro)
  final bool isDark;
  final List<String> labels;

  const StepProgress({
    super.key,
    required this.active,
    required this.isDark,
    this.labels = const ['Calculate', 'Memorize', 'Reveal'],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = (i ~/ 2) + 1 < active;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: done
                    ? AppColors.violet
                    : AppColors.track(isDark),
              ),
            ),
          );
        }
        final idx = i ~/ 2;
        final stepNum = idx + 1;
        final isDone = stepNum < active;
        final isCurrent = stepNum == active;
        final Color fg = isDone || isCurrent
            ? Colors.white
            : AppColors.textTertiary(isDark);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    (isDone || isCurrent) ? AppColors.brandGradient : null,
                color: (isDone || isCurrent)
                    ? null
                    : AppColors.track(isDark),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color:
                              AppColors.violet.withOpacity(0.5),
                          blurRadius: 12,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : Text(
                        '$stepNum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: fg,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[idx],
              style: TextStyle(
                fontSize: 10.5,
                fontWeight:
                    isCurrent ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.6,
                color: isCurrent
                    ? AppColors.textPrimary(isDark)
                    : AppColors.textTertiary(isDark),
              ),
            ),
          ],
        );
      }),
    );
  }
}
