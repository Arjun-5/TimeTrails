import 'package:flutter/material.dart';
import 'package:time_trails/models/ar_feature_card_info.dart';
import 'package:time_trails/widgets/ar_feature_card.dart';

class ArCardSection extends StatelessWidget {
  final List<ArFeatureCardInfo> cardInfos = [
    ArFeatureCardInfo(
      title: 'Place a Mini Landmark',
      description:
          'Preview a heritage monument in your space. Move around and explore it in 3D.',
      featureName: '3D Model Preview',
      icon: Icons.view_in_ar_outlined,
    ),
    ArFeatureCardInfo(
      title: 'Time-Travel Lens',
      description:
          'Blend the past with the present using your camera to reveal historical views.',
      featureName: 'Photo Overlay Mode',
      icon: Icons.compare_rounded,
    ),
    ArFeatureCardInfo(
      title: 'Discover in AR',
      description:
          'Point your camera and uncover floating facts, stories, and trivia.',
      featureName: 'Floating Info Cards',
      icon: Icons.info_outlined,
    ),
  ];

  ArCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final sidePadding = MediaQuery.of(context).size.width * 0.05;
    final double cardWidth = screenWidth * 0.9; 
    return SizedBox(
      height: screenWidth * 0.5,
      child: PageView.builder(
        itemCount: cardInfos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? sidePadding : 8,
              right: index == cardInfos.length - 1 ? sidePadding : 8,
            ),
            child: ArFeatureCard(
              screenWidth: cardWidth,
              cardInfo: cardInfos[index],
            ),
          );
        },
      ),
    );
  }
}
