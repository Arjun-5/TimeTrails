import 'package:flutter/material.dart';

class CustomBoxClipper extends CustomClipper<Path>{
  final double cornerRadius;

  final double topSkewFactor;

  final double bottomSkewFactor;

  const CustomBoxClipper({this.cornerRadius = 20, this.topSkewFactor = 20, this.bottomSkewFactor =20});

  @override
  Path getClip(Size size) {
    double width = size.width;

    double height = size.height;

    Path customBoxPath = Path()
      ..moveTo(cornerRadius, topSkewFactor)
      ..lineTo(width - cornerRadius, 0)
      ..quadraticBezierTo(width, 0, width, cornerRadius)
      ..lineTo(width, height - cornerRadius - bottomSkewFactor)
      ..quadraticBezierTo(width, height - bottomSkewFactor,width - cornerRadius, height - bottomSkewFactor)
      ..lineTo(cornerRadius, height)
      ..quadraticBezierTo(0, height, 0, height - cornerRadius)
      ..lineTo(0, cornerRadius + topSkewFactor)
      ..quadraticBezierTo(0, topSkewFactor, cornerRadius, topSkewFactor)
      ..close();

    return customBoxPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}