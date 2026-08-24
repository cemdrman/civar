import 'dart:ui';

import '../../../core/utils/geo_utils.dart';
import '../../../domain/models/place.dart';

/// A fixed origin (arbitrary coastal-town coordinate) that all seed places
/// are offset from, so haversineKm reproduces the design's stated distances
/// from the default simulated location (see mock_location_repository.dart).
const _origin = LatLng(41.0500, 29.0000);

/// ~1km of latitude ≈ 0.009 deg; ~1km of longitude at this latitude ≈ 0.0119 deg.
const _kmLat = 1 / 111.0;
const _kmLng = 1 / 84.0;

LatLng _offsetKm(double dNorthKm, double dEastKm) => LatLng(
      _origin.lat + dNorthKm * _kmLat,
      _origin.lng + dEastKm * _kmLng,
    );

/// Exact places from the design handoff (AppScreens.dc.html PLACES const).
final seedPlaces = <Place>[
  Place(
    id: 'p1',
    name: 'Kumsal Fırın & Tatlı',
    category: 'Tatlı/Pastane',
    location: _offsetKm(0.3, 0.25),
    mapAnchor: const Offset(0.62, 0.28),
    heat: 0.34,
  ),
  Place(
    id: 'p2',
    name: 'Liman Duvarı',
    category: 'Sokak',
    location: _offsetKm(-0.8, 0.7),
    mapAnchor: const Offset(0.30, 0.55),
    heat: 0.22,
  ),
  Place(
    id: 'p3',
    name: 'Sahil Parkı',
    category: 'Park',
    location: _offsetKm(-1.9, 1.8),
    mapAnchor: const Offset(0.68, 0.70),
    heat: 0.22,
  ),
  Place(
    id: 'p4',
    name: 'Yalı Kahvesi',
    category: 'Kafe',
    location: _offsetKm(2.2, -2.3),
    mapAnchor: const Offset(0.20, 0.40),
    heat: 0.34,
  ),
  Place(
    id: 'p5',
    name: 'Balık Pazarı',
    category: 'Pazar',
    location: _offsetKm(-3.5, -2.8),
    mapAnchor: const Offset(0.46, 0.82),
    heat: 0.13,
  ),
];

/// Default simulated device location: ~0.1km from p1, matching the design's
/// default compose-screen chip "Şu an: Kumsal Fırın & Tatlı".
final defaultSimulatedLocation = _offsetKm(0.05, 0.06);

/// Named presets for the dev location toggle (see location_repository.dart).
final simulatedPresetLocations = <String, LatLng>{
  'atBakery': defaultSimulatedLocation,
  'cityCenter': _offsetKm(2.0, 1.5),
  'neighboringDistrict': _offsetKm(11, -9),
  'farCity': _offsetKm(-25, 20),
  'veryFar': _offsetKm(90, -75),
};
