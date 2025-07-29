import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/models/ar_feature_card_info.dart';
import 'package:time_trails/widgets/custom_box.dart';

class ArFeatureCard extends StatelessWidget {
  final double screenWidth;

  final ArFeatureCardInfo cardInfo;

  const ArFeatureCard({
    super.key,
    required this.screenWidth,
    required this.cardInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {},
        child: CustomBox(
          width: screenWidth * 0.9,
          height: screenWidth * 0.6,
          cornerRadius: 20,
          topSkewFactor: 0,
          bottomSkewFactor: 20,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    cardInfo.icon,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StylizedText(
                      cardInfo.title,
                      textAlignment: TextAlign.left,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    StylizedText(
                      cardInfo.description,
                      textAlignment: TextAlign.left,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.teal,
                      ),
                    ),
                    const Spacer(),
                    StylizedText(
                      cardInfo.featureName,
                      textAlignment: TextAlign.left,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}