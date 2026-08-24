import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/auth_providers.dart';
import '../../app_state/location_providers.dart';
import '../../app_state/membership_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/routing/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../domain/repositories/location_repository.dart';

/// Presentational seed data for the "Yorumların" grid — matches the design's
/// MY_POSTS constant. Not modeled as a domain entity since it's static display
/// content, not something the app mutates.
const _myPosts = [
  ('Kumsal Fırın', 'Su böreği efsane, katılıyorum.'),
  ('Sahil Parkı', 'Kahve arabası bugün de buradaydı.'),
  ('Yalı Kahvesi', 'Masa 4 manzaralı, oraya oturun.'),
  ('Liman Duvarı', 'Gün batımında fotoğraf çekilir.'),
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final tier = ref.watch(currentTierProvider).value;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                child: Text(
                  user?.initials ?? '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tier?.label ?? ''} planı',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadii.card - 2),
            ),
            child: const Row(
              children: [
                _StatCell(value: '14', label: 'Yorum', showDivider: true),
                _StatCell(value: '212', label: 'Beğeni', showDivider: true),
                _StatCell(value: '9', label: 'Mekan', showDivider: false),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => context.push(RoutePaths.paywall),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.text,
                borderRadius: BorderRadius.circular(AppRadii.card - 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${tier?.radiusLabel ?? ''} çap aktif',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Planını yönet veya yükselt',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Yorumların', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              for (final (place, snippet) in _myPosts)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        place,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent2,
                        ),
                      ),
                      Text(
                        snippet,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadii.card - 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const _SettingsRow(label: 'Bildirimler'),
                const _SettingsRow(label: 'Gizlilik'),
                const _SettingsRow(label: 'Engellenenler'),
                _SettingsRow(
                  label: 'Çıkış yap',
                  color: AppColors.danger,
                  showDivider: false,
                  onTap: () => ref.read(authRepositoryProvider).signOut(),
                ),
              ],
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 20),
            const Text(
              'Dev: Konumu değiştir',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textFaint),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in SimulatedPreset.values)
                  ActionChip(
                    label: Text(preset.label, style: const TextStyle(fontSize: 11.5)),
                    onPressed: () =>
                        ref.read(simulatedLocationProvider.notifier).setPreset(preset),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label, required this.showDivider});

  final String value;
  final String label;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(right: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, this.color, this.onTap, this.showDivider = true});

  final String label;
  final Color? color;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Text(label, style: TextStyle(fontSize: 14, color: color ?? AppColors.text)),
      ),
    );
  }
}
