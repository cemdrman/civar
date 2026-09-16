import '../../core/utils/geo_utils.dart';
import '../models/place.dart';
import '../models/post.dart';
import '../models/report_reason.dart';

abstract class FeedRepository {
  Future<List<Place>> getPlaces();

  /// Includes live comment counts per place, for map heat/badge sizing.
  Stream<List<Place>> watchPlaces();

  Future<Place> getPlace(String id);

  Stream<List<Post>> watchFeed({required LatLng viewer, required double radiusKm});

  Stream<List<Post>> watchPostsForPlace(
    String placeId, {
    required LatLng viewer,
    required double radiusKm,
  });

  /// Drives the profile screen's own-posts grid and stats. Distance-based
  /// fields ([Post.distanceKm]/[Post.canReplyNow]) aren't meaningful here —
  /// a profile shows all of the author's own posts regardless of where the
  /// viewer currently is — so they're left at their defaults.
  Stream<List<Post>> watchPostsByAuthor(String authorId);

  Future<Post> createPost({
    required String placeId,
    required String text,
    required bool hasMedia,
  });

  Future<void> reportPost({required String postId, required ReportReason reason});

  /// Drives the compose screen's "Şu an: `<mekan>`" location chip.
  Place nearestPlaceTo(LatLng viewer);
}
