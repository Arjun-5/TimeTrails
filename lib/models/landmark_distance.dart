import 'package:time_trails/models/landmark.dart';

class LandmarkDistance {
  final Landmark landmark;
  final String walkingDistance;
  final String drivingDistance;

  LandmarkDistance({
    required this.landmark,
    required this.walkingDistance,
    required this.drivingDistance,
  });
}
