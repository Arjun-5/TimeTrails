import 'package:flutter/material.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/widgets/feature_button.dart';

class FeatureCardSection extends StatelessWidget {
  FeatureCardSection({super.key});

  final List<Feature> features = [
    Feature(icon: Icons.map, onTap: () {}),
    Feature(icon: Icons.camera, onTap: () {}),
    Feature(icon: Icons.directions_walk, onTap: () {}),
    Feature(icon: Icons.history_edu, onTap: () {}),
    Feature(icon: Icons.compare, onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.9,
      height: width * 0.125,
      child: Center(
        child: Row(
          spacing: width * 0.05,
          mainAxisAlignment: MainAxisAlignment.center, // Center the Row itself
          children: List.generate(
            features.length,
            (index) => Transform.translate(
              offset: Offset(index * 1, index * -10),
              child: FeatureButton(feature: features[index], width: width),
            ),
          ),
        ),
      ),
    );
  }
}