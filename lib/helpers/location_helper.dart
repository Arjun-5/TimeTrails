import 'package:geolocator/geolocator.dart';

Future<Position> getUserLocation() async {
  bool isLocationServicesEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationServicesEnabled) {
    throw Exception('Location Services are Disabled');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location Permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permissions are permanently denied, cannot request permissions.',
    );
  }
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10,
  );

  return await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );
}
