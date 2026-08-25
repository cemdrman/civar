import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/feed_providers.dart';
import '../../app_state/location_providers.dart';
import '../../app_state/membership_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/constants/post_limits.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/geo_utils.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/comment_card.dart';
import '../../core/widgets/locked_banner.dart';
import '../../core/widgets/placeholder_box.dart';
import '../../l10n/app_localizations.dart';
import '../report/report_sheet.dart';

class PlaceDetailScreen extends ConsumerStatefulWidget {
  const PlaceDetailScreen({super.key, required this.placeId});

  final String placeId;

  @override
  ConsumerState<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submitReply(String placeId) async {
    final text = _replyController.text.trim();
    if (text.isEmpty || text.length > postTextMaxLength) return;
    await ref.read(feedRepositoryProvider).createPost(placeId: placeId, text: text, hasMedia: false);
    _replyController.clear();
    if (mounted) showAppToast(context, AppLocalizations.of(context)!.commentPosted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final places = ref.watch(placesStreamProvider).value ?? const [];
    final place = places.where((p) => p.id == widget.placeId).firstOrNull;
    final postsAsync = ref.watch(placePostsStreamProvider(widget.placeId));
    final viewer = ref.watch(simulatedLocationProvider);
    final tierRadiusKm = ref.watch(currentTierProvider).value?.radiusKm ?? 5;

    if (place == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final canReplyNow = haversineKm(viewer, place.location) <= tierRadiusKm;
    final posts = postsAsync.value ?? const [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: PlaceholderBox(
                              label: l10n.placePhotoLabel,
                              tint: PlaceholderTint.accent,
                              borderRadius: 0,
                            ),
                          ),
                          Positioned(
                            top: 14,
                            left: 14,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).maybePop(),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            l10n.placeDetailMeta(
                              place.category,
                              haversineKm(viewer, place.location).toStringAsFixed(1),
                              posts.length,
                            ),
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                    sliver: SliverList.separated(
                      itemCount: posts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return CommentCard(
                          post: post,
                          showPlaceTag: false,
                          showReplyRow: false,
                          onTapReport: () => showReportSheet(context, ref, post.id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: canReplyNow
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _replyController,
                          builder: (context, value, _) {
                            final charCount = value.text.characters.length;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4, right: 4),
                              child: Text(
                                '$charCount/$postTextMaxLength',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: charCount >= postTextMaxLength
                                      ? AppColors.accentDark
                                      : AppColors.textFaint,
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _replyController,
                                maxLength: postTextMaxLength,
                                decoration: InputDecoration(
                                  hintText: l10n.writeCommentHint,
                                  filled: true,
                                  fillColor: AppColors.surface2,
                                  counterText: '',
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppRadii.pill),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSubmitted: (_) => _submitReply(place.id),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _submitReply(place.id),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: LockedBanner(
                        message: l10n.replyLockedMessage,
                        compact: true,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
