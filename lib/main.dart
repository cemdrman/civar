import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app.dart';
import 'firebase_options.dart';

/// Pass --dart-define=USE_FIREBASE_EMULATOR=true to point the app at the
/// local Firebase Emulator Suite (see firebase.json) instead of the real
/// civar-dev cloud project. Run `firebase emulators:start` first.
///
/// Note for later: on an Android *emulator* (not a real device), 'localhost'
/// doesn't reach the host machine — use 10.0.2.2 there instead.
const _useEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (_useEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

  try {
    // serverClientId (the Firebase project's *web* OAuth client, from
    // google-services.json's client_type 3 entry) is required on Android —
    // without it, the Credential Manager-based sign-in returns no ID token,
    // so Firebase's GoogleAuthProvider.credential() call fails. Harmless to
    // pass on iOS too, where the ID token already comes from the app's own
    // CLIENT_ID in GoogleService-Info.plist.
    await GoogleSignIn.instance.initialize(
      serverClientId: '281060357755-lseb0kk7e5pnehr171afr6rll5rs935h.apps.googleusercontent.com',
    );
  } catch (error) {
    debugPrint('GoogleSignIn.initialize() failed (non-fatal): $error');
  }

  runApp(const ProviderScope(child: CivarApp()));
}
