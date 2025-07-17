import 'package:flutter/material.dart';
import 'package:time_trails/helpers/slanted_rhombus_clipper.dart';

class SlantedBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String label;

  const SlantedBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SlantedRhombusClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
