import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:civar/app.dart';
import 'package:civar/app_state/locale_providers.dart';
import 'package:civar/app_state/repository_providers.dart';
import 'package:civar/data/firebase/firebase_auth_repository.dart';

/// Uses firebase_auth_mocks/fake_cloud_firestore instead of a real project or
/// the emulator, so `flutter test` stays fast and hermetic. For end-to-end
/// verification against real Firebase behavior, run the app against the
/// local Emulator Suite instead (see README/firebase.json): `firebase
/// emulators:start` then `flutter run --dart-define=USE_FIREBASE_EMULATOR=true`.
void main() {
  testWidgets('App boots to onboarding welcome screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FirebaseAuthRepository(auth: MockFirebaseAuth(), firestore: FakeFirebaseFirestore()),
          ),
          // Pin the locale so this assertion doesn't depend on the test
          // runner's platform locale (defaults to Turkish, same as before
          // localization was added).
          localeProvider.overrideWith(() => _FixedLocaleNotifier()),
        ],
        child: const CivarApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Civar'), findsOneWidget);
    expect(find.text('Başla'), findsOneWidget);
  });
}

class _FixedLocaleNotifier extends LocaleNotifier {
  @override
  Locale build() => const Locale('tr');
}
