import 'package:flutter/material.dart';

class StylizedText extends StatelessWidget {
  final String outputText;
  final double? textSize;
  final TextAlign textAlignment;
  final TextStyle? textStyle;

  const StylizedText(
    this.outputText, {
    super.key,
    required this.textAlignment,
    this.textSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      outputText,
      textAlign: textAlignment,
      style:
          (textStyle) ??
          TextStyle(
            color: const Color.fromARGB(255, 237, 237, 237),
            fontSize: textSize,
          ),
    );
  }
}
