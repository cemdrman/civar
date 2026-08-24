import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_auth_repository.dart';
import '../data/mock/mock_feed_repository.dart';
import '../data/mock/mock_location_repository.dart';
import '../data/mock/mock_membership_repository.dart';
import '../data/mock/mock_messaging_repository.dart';
import '../data/mock/mock_purchase_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/feed_repository.dart';
import '../domain/repositories/location_repository.dart';
import '../domain/repositories/membership_repository.dart';
import '../domain/repositories/messaging_repository.dart';
import '../domain/repositories/purchase_repository.dart';

/// Single swap point: override these with Firebase-backed implementations
/// later (e.g. `ProviderScope(overrides: [authRepositoryProvider.overrideWithValue(...)])`)
/// — nothing else in the app needs to change.
final authRepositoryProvider = Provider<AuthRepository>((ref) => MockAuthRepository());

final locationRepositoryProvider =
    Provider<LocationRepository>((ref) => MockLocationRepository());

final feedRepositoryProvider = Provider<FeedRepository>((ref) => MockFeedRepository());

final messagingRepositoryProvider =
    Provider<MessagingRepository>((ref) => MockMessagingRepository());

final membershipRepositoryProvider =
    Provider<MembershipRepository>((ref) => MockMembershipRepository());

final purchaseRepositoryProvider =
    Provider<PurchaseRepository>((ref) => MockPurchaseRepository());
