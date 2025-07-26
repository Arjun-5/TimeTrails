import 'package:flutter/material.dart';
import 'package:time_trails/helpers/slanted_rhombus_clipper.dart';

class RhombusBorderPainter extends CustomPainter{
  final double cornerRadius;

  RhombusBorderPainter({this.cornerRadius = 20});

  @override void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

      final path = SlantedRhombusClipper(cornerRadius: cornerRadius).getClip(size);

      canvas.drawPath(path, borderPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}