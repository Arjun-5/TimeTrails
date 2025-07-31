import 'package:flutter/material.dart';
import 'package:time_trails/data/ar_feature_cards_data.dart';
import 'package:time_trails/models/ar_feature_card_info.dart';
import 'package:time_trails/widgets/ar_feature_card.dart';

class ArFeatureCardSection extends StatelessWidget {
  const ArFeatureCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArFeatureCardInfo> cardInfos = arFeatureCards(context);
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
