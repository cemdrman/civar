import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/feed_providers.dart';
import '../../core/routing/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/comment_card.dart';
import '../../l10n/app_localizations.dart';
import '../report/report_sheet.dart';
import 'widgets/radius_chip_bar.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedStreamProvider);
    final placesAsync = ref.watch(placesStreamProvider);
    final placeNames = {for (final p in placesAsync.value ?? []) p.id: p.name};

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: _FeedHeader(),
          ),
          const RadiusChipBar(),
          const SizedBox(height: 4),
          Expanded(
            child: feedAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        AppLocalizations.of(context)!.noCommentsInRadius,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                  itemCount: posts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return CommentCard(
                      post: post,
                      placeName: placeNames[post.placeId],
                      onTapPlace: () => context.push(RoutePaths.placeDetail(post.placeId)),
                      onTapReport: () => showReportSheet(context, ref, post.id),
                    );
                  },
                );
              },
              error: (err, st) =>
                  Center(child: Text(AppLocalizations.of(context)!.streamError(err))),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.exploreLabel, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          l10n.feedSubtitle,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
