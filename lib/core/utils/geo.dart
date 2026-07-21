import 'dart:math' as math;

/// Geographic helpers.
abstract final class Geo {
  Geo._();

  static const double _earthRadiusKm = 6371.0;

  /// Great-circle (Haversine) distance between two coordinates, in kilometres.
  static double distanceKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return _earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  /// A short human label for a distance in km ("450 m", "2.3 km", "12 km").
  static String label(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    if (km < 10) return '${km.toStringAsFixed(1)} km';
    return '${km.round()} km';
  }

  static double _toRad(double deg) => deg * math.pi / 180.0;
}
