import 'dart:ui';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ArViewScreen extends StatefulWidget {
  final String modelUrl;
  const ArViewScreen({
    super.key,
    this.modelUrl =
        "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
  });

  @override
  State<ArViewScreen> createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  final GlobalKey _repaintKey = GlobalKey();

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
    final statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.manageExternalStorage,
    ].request();

    final allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        await openAppSettings();
      } else {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'Camera and storage permissions are required to use AR features.',
        ),
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
          RepaintBoundary(
            key: _repaintKey,
            child: ARView(
              onARViewCreated: _onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontal,
            ),
          ),
          if (!isModelPlaced)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tap on a detected plane to place the model',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
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
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
    );

    arSessionManager.onPlaneOrPointTap = _onPlaneTap;

    arObjectManager.onInitialize();
  }

  Future<void> _onPlaneTap(List<ARHitTestResult> hitTestResults) async {
    if (isModelPlaced || hitTestResults.isEmpty) return;

    final hit = hitTestResults.first;

    setState(() => isLoadingSnapshot = true);

    final node = ARNode(
      type: NodeType.webGLB,
      uri: widget.modelUrl,
      scale: Vector3(5, 5, 5),
      position: hit.worldTransform.getTranslation(),
      rotation: Vector4(0.0, 1.0, 0.0, 3.14),
    );

    final bool? success = await arObjectManager.addNode(node);
    setState(() => isLoadingSnapshot = false);

    if (success == true) {
      modelNode = node;
      setState(() => isModelPlaced = true);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Model placed")));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to place model")));
      }
    }
  }

  Future<void> _takeSnapshot() async {
    setState(() => isLoadingSnapshot = true);

    try {
      RenderRepaintBoundary boundary =
          _repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(pngBytes);
      debugPrint("Saved image result: $result");

      if (!mounted) return;
      setState(() {
        snapshotImage = MemoryImage(pngBytes);
        isLoadingSnapshot = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Snapshot saved to gallery")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoadingSnapshot = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Snapshot failed: $e")));
      }
    }
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}
