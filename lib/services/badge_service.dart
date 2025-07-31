import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_trails/models/badge_info.dart';

class BadgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BadgeInfo?> getBadgeForLandmark(String placeId) async {
    try {
      final doc = await _firestore
          .collection('landmarkBadges')
          .doc(placeId)
          .get();
      if (doc.exists) {
        return BadgeInfo.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error fetching badge info: $e');
    }
    return null;
  }
}
