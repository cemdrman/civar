/// Turkish relative-time label for freshly created content (e.g. new posts/messages).
String relativeTimeNow() => 'şimdi';

/// Turkish relative-time label computed from an actual timestamp — used when
/// reading persisted content (Firestore posts) that may have been created
/// long before it's displayed, unlike the mock's pre-formatted seed labels.
String relativeTimeLabel(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inSeconds < 45) return relativeTimeNow();
  if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
  if (diff.inHours < 24) return '${diff.inHours} sa önce';
  if (diff.inDays < 7) return '${diff.inDays} g önce';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} hf önce';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} ay önce';
  return '${(diff.inDays / 365).floor()} yıl önce';
}
