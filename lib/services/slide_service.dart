import 'package:cloud_firestore/cloud_firestore.dart';

class SlideService {
  static final List<String> fallbackSlides = [
    'Step into the past, one location at a time',
    'Explore hidden heritage with AR',
    'Walk where history happened',
    'Scan. Discover. Remember.',
    'Bringing stories to life through your screen',
  ];
  static Future<List<String>> fetchSlides() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('slides')
          .doc('intro')
          .get();
      final data = doc.data();

      if (data != null && data['messages'] is List) {
        return List<String>.from(data['messages']);
      } else {
        return fallbackSlides;
      }
    } catch (e) {
      return fallbackSlides;
    }
  }
}
