import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_trails/firebase_options.dart';
import 'package:time_trails/landing_page/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const LandingPage());
}
