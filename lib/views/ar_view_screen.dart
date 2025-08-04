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
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_trails/models/badge.dart';
import 'package:time_trails/models/landmark.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ArViewScreen extends StatefulWidget {
  final String modelUrl;
  final Landmark? landmark;

  const ArViewScreen({
    super.key,
    this.modelUrl =
        "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
    this.landmark,
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

  bool collected = false;
  bool get badgeMode => widget.landmark != null;// && widget.apiKey != null;
  String? get landmarkId => widget.landmark?.placeId;

  @override
  void initState() {
    super.initState();
    _checkPermissions();

    if (badgeMode && landmarkId != null) {
      BadgeStorage.hasCollected(landmarkId!).then((value) {
        setState(() => collected = value);
      });
    }
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
          if (badgeMode && !collected && isModelPlaced)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "🎯 Tap the model to collect your badge!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (collected)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '✅ You have collected the badge for "${widget.landmark?.name ?? ''}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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
    arObjectManager.onNodeTap = _onNodeTap;
  }

  Future<void> _onNodeTap(List<String> nodeNames) async {
    debugPrint('Tapped nodes: $nodeNames');
    if (collected || modelNode == null) return;
    final expectedName = widget.landmark?.placeId ?? "remoteModel";

    debugPrint('Expected node name: $expectedName');
    if (nodeNames.contains(expectedName)) {
      debugPrint('Tapped the model node!');
      await _onBadgeModelTap();
    }
  }

  Future<void> _onPlaneTap(List<ARHitTestResult> hitTestResults) async {
    if (isModelPlaced || hitTestResults.isEmpty) return;

    final hit = hitTestResults.first;

    setState(() => isLoadingSnapshot = true);

    final node = ARNode(
      name: widget.landmark?.placeId ?? "remoteModel",
      type: NodeType.webGLB,
      uri: widget.modelUrl,
      scale: Vector3(1, 1, 1),
      position: hit.worldTransform.getTranslation(),
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

  Future<void> _onBadgeModelTap() async {
    if (!badgeMode || collected || landmarkId == null) return;

    final photoUrl = await widget.landmark!.getPhotoUrl();

    final badge = Badge(
      landmarkId: landmarkId!,
      name: widget.landmark!.name,
      imageUrl: photoUrl,
      collectedAt: DateTime.now(),
    );

    await BadgeStorage.addBadge(badge);

    setState(() => collected = true);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🏅 Badge collected: ${widget.landmark!.name}')),
    );

    // Remove model from scene after collection
    if (modelNode != null) {
      await arObjectManager.removeNode(modelNode!);
      setState(() => isModelPlaced = false);
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
