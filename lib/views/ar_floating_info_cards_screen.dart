import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class ArFloatingInfoCardsScreen extends StatefulWidget {
  const ArFloatingInfoCardsScreen({super.key});

  @override
  State<ArFloatingInfoCardsScreen> createState() =>
      _ArFloatingInfoCardsScreenState();
}

class _ArFloatingInfoCardsScreenState extends State<ArFloatingInfoCardsScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Floating Info Cards')),
      body: ARView(
        onARViewCreated: _onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
      ),
    );
  }

  void _onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
    );

    arObjectManager.onInitialize();

    _addFloatingInfoCard();
  }

  Future<void> _addFloatingInfoCard() async {
    final billboardNode = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/models/Billboard.glb",
      position: Vector3(0.0, 0.2, -1.0),
      scale: Vector3.all(1.5),
    );

    await arObjectManager.addNode(billboardNode);
  }

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }
}
