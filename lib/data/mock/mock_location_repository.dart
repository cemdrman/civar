import 'dart:async';

import 'package:geolocator/geolocator.dart' as geo;

import '../../core/utils/geo_utils.dart';
import '../../domain/repositories/location_repository.dart';
import 'seed/seed_places.dart';

class MockLocationRepository implements LocationRepository {
  LatLng _current = defaultSimulatedLocation;
  final _controller = StreamController<LatLng>.broadcast();

  @override
  LatLng get currentLocation => _current;

  @override
  Stream<LatLng> watchCurrentLocation() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<bool> requestPermission() async {
    // Triggers a real OS permission dialog via geolocator. The outcome doesn't
    // affect distance math — the simulated location remains the source of
    // truth (see LocationRepository doc comment) — so failures are swallowed.
    try {
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      return permission == geo.LocationPermission.always ||
          permission == geo.LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  @override
  void setSimulatedLocation(LatLng location) {
    _current = location;
    _controller.add(_current);
  }

  @override
  void setSimulatedPreset(SimulatedPreset preset) {
    final location = simulatedPresetLocations[preset.name];
    if (location != null) setSimulatedLocation(location);
  }
}
