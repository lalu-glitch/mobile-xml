import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    final LocationSettings locationAccuracy = LocationSettings(
      accuracy: LocationAccuracy.high, // Or .medium, .low, .lowest, .reduced
      distanceFilter:
          10, // Minimum distance (in meters) before an update is triggered
    );
    return await Geolocator.getCurrentPosition(
      locationSettings: locationAccuracy,
    );
  }
}
