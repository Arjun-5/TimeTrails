import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_trails/Controller/landmark_controller.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/location_helper.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:time_trails/widgets/custom_box.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LandmarkController _landmarkController = LandmarkController();

  final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;

  bool _isDataLoding = false;

  @override
  void initState() {
    super.initState();

    //_init();
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
              _isDataLoding
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: SizedBox(
                        height: height * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,//_landmarkController.landmarks.length,
                          itemBuilder: (context, index) {
                            //final item = _landmarkController.landmarks[index];
                            //final Landmark landmark = item['landmark'];
                            //final walking = item['walking'];
                            //final driving = item['driving'];

                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: CustomBox(
                                width:200,
                                height: 100,
                                skewFactor: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),  
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        //imageUrl: landmark.photoUrl(_apiKey),
                                        imageUrl: "https://fastly.picsum.photos/id/1029/200/200.jpg?hmac=CQyxD4azaGb2UDjepBq254UP9v1mF-_rBhYVx8Jw8rs",
                                        height: 125,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    StylizedText(
                                      //landmark.name,
                                      "Landmark Name",
                                      textAlignment: TextAlign.center,
                                    ),
                                    const SizedBox(height: 25),
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
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
