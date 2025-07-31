import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Badge {
  final String landmarkId;
  final String name;
  final String imageUrl;
  final DateTime collectedAt;

  Badge({
    required this.landmarkId,
    required this.name,
    required this.imageUrl,
    required this.collectedAt,
  });

  Map<String, dynamic> toJson() => {
    'landmarkId': landmarkId,
    'name': name,
    'imageUrl': imageUrl,
    'collectedAt': collectedAt.toIso8601String(),
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    landmarkId: json['landmarkId'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    collectedAt: DateTime.parse(json['collectedAt']),
  );
}

class BadgeStorage {
  static const _key = 'collected_badges';

  static Future<List<Badge>> getBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Badge.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addBadge(Badge badge) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBadges();
    if (current.any((b) => b.landmarkId == badge.landmarkId)) return;
    current.add(badge);
    await prefs.setStringList(_key, current.map((b) => jsonEncode(b.toJson())).toList());
  }

  static Future<bool> hasCollected(String landmarkId) async {
    final badges = await getBadges();
    return badges.any((b) => b.landmarkId == landmarkId);
  }
}
