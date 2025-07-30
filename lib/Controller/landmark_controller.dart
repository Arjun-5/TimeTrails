import 'package:time_trails/models/landmark_distance.dart';
import 'package:time_trails/services/distance_matrix_service.dart';
import 'package:time_trails/services/landmark_service.dart';

class LandmarkController {
  final _landmarkServices = LandmarkService();

  final _distanceServices = DistanceMatrixService();

  List<LandmarkDistance> landmarks = [];

  Future<void> loadLandmarksWithDistances(
    double userLatitude,
    double userLongitude,
  ) async {
    final rawLandmarks = await _landmarkServices.fetchNearbyLandmarks(
      userLatitude,
      userLongitude,
    );

    landmarks = await Future.wait(
      rawLandmarks.map((landmark) async {
        final walking = await _distanceServices.getDistanceToLandmark(
          currentLatitude: userLatitude,
          currentLongitude: userLongitude,
          destinationLatitude: landmark.latitude,
          destinationLongitude: landmark.longitude,
        );

        final driving = await _distanceServices.getDistanceToLandmark(
          currentLatitude: userLatitude,
          currentLongitude: userLongitude,
          destinationLatitude: landmark.latitude,
          destinationLongitude: landmark.longitude,
          mode: 'driving',
        );

        return LandmarkDistance(
          landmark: landmark,
          walkingDistance: walking,
          drivingDistance: driving,
        );
      }),
    );
  }
}
