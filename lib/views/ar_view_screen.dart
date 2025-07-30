import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ArViewScreen extends StatefulWidget {
  const ArViewScreen({super.key});

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  ARNode? modelNode;
  bool isModelPlaced = false;
  bool isLoadingSnapshot = false;
  ImageProvider? snapshotImage;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.storage] != PermissionStatus.granted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Camera and storage permissions are required to use AR features.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkPermissions();
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Monument View"),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _takeSnapshot,
          ),
        ],
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: _onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          if (!isModelPlaced)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _placeModel,
                child: const Text("Place Monument"),
              ),
            ),
          if (isLoadingSnapshot)
            const Center(child: CircularProgressIndicator()),
          if (snapshotImage != null)
            Positioned(
              top: 80,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(child: Image(image: snapshotImage!)),
                  );
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image(image: snapshotImage!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    arSessionManager.onInitialize(
      showPlanes: true,
      handleTaps: false,
      handlePans: true,
      handleRotation: true,
    );

    arObjectManager.onInitialize();
  }

  Future<void> _placeModel() async {
    if (isModelPlaced) return;

    final node = ARNode(
      type: NodeType.webGLB,
      uri: "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
      scale: Vector3(0.2, 0.2, 0.2),
      position: Vector3(0.0, 0.0, -1.0),
      rotation: Vector4(1.0, 0.0, 0.0, 0.0),
    );

    final success = await arObjectManager.addNode(node);
    if (success == true) {
      modelNode = node;
      setState(() => isModelPlaced = true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to place model")));
    }
  }

  Future<void> _takeSnapshot() async {
    setState(() {
      isLoadingSnapshot = true;
    });

    try {
      final snapshot = await arSessionManager.snapshot();
      setState(() {
        snapshotImage = snapshot;
        isLoadingSnapshot = false;
      });
    } catch (e) {
      setState(() => isLoadingSnapshot = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Snapshot failed: $e")));
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}
