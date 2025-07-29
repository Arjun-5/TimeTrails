import 'package:flutter/material.dart';
import 'package:time_trails/helpers/custom_box_clipper.dart';

class CustomboxBorderPainter extends CustomPainter{
  final double cornerRadius;
  final double skewFactor;
  CustomboxBorderPainter({this.cornerRadius = 20, this.skewFactor = 20});

  @override void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

      final path = CustomBoxClipper(cornerRadius: cornerRadius, skewFactor: skewFactor).getClip(size);

      canvas.drawPath(path, borderPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}