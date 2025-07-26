import 'package:flutter/material.dart';

class SlantedRhombusClipper extends CustomClipper<Path>{
  final double cornerRadius;

  const SlantedRhombusClipper({this.cornerRadius = 20});

  @override
  Path getClip(Size size) {
    double width = size.width;

    double height = size.height;

    double factor = 20;

    Path rhombusPath = Path()
      ..moveTo(cornerRadius, factor)
      ..lineTo(width - cornerRadius, 0)
      ..quadraticBezierTo(width, 0, width, cornerRadius)
      ..lineTo(width, height - cornerRadius - factor)
      ..quadraticBezierTo(width, height - factor,width - cornerRadius, height - factor)
      ..lineTo(cornerRadius, height)
      ..quadraticBezierTo(0, height, 0, height - cornerRadius)
      ..lineTo(0, cornerRadius + factor)
      ..quadraticBezierTo(0, factor, cornerRadius, factor)
      ..close();

    return rhombusPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}