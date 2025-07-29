import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/location_helper.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:time_trails/widgets/ar_feature_card.dart';
import 'package:time_trails/widgets/custom_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:time_trails/widgets/feature_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LandmarkController _landmarkController = LandmarkController();

  final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;

  late Future<void> _initFuture;

  List<Feature> features = [];

  bool _isDataLoding = false;

  @override
  void initState() {
    super.initState();
    _initFuture = _initSetup();
    //_init();
  }

  Future<void> _initSetup() async {
    //_init();
    features = [
      Feature(icon: Icons.map, onTap: () {}),
      Feature(icon: Icons.camera, onTap: () {}),
      Feature(icon: Icons.directions_walk, onTap: () {}),
      Feature(icon: Icons.history_edu, onTap: () {}),
      Feature(icon: Icons.compare, onTap: () {}),
    ];
  }

  Future<void> _init() async {
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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, _) {
          final size = MediaQuery.of(context).size;

          final width = size.width;

          final height = size.height;

          final double circleDiameter = width;

          final double cardWidth = width * 0.9; // Each card takes 90% of screen

          final double sidePadding = (width - cardWidth) / 2;

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

                        SizedBox(
                          height: width * 0.5,
                          child: PageView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? sidePadding : 8,
                                  right: index == 2 ? sidePadding : 8,
                                ),
                                child: ArFeatureCard(screenWidth: cardWidth),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: height * 0.9,
                          height: width * 0.125,
                          child: Center(
                            child: Row(
                              spacing: width * 0.05,
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the Row itself
                              children: List.generate(
                                features.length,
                                (index) =>
                                    FeatureButton(feature: features[index], width: width,),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _isDataLoding
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.7,
                                    ),
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  //final item = _landmarkController.landmarks[index];
                                  //final Landmark landmark = item['landmark'];
                                  //final walking = item['walking'];
                                  //final driving = item['driving'];

                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: CustomBox(
                                      width: 200,
                                      height: 100,
                                      cornerRadius: 20,
                                      topSkewFactor: 20,
                                      bottomSkewFactor: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: CachedNetworkImage(
                                              //imageUrl: landmark.photoUrl(_apiKey),
                                              imageUrl:
                                                  "https://fastly.picsum.photos/id/1029/200/200.jpg?hmac=CQyxD4azaGb2UDjepBq254UP9v1mF-_rBhYVx8Jw8rs",
                                              height: 80,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          StylizedText(
                                            //landmark.name,
                                            "Landmark Name",
                                            textAlignment: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          StylizedText(
                                            //'Distance: ${landmark.name}',
                                            "Landmark Distance",
                                            textAlignment: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
