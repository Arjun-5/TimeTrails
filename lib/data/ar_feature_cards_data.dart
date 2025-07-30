import 'package:flutter/material.dart';
import 'package:time_trails/landing_page/landing_page.dart';
import 'package:time_trails/models/ar_feature_card_info.dart';
import 'package:time_trails/views/ar_view_screen.dart';

List<ArFeatureCardInfo> arFeatureCards(BuildContext context) => [
  ArFeatureCardInfo(
    title: 'Place a Mini Landmark',
    description:
        'Preview a heritage monument in your space. Move around and explore it in 3D.',
    featureName: '3D Model Preview',
    icon: Icons.view_in_ar_outlined,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArViewScreen() //LandingPage(), //Ar3DModelScreen()),
        ),
      );
    },
  ),
  ArFeatureCardInfo(
    title: 'Time-Travel Lens',
    description:
        'Blend the past with the present using your camera to reveal historical views.',
    featureName: 'Photo Overlay Mode',
    icon: Icons.compare_rounded,
    onTap: () {
      // Example placeholder
      print("Photo overlay mode tapped");
    },
  ),
  ArFeatureCardInfo(
    title: 'Discover in AR',
    description:
        'Point your camera and uncover floating facts, stories, and trivia.',
    featureName: 'Floating Info Cards',
    icon: Icons.info_outlined,
    onTap: () {
      // Example placeholder
      print("Floating info tapped");
    },
  ),
];
