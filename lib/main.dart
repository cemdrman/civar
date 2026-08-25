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
    // On Android/iOS this reads the client ID from google-services.json /
    // GoogleService-Info.plist automatically. Flutter Web has no such file —
    // it needs an explicit web client ID — so this can fail there; that's
    // fine, email/password auth doesn't depend on it, and the "Google ile
    // devam et" button surfaces its own error if tapped when this failed.
    await GoogleSignIn.instance.initialize();
  } catch (error) {
    debugPrint('GoogleSignIn.initialize() failed (non-fatal): $error');
  }

  runApp(const ProviderScope(child: CivarApp()));
}
