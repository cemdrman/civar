import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum PlaceholderTint { neutral, accent, accent2 }

/// The striped-gradient placeholder used for the map, hero photos, the
/// location-permission illustration, and photo/video attach slots.
class PlaceholderBox extends StatelessWidget {
  const PlaceholderBox({
    super.key,
    required this.label,
    this.tint = PlaceholderTint.neutral,
    this.borderRadius = 20,
    this.height,
    this.child,
  });

  final String label;
  final PlaceholderTint tint;
  final double borderRadius;
  final double? height;
  final Widget? child;

  Color get _stripeColor => switch (tint) {
        PlaceholderTint.accent => AppColors.accentSoft,
        PlaceholderTint.accent2 => AppColors.accent2Soft,
        PlaceholderTint.neutral => AppColors.surface2,
      };

  Color get _labelColor => switch (tint) {
        PlaceholderTint.accent => AppColors.accentDark,
        PlaceholderTint.accent2 => AppColors.accent2,
        PlaceholderTint.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_stripeColor, AppColors.bg],
            stops: const [0.4, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: _labelColor,
                  ),
                ),
              ),
            ),
            ?child,
          ],
        ),
      ),
    );
  }
}
