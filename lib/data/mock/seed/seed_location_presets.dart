import '../../../core/utils/geo_utils.dart';
import '../../catalog/place_catalog.dart';

/// Named presets for the dev-only location toggle (see location_repository.dart).
final simulatedPresetLocations = <String, LatLng>{
  'atBakery': defaultSimulatedLocation,
  'cityCenter': offsetFromOrigin(2.0, 1.5),
  'neighboringDistrict': offsetFromOrigin(11, -9),
  'farCity': offsetFromOrigin(-25, 20),
  'veryFar': offsetFromOrigin(90, -75),
};
