enum MessageSender { me, them }

class Message {
  final String id;
  final String threadId;
  final MessageSender sender;
  final String text;
  final DateTime sentAt;
  final String timeLabel;

  const Message({
    required this.id,
    required this.threadId,
    required this.sender,
    required this.text,
    required this.sentAt,
    required this.timeLabel,
  });
}
