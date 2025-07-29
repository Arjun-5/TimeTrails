import 'package:flutter/material.dart';
import 'package:time_trails/helpers/custom_box_clipper.dart';

class CustomboxBorderPainter extends CustomPainter {
  final double cornerRadius;

  final double topSkewFactor;

  final double bottomSkewFactor;
  CustomboxBorderPainter({
    this.cornerRadius = 20,
    this.topSkewFactor = 20,
    this.bottomSkewFactor = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = CustomBoxClipper(
      cornerRadius: cornerRadius,
      topSkewFactor: topSkewFactor,
      bottomSkewFactor: bottomSkewFactor,
    ).getClip(size);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
