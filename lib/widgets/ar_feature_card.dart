import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/widgets/custom_box.dart';

class ArFeatureCard extends StatelessWidget {
  final double screenWidth;

  const ArFeatureCard({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1),
      child: InkWell(
        onTap: () {},
        child: CustomBox(
          width: screenWidth * 0.9,
          height: screenWidth * 0.6,
          cornerRadius: 20,
          topSkewFactor: 0,
          bottomSkewFactor: 20,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/200/200',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Text(
                  'Landmark Name',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
