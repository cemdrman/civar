import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Fully-rounded CTA button used across onboarding, compose, paywall, etc.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
    this.dark = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool dark;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    if (filled) {
      background = dark ? AppColors.text : AppColors.accent;
      foreground = Colors.white;
    } else {
      background = Colors.transparent;
      foreground = AppColors.textSecondary;
    }

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: background.withValues(alpha: 0.5),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        textStyle: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontSize: 16, color: foreground),
      ),
      child: Text(label),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
