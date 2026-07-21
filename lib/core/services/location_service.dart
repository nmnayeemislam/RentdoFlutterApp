import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

/// The user's last-known coordinates. (Named to avoid clashing with
/// `latlong2`'s `LatLng` used by the map screen.)
typedef GeoCoords = ({double lat, double lng});

/// Raised when a device location can't be obtained, with a user-facing reason.
class LocationException implements Exception {
  const LocationException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Thin wrapper over `geolocator` that handles the service/permission dance and
/// returns plain [GeoCoords]. Throws [LocationException] with a friendly message.
class LocationService {
  const LocationService();

  Future<GeoCoords> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
          'Location is turned off. Enable it in your device settings.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException('Location permission was denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
          'Location permission is permanently denied. Enable it in app settings.');
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return (lat: pos.latitude, lng: pos.longitude);
  }
}

final locationServiceProvider =
    Provider<LocationService>((_) => const LocationService());

/// The user's current coordinates once resolved via "use my location". Drives
/// distance-to-listing labels across the app; `null` until first requested.
final userLocationProvider = StateProvider<GeoCoords?>((_) => null);
