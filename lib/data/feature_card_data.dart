import 'package:flutter/material.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/views/explore_landmarks_screen.dart';
import 'package:time_trails/views/landmark_unlock_screen.dart';
import 'package:time_trails/views/logs_map_screen.dart';
import 'package:time_trails/views/walking_tour_screen.dart';

List<Feature> getFeatureCards(
  BuildContext context,
  LandmarkController landmarkController,
  String apiKey,
) => [
  Feature(
    icon: Icons.map,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExploreLandmarksScreen(
            landmarks: landmarkController.landmarks
                .map((e) => e.landmark)
                .toList(),
            apiKey: apiKey,
          ),
        ),
      );
    },
  ),
  Feature(icon: Icons.book_online, onTap: () {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LogsMapScreen()),
      );
  }),
  Feature(
    icon: Icons.directions_walk,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WalkingTourScreen(
            landmarks: landmarkController.landmarks
                .map((e) => e.landmark)
                .toList(),
            googleApiKey: apiKey,
          ),
        ),
      );
    },
  ),
  Feature(
    icon: Icons.history_edu,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LandmarkUnlockScreen(
            landmarks: landmarkController.landmarks
                .map((e) => e.landmark)
                .toList(),
            apiKey: apiKey,
          ),
        ),
      );
    },
  ),
  Feature(
    icon: Icons.book_rounded,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LogsMapScreen()),
      );
    },
  ),
];
