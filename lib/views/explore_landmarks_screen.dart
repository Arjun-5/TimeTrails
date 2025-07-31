import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExploreLandmarksScreen extends StatefulWidget {
  final List<Landmark> landmarks;
  final String apiKey;

  const ExploreLandmarksScreen({
    super.key,
    required this.landmarks,
    required this.apiKey,
  });

  @override
  State<ExploreLandmarksScreen> createState() => _ExploreLandmarksScreenState();
}

class _ExploreLandmarksScreenState extends State<ExploreLandmarksScreen> {
  GoogleMapController? _mapController;

  void _showLandmarkDetails(Landmark landmark) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              landmark.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (landmark.photoRef.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: landmark.photoUrl(widget.apiKey),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Launch AR
                  },
                  icon: const Icon(Icons.view_in_ar),
                  label: const Text("View in AR"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Full image view
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Full Image"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return widget.landmarks.map((landmark) {
      return Marker(
        markerId: MarkerId(landmark.id),
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

    await Future.delayed(const Duration(milliseconds: 100)); // Wait for map to settle
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.landmarks.isNotEmpty
        ? LatLng(widget.landmarks.first.latitude, widget.landmarks.first.longitude)
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
