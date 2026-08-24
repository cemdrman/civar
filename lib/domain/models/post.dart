class Post {
  final String id;
  final String placeId;
  final String authorId;
  final String authorName;
  final String authorInitials;
  final int avatarColorSeed;
  final String text;
  final bool hasMedia;
  final DateTime createdAt;
  final String timeLabel;
  final int likeCount;
  final int replyCount;

  /// Computed at query time by FeedRepository — not persisted truth.
  final double distanceKm;
  final bool canReplyNow;

  const Post({
    required this.id,
    required this.placeId,
    required this.authorId,
    required this.authorName,
    required this.authorInitials,
    required this.avatarColorSeed,
    required this.text,
    required this.hasMedia,
    required this.createdAt,
    required this.timeLabel,
    required this.likeCount,
    required this.replyCount,
    this.distanceKm = 0,
    this.canReplyNow = true,
  });

  Post copyWith({double? distanceKm, bool? canReplyNow}) => Post(
        id: id,
        placeId: placeId,
        authorId: authorId,
        authorName: authorName,
        authorInitials: authorInitials,
        avatarColorSeed: avatarColorSeed,
        text: text,
        hasMedia: hasMedia,
        createdAt: createdAt,
        timeLabel: timeLabel,
        likeCount: likeCount,
        replyCount: replyCount,
        distanceKm: distanceKm ?? this.distanceKm,
        canReplyNow: canReplyNow ?? this.canReplyNow,
      );
}
