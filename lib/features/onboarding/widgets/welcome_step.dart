import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';

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
          const Text(
            'Çevrende gerçekten neler oluyor? Sadece bulunduğun yerdeki yorumları gör, konuş.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 22),
          PillButton(label: 'Başla', onPressed: onNext, expand: false),
        ],
      ),
    );
  }
}
