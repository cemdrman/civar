class DmThread {
  final String id;
  final String participantId;
  final String participantName;
  final String participantInitials;
  final int avatarColorSeed;
  final String lastMessagePreview;
  final DateTime lastMessageAt;
  final String lastMessageTimeLabel;
  final bool unread;

  const DmThread({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantInitials,
    required this.avatarColorSeed,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.lastMessageTimeLabel,
    required this.unread,
  });

  DmThread copyWith({
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    String? lastMessageTimeLabel,
    bool? unread,
  }) => DmThread(
        id: id,
        participantId: participantId,
        participantName: participantName,
        participantInitials: participantInitials,
        avatarColorSeed: avatarColorSeed,
        lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        lastMessageTimeLabel: lastMessageTimeLabel ?? this.lastMessageTimeLabel,
        unread: unread ?? this.unread,
      );
}
