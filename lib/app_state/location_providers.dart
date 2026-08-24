import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/geo_utils.dart';
import '../domain/repositories/location_repository.dart';
import 'repository_providers.dart';

/// Mirrors LocationRepository's current (possibly simulated) device location.
/// setPreset() is the dev-toggle hook used to demo in-range/out-of-range
/// behavior offline (see Profile's debug location control).
class SimulatedLocationNotifier extends Notifier<LatLng> {
  StreamSubscription<LatLng>? _sub;

  @override
  LatLng build() {
    final repo = ref.watch(locationRepositoryProvider);
    _sub?.cancel();
    _sub = repo.watchCurrentLocation().listen((loc) => state = loc);
    ref.onDispose(() => _sub?.cancel());
    return repo.currentLocation;
  }

  void setPreset(SimulatedPreset preset) {
    ref.read(locationRepositoryProvider).setSimulatedPreset(preset);
  }
}

final simulatedLocationProvider =
    NotifierProvider<SimulatedLocationNotifier, LatLng>(SimulatedLocationNotifier.new);
