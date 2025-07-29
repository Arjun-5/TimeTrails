import 'package:flutter/material.dart';

class CustomBoxClipper extends CustomClipper<Path>{
  final double cornerRadius;

  final double skewFactor;

  const CustomBoxClipper({this.cornerRadius = 20, this.skewFactor = 0});

  @override
  Path getClip(Size size) {
    double width = size.width;

    double height = size.height;

    Path customBoxPath = Path()
      ..moveTo(cornerRadius, skewFactor)
      ..lineTo(width - cornerRadius, 0)
      ..quadraticBezierTo(width, 0, width, cornerRadius)
      ..lineTo(width, height - cornerRadius - skewFactor)
      ..quadraticBezierTo(width, height - skewFactor,width - cornerRadius, height - skewFactor)
      ..lineTo(cornerRadius, height)
      ..quadraticBezierTo(0, height, 0, height - cornerRadius)
      ..lineTo(0, cornerRadius + skewFactor)
      ..quadraticBezierTo(0, skewFactor, cornerRadius, skewFactor)
      ..close();

    return customBoxPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}