import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../l10n/app_localizations.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Civar',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 34,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.onboardingTagline,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 22),
          PillButton(
            label: AppLocalizations.of(context)!.onboardingStart,
            onPressed: onNext,
            expand: false,
          ),
        ],
      ),
    );
  }
}
