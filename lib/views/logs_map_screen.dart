import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_trails/views/add_log_screen.dart';
import 'package:time_trails/views/logs_screen.dart';

class LogsMapScreen extends StatefulWidget {
  const LogsMapScreen({super.key});

  @override
  State<LogsMapScreen> createState() => _LogsMapScreenState();
}

class _LogsMapScreenState extends State<LogsMapScreen> {
  late GoogleMapController _mapController;
  final CollectionReference logs = FirebaseFirestore.instance.collection(
    'time_trail_logs',
  );
  Set<Marker> _markers = {};
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _listenToLogs();
  }

  void _listenToLogs() {
    logs.snapshots().listen((snapshot) {
      final markers = snapshot.docs.map((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        final lat = (data['latitude'] ?? 0.0) as double;
        final lng = (data['longitude'] ?? 0.0) as double;

        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: data['placeName'] ?? 'Unknown Place',
            snippet: data['note'] ?? '',
          ),
        );
      }).toSet();

      setState(() {
        _markers = markers;
      });
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (!mounted) return;

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation!, 14),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );
    }
  }

  void _goToAddLog() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddLogScreen()),
    );
  }

  void _goToLogsList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LogsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Trail Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'View Logs List',
            onPressed: _goToLogsList,
          ),
        ],
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 14,
              ),
              onMapCreated: _onMapCreated,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddLog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
