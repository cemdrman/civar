import 'package:flutter/material.dart';

import '../../core/utils/geo_utils.dart';

class Place {
  final String id;
  final String name;
  final String category;
  final LatLng location;

  /// Fractional (0..1) position on the placeholder map box, e.g. Offset(0.62, 0.28)
  /// for the design's `left:62%, top:28%`.
  final Offset mapAnchor;

  /// Static 0..1 density value driving the map's heat-circle size (design's
  /// per-place `heat` seed value) — independent of the live comment count.
  final double heat;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.mapAnchor,
    required this.heat,
  });
}
