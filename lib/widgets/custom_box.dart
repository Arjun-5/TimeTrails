import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_trails/helpers/custombox_border_painter.dart';
import 'package:time_trails/helpers/custom_box_clipper.dart';

class CustomBox extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final double topSkewFactor;
  final double bottomSkewFactor;
  final VoidCallback? onTap;
  final Widget child;

  const CustomBox({
    super.key,
    required this.width,
    required this.height,
    required this.cornerRadius,
    required this.topSkewFactor,
    required this.bottomSkewFactor,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomboxBorderPainter(
        cornerRadius: cornerRadius,
        topSkewFactor: topSkewFactor,
        bottomSkewFactor: bottomSkewFactor,
      ),
      child: ClipPath(
        clipper: CustomBoxClipper(
          cornerRadius: cornerRadius,
          topSkewFactor: topSkewFactor,
          bottomSkewFactor: bottomSkewFactor,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Container(
                width: width,
                height: height,
                padding: const EdgeInsets.all(12),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
