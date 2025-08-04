import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:time_trails/views/landmark_unlock_panel.dart';

class LandmarkUnlockScreen extends StatefulWidget {
  final List<Landmark> landmarks;

  const LandmarkUnlockScreen({
    super.key,
    required this.landmarks,
  });

  @override
  State<LandmarkUnlockScreen> createState() => _LandmarkUnlockScreenState();
}

class _LandmarkUnlockScreenState extends State<LandmarkUnlockScreen> {
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMarkerTapped(Landmark landmark) async {
    final position = await Geolocator.getCurrentPosition();
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      landmark.latitude,
      landmark.longitude,
    );
    final isNearby = distance < 50;
    if (!mounted) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (_) => LandmarkUnlockPanel(
        landmark: landmark,
        isNearby: isNearby,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _userLocation!, zoom: 14),
      myLocationEnabled: true,
      markers: widget.landmarks.map((landmark) {
        return Marker(
          markerId: MarkerId(landmark.placeId),
          position: LatLng(landmark.latitude, landmark.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          onTap: () => _onMarkerTapped(landmark),
        );
      }).toSet(),
    );
  }
}
