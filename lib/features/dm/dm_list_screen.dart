import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/membership_providers.dart';
import '../../app_state/messaging_providers.dart';
import '../../core/routing/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/locked_banner.dart';
import 'widgets/thread_tile.dart';

class DmListScreen extends ConsumerWidget {
  const DmListScreen({super.key});

  void _openNewMessage(BuildContext context, WidgetRef ref) {
    final threads = ref.read(dmThreadsStreamProvider).value ?? const [];
    showDialog<void>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Kiminle konuşmak istersin?'),
        children: [
          for (final t in threads)
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.push(RoutePaths.dmThread(t.id));
              },
              child: Text(t.participantName),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(dmThreadsStreamProvider);
    final canSendNewDm = ref.watch(currentTierProvider).value?.canSendNewDm ?? false;
    final locked = !canSendNewDm;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mesajlar', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                GestureDetector(
                  onTap: () {
                    if (locked) {
                      context.push(RoutePaths.paywall);
                    } else {
                      _openNewMessage(context, ref);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (locked) ...[
                          const Text('🔒', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 5),
                        ],
                        const Text(
                          'Yeni mesaj',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (locked)
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 4, 18, 4),
              child: LockedBanner(
                message: 'Ücretsiz üyeler yeni sohbet başlatamaz, ama gelen mesajlara yanıt verebilir.',
              ),
            ),
          Expanded(
            child: threadsAsync.when(
              data: (threads) => ListView.builder(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),
                itemCount: threads.length,
                itemBuilder: (context, index) {
                  final t = threads[index];
                  return ThreadTile(
                    thread: t,
                    onTap: () => context.push(RoutePaths.dmThread(t.id)),
                  );
                },
              ),
              error: (err, st) => Center(child: Text('Bir şeyler ters gitti: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
