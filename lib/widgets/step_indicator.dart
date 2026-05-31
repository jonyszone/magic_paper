import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final bool isDark;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: isActive 
                ? AppColors.primary 
                : (isDark ? Colors.white24 : Colors.black12),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
