import 'dart:math' as math;

class LatLng {
  final double lat;
  final double lng;
  const LatLng(this.lat, this.lng);
}

/// Great-circle distance between two points in kilometers.
double haversineKm(LatLng a, LatLng b) {
  const earthRadiusKm = 6371.0;
  final dLat = _degToRad(b.lat - a.lat);
  final dLng = _degToRad(b.lng - a.lng);
  final lat1 = _degToRad(a.lat);
  final lat2 = _degToRad(b.lat);

  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLng / 2), 2);
  final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  return earthRadiusKm * c;
}

double _degToRad(double deg) => deg * (math.pi / 180);
