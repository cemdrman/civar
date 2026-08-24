import '../models/dm_thread.dart';
import '../models/message.dart';

abstract class MessagingRepository {
  Stream<List<DmThread>> watchThreads();
  Stream<List<Message>> watchMessages(String threadId);
  Future<void> sendMessage({required String threadId, required String text});
  Future<void> markThreadRead(String threadId);
}
