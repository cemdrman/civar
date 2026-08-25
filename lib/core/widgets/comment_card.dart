import 'package:flutter/material.dart';

import '../../domain/models/post.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'avatar_initials.dart';
import 'placeholder_box.dart';

/// Shared comment card used by both Feed and Place Detail. Feed shows the
/// tappable place-name pill and the like/reply row; Place Detail passes
/// [showPlaceTag]/[showReplyRow] false since its own sticky input handles replying.
class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.post,
    this.placeName,
    this.showPlaceTag = true,
    this.showReplyRow = true,
    this.onTapPlace,
    this.onTapReport,
  });

  final Post post;
  final String? placeName;
  final bool showPlaceTag;
  final bool showReplyRow;
  final VoidCallback? onTapPlace;
  final VoidCallback? onTapReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppRadii.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarInitials(initials: post.authorInitials, colorSeed: post.avatarColorSeed),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.timeLabel,
                          style: const TextStyle(fontSize: 12, color: AppColors.textFaint),
                        ),
                      ],
                    ),
                    if (showPlaceTag && placeName != null) ...[
                      const SizedBox(height: 3),
                      GestureDetector(
                        onTap: onTapPlace,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent2Soft,
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent2,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.placeTagDistance(placeName!, post.distanceKm.toStringAsFixed(1)),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTapReport != null)
                GestureDetector(
                  onTap: onTapReport,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text('⋯', style: TextStyle(fontSize: 16, color: AppColors.textFaint)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(post.text, style: const TextStyle(fontSize: 14.5, height: 1.45)),
          if (post.hasMedia) ...[
            const SizedBox(height: 10),
            PlaceholderBox(
              label: l10n.photoVideoLabel,
              tint: PlaceholderTint.accent,
              height: 130,
              borderRadius: 12,
            ),
          ],
          if (showReplyRow) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('♥', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(width: 5),
                Text(
                  '${post.likeCount}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                if (!post.canReplyNow)
                  Row(
                    children: [
                      const Text('🔒', style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 5),
                      Text(
                        l10n.movedAwayFromLocation,
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textFaint),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: onTapPlace,
                    child: Text(
                      l10n.replyCountLabel(post.replyCount),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
