import 'package:flutter/material.dart';

class SlantedRhombusClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double topSlant = 20;

    double bottomSlant = 20;

    Path rhombusPath = Path();

    rhombusPath.moveTo(0, topSlant);
    rhombusPath.lineTo(size.width, 0);
    rhombusPath.lineTo(size.width, size.height -bottomSlant);
    rhombusPath.lineTo(0, size.height);
    rhombusPath.close();

    return rhombusPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}