import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Circular initials avatar. Alternates accent/accent2 soft backgrounds by
/// [colorSeed] parity, matching the design's avatar coloring.
class AvatarInitials extends StatelessWidget {
  const AvatarInitials({
    super.key,
    required this.initials,
    this.colorSeed = 0,
    this.size = 38,
  });

  final String initials;
  final int colorSeed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isEven = colorSeed % 2 == 0;
    final background = isEven ? AppColors.accentSoft : AppColors.accent2Soft;
    final foreground = isEven ? AppColors.accentDark : AppColors.accent2;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        initials,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.34,
        ),
      ),
    );
  }
}
