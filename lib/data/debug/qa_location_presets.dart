import '../../core/utils/geo_utils.dart';
import '../catalog/place_catalog.dart';

/// Named presets for the debug-only QA location override (kDebugMode-gated,
/// see GeolocatorLocationRepository). Not shipped/active in release builds —
/// this exists so testers can exercise the in-range/out-of-range radius
/// behavior without physically traveling between the seeded places.
final simulatedPresetLocations = <String, LatLng>{
  'atBakery': defaultSimulatedLocation,
  'cityCenter': offsetFromOrigin(2.0, 1.5),
  'neighboringDistrict': offsetFromOrigin(11, -9),
  'farCity': offsetFromOrigin(-25, 20),
  'veryFar': offsetFromOrigin(90, -75),
};
