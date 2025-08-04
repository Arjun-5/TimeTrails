import 'dart:convert';

import 'package:http/http.dart' as http;

class Landmark {
  final String name;
  final double latitude;
  final double longitude;
  final String photoRef;
  final String placeId;

  Landmark({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.photoRef,
    required this.placeId,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      name: json['displayName']['text'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      photoRef: json['photos']?[0]['name'] ?? '',
      placeId: json['id'],
    );
  }

  Future<String> getPhotoUrl() async {
    final response = await http.post(
      Uri.parse(
        'https://getphotourl-ceqbukz3fa-uc.a.run.app',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'photoReference': photoRef}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to fetch photo URL: ${response.body}');
    }
  }
}
