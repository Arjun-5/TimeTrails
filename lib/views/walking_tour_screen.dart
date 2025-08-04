import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:time_trails/models/landmark.dart';

class WalkingTourScreen extends StatefulWidget {
  final List<Landmark> landmarks;

  const WalkingTourScreen({required this.landmarks, super.key});

  @override
  State<WalkingTourScreen> createState() => _WalkingTourScreenState();
}

class _WalkingTourScreenState extends State<WalkingTourScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  LatLng? userLocation;
  String distance = '';
  String duration = '';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = LatLng(pos.latitude, pos.longitude);
    });

    _addLandmarkMarkers();
  }

  void _addLandmarkMarkers() {
    Set<Marker> newMarkers = widget.landmarks.map((landmark) {
      return Marker(
        markerId: MarkerId(landmark.placeId),
        position: LatLng(landmark.latitude, landmark.longitude),
        infoWindow: InfoWindow(title: landmark.name),
        onTap: () => _onMarkerTapped(landmark.placeId),
      );
    }).toSet();

    setState(() {
      markers.addAll(newMarkers);
    });
  }

  void _onMarkerTapped(String landmarkId) {
    final tappedLandmark = widget.landmarks.firstWhere(
      (landmark) => landmark.placeId == landmarkId,
    );
    _fetchRouteToLandmark(tappedLandmark);
  }

  Future<void> _fetchRouteToLandmark(Landmark landmark) async {
    if (userLocation == null) return;

    final origin = '${userLocation!.latitude},${userLocation!.longitude}';
    final destination = '${landmark.latitude},${landmark.longitude}';

    final response = await http.post(
      Uri.parse('https://fetchroutetolandmark-ceqbukz3fa-uc.a.run.app'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'origin': origin, 'destination': destination}),
    );

    final data = json.decode(response.body);

    if (data['status'] != 'OK') {
      debugPrint('Error: ${data['status']}');
      return;
    }

    final polylineString = data['routes'][0]['overview_polyline']['points'];

    final points = PolylinePoints.decodePolyline(polylineString);

    List<LatLng> polylineCoords = points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    num totalDistanceMeters = 0;
    num totalDurationSeconds = 0;

    for (var leg in data['routes'][0]['legs']) {
      totalDistanceMeters += leg['distance']['value'];
      totalDurationSeconds += leg['duration']['value'];
    }

    setState(() {
      polylines = {
        Polyline(
          polylineId: PolylineId('route_to_selected'),
          color: Colors.blue,
          width: 5,
          points: polylineCoords,
        ),
      };
      distance = '${(totalDistanceMeters / 1000).toStringAsFixed(2)} km';
      duration = '${(totalDurationSeconds ~/ 60)} mins';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Walking Tour')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation!,
              zoom: 15,
            ),
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            onMapCreated: (controller) => mapController = controller,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              color: Colors.white.withValues(alpha: .9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Estimated distance: $distance\nEstimated time: $duration',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
