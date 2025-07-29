import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_trails/helpers/custombox_border_painter.dart';
import 'package:time_trails/helpers/custom_box_clipper.dart';

class CustomBox extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double skewFactor;

  const CustomBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    required this.skewFactor
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomboxBorderPainter(cornerRadius: 20),
      child: ClipPath(
        clipper: CustomBoxClipper(cornerRadius: 20, skewFactor: skewFactor),
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
