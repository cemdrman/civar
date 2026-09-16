import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/place.dart';
import '../domain/models/post.dart';
import 'auth_providers.dart';
import 'location_providers.dart';
import 'membership_providers.dart';
import 'repository_providers.dart';

/// The four selectable feed radius options, matching the design's chips.
const feedRadiusOptions = <double>[5, 20, 50, double.infinity];

String radiusOptionLabel(double km, String unlimitedLabel) =>
    km.isInfinite ? unlimitedLabel : '${km.toInt()} km';

class RadiusChipNotifier extends Notifier<double> {
  @override
  double build() => feedRadiusOptions.first;

  /// Caller (radius_chip_bar) is responsible for checking against the current
  /// tier's radius and routing to /paywall instead of calling this when locked.
  void select(double km) => state = km;
}

final feedRadiusChipProvider =
    NotifierProvider<RadiusChipNotifier, double>(RadiusChipNotifier.new);

final placesStreamProvider = StreamProvider<List<Place>>(
  (ref) => ref.watch(feedRepositoryProvider).watchPlaces(),
);

final feedStreamProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final repo = ref.watch(feedRepositoryProvider);
  final viewer = ref.watch(simulatedLocationProvider);
  final radiusKm = ref.watch(feedRadiusChipProvider);
  return repo.watchFeed(viewer: viewer, radiusKm: radiusKm);
});

/// Unfiltered (global radius) post stream — used by the map to compute
/// per-place comment-count badges regardless of the viewer's current tier.
final allPostsStreamProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final repo = ref.watch(feedRepositoryProvider);
  final viewer = ref.watch(simulatedLocationProvider);
  return repo.watchFeed(viewer: viewer, radiusKm: double.infinity);
});

final placePostsStreamProvider =
    StreamProvider.autoDispose.family<List<Post>, String>((ref, placeId) {
  final repo = ref.watch(feedRepositoryProvider);
  final viewer = ref.watch(simulatedLocationProvider);
  final radiusKm = ref.watch(currentTierProvider).value?.radiusKm ?? feedRadiusOptions.first;
  return repo.watchPostsForPlace(placeId, viewer: viewer, radiusKm: radiusKm);
});

/// The signed-in user's own posts — drives the profile screen's stats and
/// "your comments" grid. Empty (not an error) while there's no signed-in
/// user yet.
final myPostsStreamProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final uid = ref.watch(currentUserProvider).value?.id;
  if (uid == null) return Stream.value(const []);
  return ref.watch(feedRepositoryProvider).watchPostsByAuthor(uid);
});
