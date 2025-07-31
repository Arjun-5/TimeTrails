import 'package:flutter/material.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/data/feature_card_data.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/widgets/feature_button.dart';

class FeatureCardSection extends StatelessWidget {
  final LandmarkController landmarkController;
  final String apiKey;

  const FeatureCardSection({
    super.key,
    required this.landmarkController,
    required this.apiKey,
  });

  @override
  Widget build(BuildContext context) {
    final List<Feature> features = getFeatureCards(
      context,
      landmarkController,
      apiKey,
    );
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
