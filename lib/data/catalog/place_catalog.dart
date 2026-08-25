import 'dart:ui';

import '../../core/utils/geo_utils.dart';
import '../../domain/models/place.dart';

/// A fixed origin (arbitrary coastal-town coordinate) that all catalog
/// places are offset from.
const placeCatalogOrigin = LatLng(41.0500, 29.0000);

const _kmLat = 1 / 111.0;
const _kmLng = 1 / 84.0;

/// Offsets [placeCatalogOrigin] by the given north/east distance in km.
LatLng offsetFromOrigin(double dNorthKm, double dEastKm) => LatLng(
      placeCatalogOrigin.lat + dNorthKm * _kmLat,
      placeCatalogOrigin.lng + dEastKm * _kmLng,
    );

/// Initial set of places. Seeded into Firestore once on first run by
/// FirebaseFeedRepository — see its ensurePlacesSeeded().
final placeCatalog = <Place>[
  Place(
    id: 'p1',
    name: 'Kumsal Fırın & Tatlı',
    category: 'Tatlı/Pastane',
    location: offsetFromOrigin(0.3, 0.25),
    mapAnchor: const Offset(0.62, 0.28),
    heat: 0.34,
  ),
  Place(
    id: 'p2',
    name: 'Liman Duvarı',
    category: 'Sokak',
    location: offsetFromOrigin(-0.8, 0.7),
    mapAnchor: const Offset(0.30, 0.55),
    heat: 0.22,
  ),
  Place(
    id: 'p3',
    name: 'Sahil Parkı',
    category: 'Park',
    location: offsetFromOrigin(-1.9, 1.8),
    mapAnchor: const Offset(0.68, 0.70),
    heat: 0.22,
  ),
  Place(
    id: 'p4',
    name: 'Yalı Kahvesi',
    category: 'Kafe',
    location: offsetFromOrigin(2.2, -2.3),
    mapAnchor: const Offset(0.20, 0.40),
    heat: 0.34,
  ),
  Place(
    id: 'p5',
    name: 'Balık Pazarı',
    category: 'Pazar',
    location: offsetFromOrigin(-3.5, -2.8),
    mapAnchor: const Offset(0.46, 0.82),
    heat: 0.13,
  ),
];

/// Default simulated device location: ~0.1km from p1, matching the design's
/// default compose-screen chip "Şu an: Kumsal Fırın & Tatlı".
final defaultSimulatedLocation = offsetFromOrigin(0.05, 0.06);
