import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/helpers/stylized_text.dart';

class TextCarousel extends StatelessWidget {
  final List<String> carouselTexts;
  final CarouselSliderController sliderController;
  final void Function(int, CarouselPageChangedReason)? onPageChanged;

  const TextCarousel({
    super.key,
    required this.carouselTexts,
    required this.sliderController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 120,
      child: CarouselSlider.builder(
        itemCount: carouselTexts.length,
        carouselController: sliderController,
        itemBuilder: (context, index, _) {
          return StylizedText(
            carouselTexts[index],
            textAlignment: TextAlign.center,
            textStyle: GoogleFonts.robotoMono(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          );
        },
        options: CarouselOptions(
          height: 50,
          autoPlay: true,
          viewportFraction: 1.0,
          enlargeCenterPage: true,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}
