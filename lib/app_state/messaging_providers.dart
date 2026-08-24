import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/dm_thread.dart';
import '../domain/models/message.dart';
import 'repository_providers.dart';

final dmThreadsStreamProvider = StreamProvider<List<DmThread>>(
  (ref) => ref.watch(messagingRepositoryProvider).watchThreads(),
);

final dmMessagesProvider = StreamProvider.autoDispose.family<List<Message>, String>(
  (ref, threadId) => ref.watch(messagingRepositoryProvider).watchMessages(threadId),
);
