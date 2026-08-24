import 'dart:async';

import '../../core/utils/geo_utils.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/relative_time.dart';
import '../../domain/models/place.dart';
import '../../domain/models/post.dart';
import '../../domain/models/report_reason.dart';
import '../../domain/repositories/feed_repository.dart';
import 'seed/seed_places.dart';
import 'seed/seed_posts.dart';

class MockFeedRepository implements FeedRepository {
  final List<Place> _places = List.of(seedPlaces);
  final List<Post> _posts = List.of(seedPosts);
  final _postsController = StreamController<List<Post>>.broadcast();

  void _emitPosts() => _postsController.add(List.unmodifiable(_posts));

  Place _placeById(String id) => _places.firstWhere((p) => p.id == id);

  Post _withLiveFields(Post post, LatLng viewer, double radiusKm) {
    final distanceKm = haversineKm(viewer, _placeById(post.placeId).location);
    return post.copyWith(
      distanceKm: distanceKm,
      canReplyNow: distanceKm <= radiusKm,
    );
  }

  @override
  Future<List<Place>> getPlaces() async => List.unmodifiable(_places);

  @override
  Stream<List<Place>> watchPlaces() async* {
    yield List.unmodifiable(_places);
  }

  @override
  Future<Place> getPlace(String id) async => _placeById(id);

  @override
  Stream<List<Post>> watchFeed({required LatLng viewer, required double radiusKm}) async* {
    List<Post> project() => _posts
        .map((p) => _withLiveFields(p, viewer, radiusKm))
        .where((p) => p.distanceKm <= radiusKm)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    yield project();
    await for (final _ in _postsController.stream) {
      yield project();
    }
  }

  @override
  Stream<List<Post>> watchPostsForPlace(
    String placeId, {
    required LatLng viewer,
    required double radiusKm,
  }) async* {
    List<Post> project() => _posts
        .where((p) => p.placeId == placeId)
        .map((p) => _withLiveFields(p, viewer, radiusKm))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    yield project();
    await for (final _ in _postsController.stream) {
      yield project();
    }
  }

  @override
  Future<Post> createPost({
    required String placeId,
    required String text,
    required bool hasMedia,
  }) async {
    final post = Post(
      id: generateId('post'),
      placeId: placeId,
      authorId: 'me',
      authorName: 'Sen',
      authorInitials: 'SN',
      avatarColorSeed: 0,
      text: text,
      hasMedia: hasMedia,
      createdAt: DateTime.now(),
      timeLabel: relativeTimeNow(),
      likeCount: 0,
      replyCount: 0,
    );
    _posts.insert(0, post);
    _emitPosts();
    return post;
  }

  @override
  Future<void> reportPost({required String postId, required ReportReason reason}) async {
    // Mock moderation queue: no-op resolve, matches the design's confirmation-toast flow.
  }

  @override
  Place nearestPlaceTo(LatLng viewer) {
    return _places.reduce((a, b) =>
        haversineKm(viewer, a.location) <= haversineKm(viewer, b.location) ? a : b);
  }
}
