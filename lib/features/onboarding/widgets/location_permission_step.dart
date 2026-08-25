import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/placeholder_box.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../l10n/app_localizations.dart';

class LocationPermissionStep extends ConsumerWidget {
  const LocationPermissionStep({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
            child: PlaceholderBox(
              label: l10n.locationPermissionIllustrationLabel,
              tint: PlaceholderTint.accent2,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.locationNeededTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.locationPermissionExplainer('5 km'),
                style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: [
              PillButton(
                label: l10n.allowLocationAccess,
                onPressed: () async {
                  await ref.read(locationRepositoryProvider).requestPermission();
                  onNext();
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                child: Text(l10n.notNow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
