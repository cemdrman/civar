import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../core/utils/geo_utils.dart';
import '../../core/utils/id_generator.dart';
import '../../core/utils/relative_time.dart';
import '../../domain/models/place.dart';
import '../../domain/models/post.dart';
import '../../domain/models/report_reason.dart';
import '../../domain/repositories/feed_repository.dart';
import '../catalog/place_catalog.dart';

class FirebaseFeedRepository implements FeedRepository {
  FirebaseFeedRepository({FirebaseFirestore? firestore, fb_auth.FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb_auth.FirebaseAuth.instance {
    _seedingFuture = _ensurePlacesSeeded();
    // Lives for the app's lifetime, same as this repository — no need to
    // hold/cancel the subscription.
    watchPlaces().listen((places) => _cachedPlaces = places);
  }

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;
  late final Future<void> _seedingFuture;
  List<Place> _cachedPlaces = [];

  CollectionReference<Map<String, dynamic>> get _placesRef => _firestore.collection('places');
  CollectionReference<Map<String, dynamic>> get _postsRef => _firestore.collection('posts');

  // ─── Places ──────────────────────────────────────────────────────────

  Future<void> _ensurePlacesSeeded() async {
    final existing = await _placesRef.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = _firestore.batch();
    for (final place in placeCatalog) {
      batch.set(_placesRef.doc(place.id), _placeToDoc(place));
    }
    await batch.commit();
  }

  Map<String, dynamic> _placeToDoc(Place place) => {
        'name': place.name,
        'category': place.category,
        'lat': place.location.lat,
        'lng': place.location.lng,
        'mapAnchorX': place.mapAnchor.dx,
        'mapAnchorY': place.mapAnchor.dy,
        'heat': place.heat,
      };

  Place _placeFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Place(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      location: LatLng((data['lat'] as num).toDouble(), (data['lng'] as num).toDouble()),
      mapAnchor: Offset((data['mapAnchorX'] as num).toDouble(), (data['mapAnchorY'] as num).toDouble()),
      heat: (data['heat'] as num).toDouble(),
    );
  }

  @override
  Future<List<Place>> getPlaces() async {
    await _seedingFuture;
    final snap = await _placesRef.get();
    return snap.docs.map(_placeFromDoc).toList();
  }

  @override
  Stream<List<Place>> watchPlaces() async* {
    await _seedingFuture;
    yield* _placesRef.snapshots().map((snap) => snap.docs.map(_placeFromDoc).toList());
  }

  @override
  Future<Place> getPlace(String id) async {
    await _seedingFuture;
    final doc = await _placesRef.doc(id).get();
    return _placeFromDoc(doc);
  }

  @override
  Place nearestPlaceTo(LatLng viewer) {
    if (_cachedPlaces.isEmpty) return placeCatalog.first;
    return _cachedPlaces.reduce(
      (a, b) => haversineKm(viewer, a.location) <= haversineKm(viewer, b.location) ? a : b,
    );
  }

  // ─── Posts ───────────────────────────────────────────────────────────

  Post _postFromDoc(DocumentSnapshot<Map<String, dynamic>> doc, {required double distanceKm, required double radiusKm}) {
    final data = doc.data()!;
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final authorId = data['authorId'] as String? ?? '';
    return Post(
      id: doc.id,
      placeId: data['placeId'] as String,
      authorId: authorId,
      authorName: data['authorName'] as String? ?? 'Kullanıcı',
      authorInitials: data['authorInitials'] as String? ?? '?',
      avatarColorSeed: authorId.hashCode.abs() % 2,
      text: data['text'] as String? ?? '',
      hasMedia: data['hasMedia'] as bool? ?? false,
      createdAt: createdAt,
      timeLabel: relativeTimeLabel(createdAt),
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      replyCount: 0,
      distanceKm: distanceKm,
      canReplyNow: distanceKm <= radiusKm,
    );
  }

  @override
  Stream<List<Post>> watchFeed({required LatLng viewer, required double radiusKm}) {
    if (radiusKm.isInfinite) {
      return _postsRef.orderBy('createdAt', descending: true).snapshots().map((snap) => snap.docs
          .map((doc) => _postFromDoc(
                doc,
                distanceKm: haversineKm(viewer, _placeLocationOf(doc.data()['placeId'] as String)),
                radiusKm: radiusKm,
              ))
          .toList());
    }

    final geoCollection = GeoCollectionReference<Map<String, dynamic>>(_postsRef);
    return geoCollection
        .subscribeWithinWithDistance(
      center: GeoFirePoint(GeoPoint(viewer.lat, viewer.lng)),
      radiusInKm: radiusKm,
      field: 'geo',
      geopointFrom: (data) => (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
      strictMode: true,
    )
        .map((geoSnaps) {
      final posts = geoSnaps
          .map((g) => _postFromDoc(g.documentSnapshot, distanceKm: g.distanceFromCenterInKm, radiusKm: radiusKm))
          .toList();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return posts;
    });
  }

  /// Distance from a place is identical for every post pinned to it, so this
  /// doesn't need a geo query — just the place's known location.
  LatLng _placeLocationOf(String placeId) {
    final place = _cachedPlaces.where((p) => p.id == placeId).firstOrNull;
    return place?.location ?? placeCatalogOrigin;
  }

  @override
  Stream<List<Post>> watchPostsForPlace(
    String placeId, {
    required LatLng viewer,
    required double radiusKm,
  }) {
    return _postsRef
        .where('placeId', isEqualTo: placeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      final distanceKm = haversineKm(viewer, _placeLocationOf(placeId));
      return snap.docs.map((doc) => _postFromDoc(doc, distanceKm: distanceKm, radiusKm: radiusKm)).toList();
    });
  }

  @override
  Future<Post> createPost({
    required String placeId,
    required String text,
    required bool hasMedia,
  }) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) throw StateError('createPost called with no signed-in user.');

    final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
    final userData = userDoc.data() ?? {};
    final place = await getPlace(placeId);

    final docRef = _postsRef.doc();
    final geoFirePoint = GeoFirePoint(GeoPoint(place.location.lat, place.location.lng));
    await docRef.set({
      'placeId': placeId,
      'authorId': fbUser.uid,
      'authorName': userData['fullName'] as String? ?? 'Kullanıcı',
      'authorInitials': userData['initials'] as String? ?? '?',
      'text': text,
      'hasMedia': hasMedia,
      'likeCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'geo': geoFirePoint.data,
    });

    return Post(
      id: docRef.id,
      placeId: placeId,
      authorId: fbUser.uid,
      authorName: userData['fullName'] as String? ?? 'Kullanıcı',
      authorInitials: userData['initials'] as String? ?? '?',
      avatarColorSeed: fbUser.uid.hashCode.abs() % 2,
      text: text,
      hasMedia: hasMedia,
      createdAt: DateTime.now(),
      timeLabel: relativeTimeNow(),
      likeCount: 0,
      replyCount: 0,
    );
  }

  @override
  Future<void> reportPost({required String postId, required ReportReason reason}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('reportPost called with no signed-in user.');
    await _firestore.collection('reports').doc(generateId('report')).set({
      'postId': postId,
      'reason': reason.name,
      'reportedBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
