import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class SlideService {
  Future<List<String>> fetchSlides() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('slides')
          .doc('intro')
          .get();

      final data = doc.data();

      if (data != null && data['messages'] is List) {
        return List<String>.from(data['messages']);
      }
    } catch (e) {
      developer.log('Error fetching slides from Firestore : $e');
    }
    return [
      'Step into the past, one location at a time',
      'Explore hidden heritage with AR',
      'Walk where history happened',
      'Scan. Discover. Remember.',
      'Bringing stories to life through your screen',
    ];
  }
}
