import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/helpers/stylized_text.dart';
import 'package:time_trails/widgets/action_button.dart';

class ArPhotoOverlayScreen extends StatefulWidget {
  const ArPhotoOverlayScreen({super.key});

  @override
  State<ArPhotoOverlayScreen> createState() => _ArPhotoOverlayScreenState();
}

class _ArPhotoOverlayScreenState extends State<ArPhotoOverlayScreen> {
  double _overlayOpacity = 0.5;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      return;
    }

    final permissionsToRequest = <Permission>[];
    if (!cameraStatus.isGranted) permissionsToRequest.add(Permission.camera);
    if (!storageStatus.isGranted) permissionsToRequest.add(Permission.storage);

    if (permissionsToRequest.isNotEmpty) {
      await permissionsToRequest.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientContainer(
            color1: Color(0xFF1A1A1A),
            color2: Color(0xFF0D0D0D),
            startAlignment: Alignment.topLeft,
            endAlignment: Alignment.bottomRight,
          ),
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.none,
          ),
          IgnorePointer(
            child: Opacity(
              opacity: _overlayOpacity,
              child: Image.asset(
                'assets/images/historical_image.jpg',
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // THEN Label
          Positioned(
            top: 40,
            left: 20,
            child: StylizedText(
              'Then',
              textStyle: GoogleFonts.eagleLake(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
              textAlignment: TextAlign.center,
            ),
          ),

          // NOW Label
          Positioned(
            top: 40,
            right: 20,
            child: StylizedText(
              'Now',
              textAlignment: TextAlign.center,
              textStyle: GoogleFonts.eagleLake(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
          ),

          // Opacity Slider Card
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Overlay Opacity',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Slider(
                      activeColor: Colors.cyanAccent,
                      inactiveColor: Colors.white30,
                      value: _overlayOpacity,
                      min: 0,
                      max: 1,
                      onChanged: (value) {
                        setState(() {
                          _overlayOpacity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Return Button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              children: [
                ActionButton(
                  name: 'Back to Home',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    sessionManager.onInitialize(
      showAnimatedGuide: false,
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
    );
  }
}
