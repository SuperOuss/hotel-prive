// lib/models/lat_lng.dart

class LatLng {
  double latitude;
  double longitude;

  LatLng({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }
}