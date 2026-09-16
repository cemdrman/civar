import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/repository_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../domain/models/app_user.dart';
import '../../l10n/app_localizations.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final blockedAsync = ref.watch(_blockedUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.blockedUsersScreenTitle)),
      body: blockedAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noBlockedUsersMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _BlockedUserTile(user: users[index]),
          );
        },
        error: (err, st) => Center(child: Text(l10n.streamError(err))),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final _blockedUsersProvider = StreamProvider.autoDispose<List<AppUser>>(
  (ref) => ref.watch(authRepositoryProvider).watchBlockedUsers(),
);

class _BlockedUserTile extends ConsumerWidget {
  const _BlockedUserTile({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.card - 2),
      ),
      child: Row(
        children: [
          AvatarInitials(initials: user.initials, colorSeed: user.id.hashCode.abs() % 2),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => ref.read(authRepositoryProvider).unblockUser(user.id),
            child: Text(l10n.unblockUserAction),
          ),
        ],
      ),
    );
  }
}
