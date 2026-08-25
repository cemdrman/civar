import '../models/app_user.dart';
import '../models/dm_thread.dart';
import '../models/message.dart';

abstract class MessagingRepository {
  Stream<List<DmThread>> watchThreads();
  Stream<List<Message>> watchMessages(String threadId);
  Future<void> sendMessage({required String threadId, required String text});
  Future<void> markThreadRead(String threadId);

  /// Users the signed-in user could start a new DM with — everyone else,
  /// since there's no friends/follow graph (see product spec: no adding
  /// friends, DM only).
  Future<List<AppUser>> listDmCandidates();

  /// Returns an existing 1:1 thread with [otherUserId] if one exists,
  /// otherwise creates one. Backs the "Yeni mesaj" flow.
  Future<String> startThread(String otherUserId);
}
