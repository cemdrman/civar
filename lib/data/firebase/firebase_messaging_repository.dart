import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../core/utils/relative_time.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/dm_thread.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/messaging_repository.dart';

class FirebaseMessagingRepository implements MessagingRepository {
  FirebaseMessagingRepository({FirebaseFirestore? firestore, fb_auth.FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _threadsRef => _firestore.collection('dmThreads');
  CollectionReference<Map<String, dynamic>> get _usersRef => _firestore.collection('users');

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Messaging called with no signed-in user.');
    return uid;
  }

  DmThread _threadFromDoc(DocumentSnapshot<Map<String, dynamic>> doc, String myUid) {
    final data = doc.data()!;
    final participantIds = List<String>.from(data['participantIds'] as List? ?? const []);
    final otherId = participantIds.firstWhere((id) => id != myUid, orElse: () => myUid);
    final names = Map<String, dynamic>.from(data['participantNames'] as Map? ?? const {});
    final initials = Map<String, dynamic>.from(data['participantInitials'] as Map? ?? const {});
    final readBy = List<String>.from(data['readBy'] as List? ?? const []);
    final lastMessageAt = (data['lastMessageAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    return DmThread(
      id: doc.id,
      participantId: otherId,
      participantName: names[otherId] as String? ?? 'Kullanıcı',
      participantInitials: initials[otherId] as String? ?? '?',
      avatarColorSeed: otherId.hashCode.abs() % 2,
      lastMessagePreview: data['lastMessagePreview'] as String? ?? '',
      lastMessageAt: lastMessageAt,
      lastMessageTimeLabel: relativeTimeLabel(lastMessageAt),
      unread: !readBy.contains(myUid),
    );
  }

  @override
  Stream<List<DmThread>> watchThreads() {
    final myUid = _uid;
    return _threadsRef
        .where('participantIds', arrayContains: myUid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => _threadFromDoc(d, myUid)).toList());
  }

  @override
  Stream<List<Message>> watchMessages(String threadId) {
    final myUid = _uid;
    return _threadsRef
        .doc(threadId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              final sentAt = (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now();
              return Message(
                id: d.id,
                threadId: threadId,
                sender: data['senderId'] == myUid ? MessageSender.me : MessageSender.them,
                text: data['text'] as String? ?? '',
                sentAt: sentAt,
                timeLabel: relativeTimeLabel(sentAt),
              );
            }).toList());
  }

  @override
  Future<void> sendMessage({required String threadId, required String text}) async {
    final myUid = _uid;
    final threadRef = _threadsRef.doc(threadId);
    await threadRef.collection('messages').doc().set({
      'senderId': myUid,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
    });
    await threadRef.update({
      'lastMessagePreview': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'readBy': [myUid],
    });
  }

  @override
  Future<void> markThreadRead(String threadId) async {
    await _threadsRef.doc(threadId).update({
      'readBy': FieldValue.arrayUnion([_uid]),
    });
  }

  @override
  Future<List<AppUser>> listDmCandidates() async {
    final myUid = _uid;
    final snap = await _usersRef.limit(50).get();
    return snap.docs.where((d) => d.id != myUid).map((d) {
      final data = d.data();
      return AppUser(
        id: d.id,
        fullName: data['fullName'] as String? ?? '',
        email: data['email'] as String? ?? '',
        initials: data['initials'] as String? ?? '?',
        photoPath: data['photoUrl'] as String?,
        bio: data['bio'] as String? ?? '',
      );
    }).toList();
  }

  @override
  Future<String> startThread(String otherUserId) async {
    final myUid = _uid;

    final existing = await _threadsRef.where('participantIds', arrayContains: myUid).get();
    for (final doc in existing.docs) {
      final ids = List<String>.from(doc.data()['participantIds'] as List? ?? const []);
      if (ids.length == 2 && ids.contains(otherUserId)) {
        return doc.id;
      }
    }

    final myData = (await _usersRef.doc(myUid).get()).data() ?? {};
    final otherData = (await _usersRef.doc(otherUserId).get()).data() ?? {};

    final newThread = await _threadsRef.add({
      'participantIds': [myUid, otherUserId],
      'participantNames': {
        myUid: myData['fullName'] ?? '',
        otherUserId: otherData['fullName'] ?? '',
      },
      'participantInitials': {
        myUid: myData['initials'] ?? '?',
        otherUserId: otherData['initials'] ?? '?',
      },
      'lastMessagePreview': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'readBy': [myUid, otherUserId],
    });
    return newThread.id;
  }
}
