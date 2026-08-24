import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/placeholder_box.dart';
import '../../../core/widgets/pill_button.dart';

class LocationPermissionStep extends ConsumerWidget {
  const LocationPermissionStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Expanded(
            child: PlaceholderBox(
              label: 'KONUM İZNİ İLLÜSTRASYONU',
              tint: PlaceholderTint.accent2,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Konumuna ihtiyacımız var',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                  children: [
                    TextSpan(text: 'Civar, yalnızca '),
                    TextSpan(
                      text: '5 km',
                      style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text:
                          ' çapındaki yorumları gösterir. Bu çapı yalnızca aylık üyelikle artırabilirsin.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: [
              PillButton(
                label: 'Konumuma izin ver',
                onPressed: () async {
                  await ref.read(locationRepositoryProvider).requestPermission();
                  onNext();
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                child: const Text('Şimdi değil'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
