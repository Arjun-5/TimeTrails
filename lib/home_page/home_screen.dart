import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:time_trails/helpers/circle_widget.dart';
import 'package:time_trails/helpers/gradient_container.dart';
import 'package:time_trails/widgets/slanted_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, _) {
          final size = MediaQuery.of(context).size;

          final width = size.width;

          final height = size.height;

          final double circleDiameter = width;

          return Stack(
            children: [
              SizedBox.expand(
                child: GradientContainer(
                  color1: const Color.fromARGB(255, 27, 25, 26),
                  color2: const Color.fromARGB(255, 33, 18, 37),
                  startAlignment: Alignment.topLeft,
                  endAlignment: Alignment.bottomRight,
                ),
              ),
              Positioned(
                left: width * -0.44,
                top: height * 0.7,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: CircleWidget(
                      circleSize: Size(circleDiameter, circleDiameter),
                      circleColor1: Color(0xFF09FBD3),
                      circleColor2: Color.fromARGB(255, 1, 147, 123),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlantedBox(
                      width: 200,
                      height: 300,
                      label: 'Slanted Box',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
