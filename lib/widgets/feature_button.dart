import 'package:flutter/material.dart';
import 'package:time_trails/models/feature.dart';
import 'package:time_trails/widgets/custom_box.dart';

class FeatureButton extends StatelessWidget {
  final Feature feature;

  const FeatureButton({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      width: 50,
      height: 40,
      cornerRadius: 20,
      topSkewFactor: 0,
      bottomSkewFactor: 0,
      child: InkWell(
        onTap: () => feature.onTap,
        child: Icon(feature.icon, color: Colors.white),
      ),
    );
  }
}
