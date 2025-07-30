import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/widgets/ar_view.dart';
import 'package:flutter/material.dart';

class ArPhotoOverlayScreen extends StatefulWidget {
  const ArPhotoOverlayScreen({super.key});

  @override
  State<ArPhotoOverlayScreen> createState() => _ArPhotoOverlayScreenState();
}

class _ArPhotoOverlayScreenState extends State<ArPhotoOverlayScreen> {
  double _overlayOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time-Travel Lens'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.none, // no plane detection needed
          ),
          // The historical photo overlay with adjustable opacity
          IgnorePointer(
            // Let touch events pass through to ARView
            child: Opacity(
              opacity: _overlayOpacity,
              child: Image.asset(
                'assets/images/historical_image.png', // Replace with your old photo asset
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          // Slider to adjust opacity
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                const Text(
                  "Adjust Overlay Opacity",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white54,
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
          // Optional: small labels "Then" and "Now"
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.black45,
              child: const Text(
                'Then',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.black45,
              child: const Text(
                'Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
    );
  }
}