// Legacy compatibility: MagicButton now delegates to the new chrome.
import 'package:flutter/material.dart';
import 'magic_chrome.dart';

class MagicButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const MagicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: GhostButton(
          label: text,
          icon: icon ?? Icons.auto_awesome_outlined,
          onTap: onPressed,
          isDark: isDark,
        ),
      );
    }
    return GradientButton(
      label: text,
      onTap: onPressed,
      icon: icon,
    );
  }
}
