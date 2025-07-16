import 'package:flutter/material.dart';
import 'package:time_trails/helpers/gradient_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        color1: const Color(0xFF353F54),
        color2: const Color(0xFF222834),
        startAlignment: Alignment.topLeft,
        endAlignment: Alignment.bottomRight,
      ),
    );
  }
}
