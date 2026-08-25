import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_state/feed_providers.dart';
import '../../../app_state/membership_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/widgets/radius_chip.dart';
import '../../../l10n/app_localizations.dart';

/// Horizontal radius filter chips. Tapping a chip beyond the current tier's
/// radius opens the paywall instead of updating the filter.
class RadiusChipBar extends ConsumerWidget {
  const RadiusChipBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(feedRadiusChipProvider);
    final tierRadiusKm = ref.watch(currentTierProvider).value?.radiusKm ?? 5;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: feedRadiusOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final km = feedRadiusOptions[index];
          final locked = km > tierRadiusKm;
          return RadiusChip(
            label: radiusOptionLabel(km, AppLocalizations.of(context)!.unlimitedRadius),
            selected: selected == km,
            locked: locked,
            onTap: () {
              if (locked) {
                context.push(RoutePaths.paywall);
              } else {
                ref.read(feedRadiusChipProvider.notifier).select(km);
              }
            },
          );
        },
      ),
    );
  }
}
