import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:geolocator/geolocator.dart' as geo;

import '../../core/utils/geo_utils.dart';
import '../../domain/repositories/location_repository.dart';
import '../catalog/place_catalog.dart';
import '../debug/qa_location_presets.dart';

/// Real device GPS via `geolocator`. [setSimulatedLocation]/[setSimulatedPreset]
/// remain as a kDebugMode-only override for QA (see LocationRepository doc
/// comment) — they're no-ops in release builds, so production always reflects
/// the real position.
class GeolocatorLocationRepository implements LocationRepository {
  GeolocatorLocationRepository() {
    _startListening();
  }

  LatLng _current = defaultSimulatedLocation;
  LatLng? _debugOverride;
  StreamSubscription<geo.Position>? _positionSub;
  final _controller = StreamController<LatLng>.broadcast();

  Future<void> _startListening() async {
    if (_positionSub != null) return;
    try {
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied ||
          permission == geo.LocationPermission.deniedForever) {
        return; // Stays on the seed default until permission is granted.
      }
      final initial = await geo.Geolocator.getCurrentPosition();
      _current = LatLng(initial.latitude, initial.longitude);
      if (_debugOverride == null) _controller.add(_current);

      _positionSub = geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(distanceFilter: 25),
      ).listen((position) {
        _current = LatLng(position.latitude, position.longitude);
        if (_debugOverride == null) _controller.add(_current);
      });
    } catch (_) {
      // Stays on the seed default location (e.g. denied, or no GPS on this
      // platform/environment such as a plain web tab without a fix yet).
    }
  }

  @override
  LatLng get currentLocation => _debugOverride ?? _current;

  @override
  Stream<LatLng> watchCurrentLocation() async* {
    yield currentLocation;
    yield* _controller.stream;
  }

  @override
  Future<bool> requestPermission() async {
    try {
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      final granted = permission == geo.LocationPermission.always ||
          permission == geo.LocationPermission.whileInUse;
      if (granted) await _startListening();
      return granted;
    } catch (_) {
      return false;
    }
  }

  @override
  void setSimulatedLocation(LatLng location) {
    if (!kDebugMode) return;
    _debugOverride = location;
    _controller.add(location);
  }

  @override
  void setSimulatedPreset(SimulatedPreset preset) {
    if (!kDebugMode) return;
    final location = simulatedPresetLocations[preset.name];
    if (location != null) setSimulatedLocation(location);
  }
}
