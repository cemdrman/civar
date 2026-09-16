# Civar

A location-based social app. Users can only post or reply to comments when
physically near the place they're pinned to; a map shows nearby places with
comment-density heat, and 1:1 DMs are allowed without a friends graph (free
users can reply to existing threads but can't start new ones — only paid
tiers can initiate).

**Platforms: iOS and Android only.** Web/macOS/Windows/Linux Flutter targets
exist because `flutter create` scaffolds them by default, but they are not
actively developed or tested — don't expect them to build cleanly.

## Stack

- **Flutter** (Dart, null-safe), **Riverpod** (`flutter_riverpod` v3, non-codegen
  `Notifier`/`StreamProvider` style) for state/DI, **go_router** with
  `StatefulShellRoute.indexedStack` for the 4-tab shell (map / feed / DMs /
  profile).
- **Firebase**: `firebase_auth` (email/password + Google Sign-In),
  `cloud_firestore`, `firebase_storage`. Firebase project: `civar-dev`.
- **Maps**: `flutter_map` with OpenStreetMap tiles (no API key required).
- **Location**: `geolocator` for real GPS; `geoflutterfire_plus` for
  geohash-based "posts within X km" queries.
- **i18n**: `flutter_localizations` + ARB files, 5 languages — Turkish
  (default/fallback), English, Arabic, Portuguese, French. See
  [lib/l10n/](lib/l10n/).

## Architecture

Every backend-facing concern is an abstract repository
(`AuthRepository`, `FeedRepository`, `LocationRepository`,
`MessagingRepository`, `MembershipRepository`, `PurchaseRepository`) under
`lib/domain/repositories/`, implemented against Firebase under
`lib/data/firebase/`, and bound via a single swap point in
[lib/app_state/repository_providers.dart](lib/app_state/repository_providers.dart).
There is no mock data layer — every repository talks to real Firebase (or
real GPS) even in local development.

`lib/data/debug/qa_location_presets.dart` holds a `kDebugMode`-only location
override (see `GeolocatorLocationRepository`) so testers can exercise
in-range/out-of-range radius behavior without physically traveling — it's
inert and unreachable in release builds.

## Running locally

```bash
flutter pub get
flutter run   # pick an iOS/Android device or simulator
```

By default the app talks to the real `civar-dev` Firebase project. To use
the local Firebase Emulator Suite instead:

```bash
firebase emulators:start   # Auth :9099, Firestore :8080, Storage :9199, UI :4000
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

On an Android *emulator* (not a real device), `localhost` doesn't reach the
host machine — the emulator config in `main.dart` targets `10.0.2.2` there;
see the comment in [lib/main.dart](lib/main.dart).

## Test data

`scripts/` holds one-off Node seed scripts. They use the same public
Firebase REST APIs a real client uses, authenticated as each seeded user's
own account, so every write is bound by `firestore.rules` exactly like the
app itself — no admin/service-account credentials involved.

```bash
node scripts/seed_test_data.mjs          # 3 test accounts + DM threads/messages
node scripts/seed_istanbul_posts.mjs     # 36 real Istanbul places (12 districts) + 5000 posts
```

Both accept `--emulator` to target the local emulator instead of
`civar-dev`. Test accounts: `ayse.test@civar.dev` / `mert.test@civar.dev` /
`elif.test@civar.dev`, password `test1234`.

## Payments

Membership purchases are **client-simulated** — `PurchaseRepository` writes
a receipt-shaped record straight to Firestore (no card data, ever). There is
no real StoreKit/Play Billing integration and no server-side receipt
verification yet; see the trust-boundary comment at the top of
`firestore.rules`. Wiring up real payments means adding the platform IAP
SDKs client-side plus a Cloud Function that verifies each receipt
server-to-server before trusting a `purchases` write.

## Firestore

`firestore.rules` and `firestore.indexes.json` are deployed with:

```bash
firebase deploy --only firestore:rules,firestore:indexes
```
