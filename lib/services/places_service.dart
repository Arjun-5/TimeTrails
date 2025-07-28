import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:time_trails/models/landmark.dart';

class PlacesService {
  final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;

  Future<List<Landmark>> fetchNearbyLandmarks(
    double latitude,
    double longitude,
  ) async {
    final url =
        'https://places.googleapis.com/v1/places:searchNearby?key=$_apiKey';

    final messagedBody = {
      "includedTypes": ["tourist_attraction", "point_of_interest"],
      "locationRestriction": {
        "circle": {
          "center": {"latitude": latitude, "longitude": longitude},
          "radius": 5000, // meters
        },
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask':
            'places.displayName,places.photos,places.location,places.id',
      },
      body: jsonEncode(messagedBody),
    );

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);

      final List<dynamic> places = data['places'];
    }
  }
}
