import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/location_helper.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/widgets/ar_feature_card_section.dart';
import 'package:time_trails/widgets/feature_card_section.dart';
import 'package:time_trails/widgets/landmark_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LandmarkController _landmarkController = LandmarkController();

  bool _isDataLoding = true;

  @override
  void initState() {
    super.initState();
    _initSetup();
  }

  Future<void> _initSetup() async {
    try {
      Position userPosition = await getUserLocation();
      await _landmarkController.loadLandmarksWithDistances(
        userPosition.latitude,
        userPosition.longitude,
      );
    } catch (e) {
      debugPrint('Error getting Location or fetching Landmarks : $e');
    } finally {
      setState(() {
        _isDataLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final double circleDiameter = width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, _) {
          return Stack(
            children: [
              SizedBox.expand(
                child: GradientContainer(
                  color1: const Color.fromARGB(255, 27, 25, 26),
                  color2: const Color.fromARGB(255, 33, 18, 37),
                  startAlignment: Alignment.topLeft,
                  endAlignment: Alignment.bottomRight,
                ),
              ),
              Positioned(
                left: width * -0.44,
                top: height * 0.7,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: CircleWidget(
                      circleSize: Size(circleDiameter, circleDiameter),
                      circleColor1: Color(0xFF09FBD3),
                      circleColor2: Color.fromARGB(255, 1, 147, 123),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StylizedText(
                          'Time Trails',
                          textAlignment: TextAlign.left,
                          textStyle: GoogleFonts.eagleLake(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 30),

                        ArFeatureCardSection(),
                        const SizedBox(height: 70),
                        FeatureCardSection(
                          landmarkController: _landmarkController,
                        ),
                        const SizedBox(height: 24),

                        _isDataLoding
                            ? const Center(child: CircularProgressIndicator())
                            : LandmarkGrid(
                                landmarks: _landmarkController.landmarks,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
