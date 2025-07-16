import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Size circleSize;

  final Color color1;

  final Color color2;

  CirclePainter({
    required this.circleSize,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size _) {
    final Rect rect = Rect.fromCircle(
      center: Offset(circleSize.width / 2, circleSize.height / 2),
      radius: circleSize.width / 2,
    );

    final Gradient backgroundGradient = LinearGradient(
      colors: [color1, color2],
      stops: [0, 1],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight
    );

    //cascade operator ..
    //This lets us perform a sequence of operations on the same object without repeating the variable name.
    final cirlcePaint = Paint()
      ..shader = backgroundGradient.createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(circleSize.width / 2, circleSize.height / 2),
      circleSize.width / 2,
      cirlcePaint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}
