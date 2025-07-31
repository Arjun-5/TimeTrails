import 'package:flutter/material.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/views/explore_landmarks_screen.dart';

List<Feature> getFeatureCards(BuildContext context, LandmarkController landmarkController, String apiKey) => [
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
  Feature(icon: Icons.camera, onTap: () {}),
  Feature(icon: Icons.directions_walk, onTap: () {}),
  Feature(icon: Icons.history_edu, onTap: () {}),
  Feature(icon: Icons.compare, onTap: () {}),
];
