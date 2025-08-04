import 'package:time_trails/models/landmark.dart';
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

    final testLandmarks = [
      Landmark(
        name: 'Test Landmark 1',
        latitude: 51.37635579449376, 
        longitude: 12.3971930606781,
        photoRef: '',
        placeId: 'Place1',
      ),
      Landmark(
        name: 'Test Landmark 2',
        latitude: 51.36408566582929, 
        longitude: 12.400827051979984,
        photoRef: '',
        placeId: 'Test Place2',
      ),
      Landmark(
        name: 'Test Landmark 3',
        latitude: 51.38726485483662, 
        longitude: 12.408852740966502,
        photoRef: '',
        placeId: 'Place3',
      ),
    ];

    final combinedLandmarks = [...rawLandmarks, ...testLandmarks];

    landmarks = await Future.wait(
      combinedLandmarks.map((landmark) async {
        final walking = await _distanceServices.calculateDistanceToLandmark(
          currentLatitude: userLatitude,
          currentLongitude: userLongitude,
          destinationLatitude: landmark.latitude,
          destinationLongitude: landmark.longitude,
        );

        final driving = await _distanceServices.calculateDistanceToLandmark(
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
