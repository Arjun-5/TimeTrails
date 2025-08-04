import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:time_trails/views/ar_view_screen.dart';
import 'package:time_trails/views/full_screen_image_view.dart';

class ExploreLandmarksScreen extends StatefulWidget {
  final List<Landmark> landmarks;

  const ExploreLandmarksScreen({
    super.key,
    required this.landmarks,
  });

  @override
  State<ExploreLandmarksScreen> createState() => _ExploreLandmarksScreenState();
}

class _ExploreLandmarksScreenState extends State<ExploreLandmarksScreen> {
  GoogleMapController? _mapController;

  Future<void> _handleViewInAR(Landmark landmark) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeInfo = await firestore
          .collection('places')
          .doc(landmark.placeId)
          .get();

      if (!mounted) return;

      if (placeInfo.exists) {
        final modelUrl = placeInfo.data()?['modelUrl'];
        if (modelUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ArViewScreen(modelUrl: modelUrl)),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Model URL missing.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No AR model found for this landmark.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load AR model: $e")));
    }
  }

  void _handleFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageView(imageUrl: imageUrl),
      ),
    );
  }

  void _showLandmarkDetails(Landmark landmark) {
    showModalBottomSheet(
      context: context,
      builder: (_) => FutureBuilder<String>(
        future: landmark.getPhotoUrl(),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  landmark.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator())
                else if (snapshot.hasError)
                  const Text('Failed to load image.')
                else if (snapshot.hasData)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Text('No image available.'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _handleViewInAR(landmark),
                      icon: const Icon(Icons.view_in_ar),
                      label: const Text("View in AR"),
                    ),
                    ElevatedButton.icon(
                      onPressed: snapshot.hasData
                          ? () => _handleFullImage(snapshot.data!)
                          : null,
                      icon: const Icon(Icons.image),
                      label: const Text("Full Image"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return widget.landmarks.map((landmark) {
      return Marker(
        markerId: MarkerId(landmark.placeId),
        position: LatLng(landmark.latitude, landmark.longitude),
        infoWindow: InfoWindow(
          title: landmark.name,
          snippet: 'Tap for details',
          onTap: () => _showLandmarkDetails(landmark),
        ),
      );
    }).toSet();
  }

  void _fitAllMarkers(List<Landmark> landmarks) async {
    if (_mapController == null || landmarks.isEmpty) return;

    final latitudes = landmarks.map((e) => e.latitude);
    final longitudes = landmarks.map((e) => e.longitude);

    final southwest = LatLng(
      latitudes.reduce((a, b) => a < b ? a : b),
      longitudes.reduce((a, b) => a < b ? a : b),
    );
    final northeast = LatLng(
      latitudes.reduce((a, b) => a > b ? a : b),
      longitudes.reduce((a, b) => a > b ? a : b),
    );

    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    await Future.delayed(const Duration(milliseconds: 100));
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.landmarks.isNotEmpty
        ? LatLng(
            widget.landmarks.first.latitude,
            widget.landmarks.first.longitude,
          )
        : const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Landmarks')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: initial, zoom: 13),
        markers: _buildMarkers(),
        onMapCreated: (controller) {
          _mapController = controller;
          _fitAllMarkers(widget.landmarks);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
