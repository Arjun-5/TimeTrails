import 'package:flutter/material.dart';
import 'package:time_trails/helpers/circle_painter.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({super.key, required this.circleSize, required this.circleColor1, required this.circleColor2});

  final Color circleColor1;

  final Color circleColor2;

  final Size circleSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: circleSize,
      painter: CirclePainter(
        circleSize: circleSize,
        color1: circleColor1,
        color2: circleColor2,
      ),
    );
  }
}
