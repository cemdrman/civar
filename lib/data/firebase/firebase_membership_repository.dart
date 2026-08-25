import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../domain/models/membership_tier.dart';
import '../../domain/repositories/membership_repository.dart';
import '../catalog/membership_tiers.dart';

class FirebaseMembershipRepository implements MembershipRepository {
  FirebaseMembershipRepository({FirebaseFirestore? firestore, fb_auth.FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;

  MembershipTier _tierById(String? id) => membershipTierCatalog.firstWhere(
        (t) => t.id.name == id,
        orElse: () => membershipTierCatalog.first,
      );

  @override
  List<MembershipTier> getTiers() => List.unmodifiable(membershipTierCatalog);

  @override
  Stream<MembershipTier> watchCurrentTier() {
    // Reacts to auth changes (not just the uid at subscribe-time) so a
    // sign-out/sign-in cycle re-targets the new user's doc instead of
    // staying bound to whoever was signed in when this stream was created.
    return _auth.authStateChanges().asyncExpand((fbUser) {
      if (fbUser == null) return Stream.value(membershipTierCatalog.first);
      return _firestore
          .collection('users')
          .doc(fbUser.uid)
          .snapshots()
          .map((doc) => _tierById(doc.data()?['tierId'] as String?));
    });
  }

  @override
  Future<void> switchTier(TierId id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('switchTier called with no signed-in user.');
    await _firestore.collection('users').doc(uid).update({'tierId': id.name});
  }
}
