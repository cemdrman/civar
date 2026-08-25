import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/app_user.dart';
import '../../domain/models/membership_tier.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb_auth.FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? fb_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final fb_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  AppUser _userFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      initials: data['initials'] as String? ?? '?',
      photoPath: data['photoUrl'] as String?,
      bio: data['bio'] as String? ?? '',
    );
  }

  Map<String, dynamic> _profileFields(AppUser user) => {
        'fullName': user.fullName,
        'email': user.email,
        'initials': user.initials,
        'photoUrl': user.photoPath,
        'bio': user.bio,
      };

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().asyncExpand((fbUser) {
      if (fbUser == null) return Stream.value(null);
      // Note: right after createAccount()/signInWithGoogle() this can emit a
      // single transient `null` if the Firestore doc write hasn't reached
      // this listener yet — it self-corrects on the doc's own creation event
      // a moment later. currentUser() below (used by the router) sidesteps
      // this by reading the doc directly instead of racing the stream.
      return _userDoc(fbUser.uid).snapshots().map((doc) => doc.exists ? _userFromDoc(doc) : null);
    });
  }

  @override
  Future<AppUser?> currentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    final doc = await _userDoc(fbUser.uid).get();
    return doc.exists ? _userFromDoc(doc) : null;
  }

  @override
  Future<AppUser> createAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = AppUser.fromFullName(id: credential.user!.uid, fullName: fullName, email: email);
    await _userDoc(user.id).set({
      ..._profileFields(user),
      'tierId': TierId.free.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await credential.user!.updateDisplayName(fullName);
    return user;
  }

  @override
  Future<SignInResult> signInWithEmail({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final doc = await _userDoc(credential.user!.uid).get();
      if (!doc.exists) {
        return const SignInResult.failure(SignInFailureReason.other);
      }
      return SignInResult.success(_userFromDoc(doc));
    } on fb_auth.FirebaseAuthException catch (e) {
      // Modern Firebase projects have email-enumeration protection on, so
      // "no such user" and "wrong password" both surface as one generic code.
      const invalidCodes = {'invalid-credential', 'user-not-found', 'wrong-password', 'invalid-email'};
      return SignInResult.failure(
        invalidCodes.contains(e.code) ? SignInFailureReason.invalidCredentials : SignInFailureReason.other,
      );
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final googleAccount = await GoogleSignIn.instance.authenticate();
    final idToken = googleAccount.authentication.idToken;
    final credential = fb_auth.GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _auth.signInWithCredential(credential);
    final fbUser = userCredential.user!;

    final docRef = _userDoc(fbUser.uid);
    final existing = await docRef.get();
    if (existing.exists) {
      return _userFromDoc(existing);
    }

    final fullName = fbUser.displayName ?? googleAccount.displayName ?? 'Kullanıcı';
    final email = fbUser.email ?? googleAccount.email;
    final user = AppUser.fromFullName(id: fbUser.uid, fullName: fullName, email: email);
    await docRef.set({
      ..._profileFields(user),
      'tierId': TierId.free.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return user;
  }

  @override
  Future<AppUser> updateProfile({String? photoPath, String? bio}) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) {
      throw StateError('updateProfile called with no signed-in user.');
    }
    final docRef = _userDoc(fbUser.uid);
    final current = _userFromDoc(await docRef.get());
    final updated = current.copyWith(photoPath: photoPath, bio: bio);
    await docRef.update(_profileFields(updated));
    return updated;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
