import 'package:flutter/material.dart';
import 'package:time_trails/circle_widget.dart';
import 'package:time_trails/gradient_container';

class TimeTrails extends StatelessWidget {
  const TimeTrails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final height = constraints.maxHeight;

            final left = width * 0.1; // 25% from left

            final top = height * -0.1; // 50% from top

            return Stack(
              children: [
                GradientContainer(
                  color1: Color(0xFF353F54),
                  color2: Color(0xFF222834),
                  startAlignment: Alignment.topLeft,
                  endAlignment: Alignment.bottomRight,
                ),
                Positioned(
                  left: left,
                  top: top,
                  child: CircleWidget(circleSize: Size(676, 613)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
