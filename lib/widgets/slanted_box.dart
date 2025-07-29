import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_trails/helpers/rhombus_border_painter.dart';
import 'package:time_trails/helpers/slanted_rhombus_clipper.dart';

class SlantedBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const SlantedBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RhombusBorderPainter(cornerRadius: 20),
      child: ClipPath(
        clipper: SlantedRhombusClipper(cornerRadius: 20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}
