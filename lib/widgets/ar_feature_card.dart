import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        onTap: () {
          cardInfo.onTap();
        },
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
                  child: Icon(cardInfo.icon, size: 28, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      cardInfo.title,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      minFontSize: 8,
                      maxFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    AutoSizeText(
                      cardInfo.description,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      minFontSize: 8,
                      maxFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    AutoSizeText(
                      cardInfo.featureName,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      minFontSize: 8,
                      maxFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
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
