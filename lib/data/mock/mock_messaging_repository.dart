import 'dart:async';

import '../../core/utils/id_generator.dart';
import '../../core/utils/relative_time.dart';
import '../../domain/models/dm_thread.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/messaging_repository.dart';
import 'seed/seed_dm_threads.dart';

class MockMessagingRepository implements MessagingRepository {
  final List<DmThread> _threads = List.of(seedDmThreads);
  final Map<String, List<Message>> _messages = {
    for (final entry in seedMessages.entries) entry.key: List.of(entry.value),
  };

  final _threadsController = StreamController<List<DmThread>>.broadcast();
  final _messagesController = StreamController<String>.broadcast();

  void _emitThreads() => _threadsController.add(List.unmodifiable(_threads));

  @override
  Stream<List<DmThread>> watchThreads() async* {
    yield List.unmodifiable(_threads);
    await for (final _ in _threadsController.stream) {
      yield List.unmodifiable(_threads);
    }
  }

  @override
  Stream<List<Message>> watchMessages(String threadId) async* {
    List<Message> current() => List.unmodifiable(_messages[threadId] ?? const []);
    yield current();
    await for (final updatedThreadId in _messagesController.stream) {
      if (updatedThreadId == threadId) yield current();
    }
  }

  @override
  Future<void> sendMessage({required String threadId, required String text}) async {
    final message = Message(
      id: generateId('msg'),
      threadId: threadId,
      sender: MessageSender.me,
      text: text,
      sentAt: DateTime.now(),
      timeLabel: relativeTimeNow(),
    );
    _messages.putIfAbsent(threadId, () => []).add(message);
    _messagesController.add(threadId);

    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index != -1) {
      _threads[index] = _threads[index].copyWith(
        lastMessagePreview: text,
        lastMessageAt: message.sentAt,
        lastMessageTimeLabel: relativeTimeNow(),
      );
      _emitThreads();
    }
  }

  @override
  Future<void> markThreadRead(String threadId) async {
    final index = _threads.indexWhere((t) => t.id == threadId);
    if (index != -1 && _threads[index].unread) {
      _threads[index] = _threads[index].copyWith(unread: false);
      _emitThreads();
    }
  }
}
