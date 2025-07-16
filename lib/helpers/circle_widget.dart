import 'package:flutter/material.dart';
import 'package:time_trails/helpers/circle_painter.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({super.key, required this.circleSize});

  final Size circleSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: circleSize,
      painter: CirclePainter(
        circleSize: circleSize,
        color1: Color(0xFF34C8E8),
        color2: Color(0xFF4E4AF2),
      ),
    );
  }
}
