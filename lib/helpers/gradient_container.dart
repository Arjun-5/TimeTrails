import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key, required this.color1, required this.color2, required this.startAlignment, required this.endAlignment});

  final Color color1;

  final Color color2;

  final Alignment startAlignment;

  final Alignment endAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
    );
  }
}
