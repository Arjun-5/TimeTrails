import 'package:flutter/material.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/widgets/custom_box.dart';

class FeatureButton extends StatelessWidget {
  final Feature feature;
  final double width;

  const FeatureButton({super.key, required this.feature, required this.width});

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      width: width * 0.125,
      height: width * 0.4,
      cornerRadius: 20,
      topSkewFactor: 0,
      bottomSkewFactor: 0,
      child: InkWell(
        onTap: () {
          feature.onTap();
        },
        child: Icon(feature.icon, color: Colors.white),
      ),
    );
  }
}
