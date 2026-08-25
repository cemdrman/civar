import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase/firebase_auth_repository.dart';
import '../data/firebase/firebase_feed_repository.dart';
import '../data/firebase/firebase_membership_repository.dart';
import '../data/firebase/firebase_purchase_repository.dart';
import '../data/mock/mock_location_repository.dart';
import '../data/mock/mock_messaging_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/feed_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/membership_repository.dart';
import '../domain/repositories/messaging_repository.dart';
import '../domain/repositories/purchase_repository.dart';

/// Single swap point for every backend-facing repository. Users, posts,
/// membership, and purchases are Firebase-backed (see data/firebase/); DM
/// and device location remain mock for now (see data/mock/) — DM has no
/// real threading model yet, and location is inherently a device API, not
/// backend data.
final authRepositoryProvider = Provider<AuthRepository>((ref) => FirebaseAuthRepository());

final locationRepositoryProvider =
    Provider<LocationRepository>((ref) => MockLocationRepository());

final feedRepositoryProvider = Provider<FeedRepository>((ref) => FirebaseFeedRepository());

final messagingRepositoryProvider =
    Provider<MessagingRepository>((ref) => MockMessagingRepository());

final membershipRepositoryProvider =
    Provider<MembershipRepository>((ref) => FirebaseMembershipRepository());

final purchaseRepositoryProvider =
    Provider<PurchaseRepository>((ref) => FirebasePurchaseRepository());
