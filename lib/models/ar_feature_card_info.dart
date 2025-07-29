import 'package:flutter/material.dart';

class ArFeatureCardInfo {
  final String title;
  final String description;
  final IconData icon;
  final String featureName;
  final VoidCallback onTap;
  
  ArFeatureCardInfo({required this.title, required this.description, required this.featureName, required this.icon, required this.onTap});
}