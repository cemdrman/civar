import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firebase/firebase_auth_repository.dart';
import '../data/firebase/firebase_feed_repository.dart';
import '../data/firebase/firebase_membership_repository.dart';
import '../data/firebase/firebase_messaging_repository.dart';
import '../data/firebase/firebase_purchase_repository.dart';
import '../data/firebase/geolocator_location_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/feed_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/membership_repository.dart';
import '../domain/repositories/messaging_repository.dart';
import '../domain/repositories/purchase_repository.dart';

/// Single swap point for every backend-facing repository — every one of
/// them is now Firebase- (or real-device-) backed; there's no mock layer
/// left. See data/firebase/ for implementations and data/debug/ for the
/// kDebugMode-only QA location override.
final authRepositoryProvider = Provider<AuthRepository>((ref) => FirebaseAuthRepository());

final locationRepositoryProvider =
    Provider<LocationRepository>((ref) => GeolocatorLocationRepository());

final feedRepositoryProvider = Provider<FeedRepository>((ref) => FirebaseFeedRepository());

final messagingRepositoryProvider =
    Provider<MessagingRepository>((ref) => FirebaseMessagingRepository());

final membershipRepositoryProvider =
    Provider<MembershipRepository>((ref) => FirebaseMembershipRepository());

final purchaseRepositoryProvider =
    Provider<PurchaseRepository>((ref) => FirebasePurchaseRepository());
