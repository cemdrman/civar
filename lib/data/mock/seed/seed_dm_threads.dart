import '../../../domain/models/dm_thread.dart';
import '../../../domain/models/message.dart';

/// Exact DM data from the design handoff (AppScreens.dc.html DM_THREADS const).
final seedDmThreads = <DmThread>[
  DmThread(
    id: 't1',
    participantId: 'u_deniz',
    participantName: 'Deniz Y.',
    participantInitials: 'DY',
    avatarColorSeed: 1,
    lastMessagePreview: 'Tatlıcı önerini denedim, harika çıktı, teşekkürler!',
    lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
    lastMessageTimeLabel: '2 sa',
    unread: true,
  ),
  DmThread(
    id: 't2',
    participantId: 'u_elif',
    participantName: 'Elif S.',
    participantInitials: 'ES',
    avatarColorSeed: 1,
    lastMessagePreview: 'Fotoğrafı atar mısın?',
    lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
    lastMessageTimeLabel: '1g',
    unread: false,
  ),
];

final seedMessages = <String, List<Message>>{
  't1': [
    Message(
      id: 'm1',
      threadId: 't1',
      sender: MessageSender.them,
      text: 'Selam! Yorumunu gördüm, Kumsal Fırın gerçekten o kadar iyi mi?',
      sentAt: DateTime.now().subtract(const Duration(hours: 3)),
      timeLabel: '14:02',
    ),
    Message(
      id: 'm2',
      threadId: 't1',
      sender: MessageSender.me,
      text: 'Kesinlikle, su böreği kaçırılmaz.',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
      timeLabel: '14:10',
    ),
    Message(
      id: 'm3',
      threadId: 't1',
      sender: MessageSender.them,
      text: 'Tatlıcı önerini denedim, harika çıktı, teşekkürler!',
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      timeLabel: '16:44',
    ),
  ],
  't2': [
    Message(
      id: 'm4',
      threadId: 't2',
      sender: MessageSender.them,
      text: 'Yalı Kahvesi\'ndeki masa manzarasını çok merak ettim.',
      sentAt: DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
      timeLabel: 'Dün 10:20',
    ),
    Message(
      id: 'm5',
      threadId: 't2',
      sender: MessageSender.them,
      text: 'Fotoğrafı atar mısın?',
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      timeLabel: 'Dün 10:21',
    ),
  ],
};
