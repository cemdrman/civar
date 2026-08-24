import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared 🔒 explainer banner (DM lock, reply lock, feed card lock row).
class LockedBanner extends StatelessWidget {
  const LockedBanner({super.key, required this.message, this.compact = false});

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔒', style: TextStyle(fontSize: 11)),
          const SizedBox(width: 5),
          Text(
            message,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textFaint),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accent2Soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12.5,
          color: AppColors.accent2,
          height: 1.4,
        ),
      ),
    );
  }
}
