import '../../core/utils/geo_utils.dart';

/// Named simulated-location presets used to demo the in-range/out-of-range
/// behavior offline (see mock implementation + app_state/location_providers.dart).
enum SimulatedPreset { atBakery, cityCenter, neighboringDistrict, farCity, veryFar }

extension SimulatedPresetLabel on SimulatedPreset {
  String get label => switch (this) {
        SimulatedPreset.atBakery => 'Kumsal Fırın\'da (0.1 km)',
        SimulatedPreset.cityCenter => 'Şehir merkezi (~3 km)',
        SimulatedPreset.neighboringDistrict => 'Komşu mahalle (~15 km)',
        SimulatedPreset.farCity => 'Uzak şehir (~35 km)',
        SimulatedPreset.veryFar => 'Çok uzak (~120 km)',
      };
}

abstract class LocationRepository {
  Stream<LatLng> watchCurrentLocation();
  LatLng get currentLocation;

  /// Wraps the OS permission prompt. The return value doesn't affect distance
  /// math — the simulated location remains the source of truth (see §6 of plan).
  Future<bool> requestPermission();

  void setSimulatedLocation(LatLng location);
  void setSimulatedPreset(SimulatedPreset preset);
}
