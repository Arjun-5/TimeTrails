import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:time_trails/models/landmark.dart';

class LandmarkService {
  final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;

  Future<List<Landmark>> fetchNearbyLandmarks(
    double currentLatitude,
    double currentLongitude,
  ) async {
    // 1. Correct URL for a POST request (no query parameters here)
    final url = Uri.parse('https://places.googleapis.com/v1/places:searchNearby');

    final headers = {
      'Content-Type': 'application/json', // Essential for sending JSON body
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': // This header specifies which fields to return in the response
          'places.displayName,places.location,places.photos,places.id',
    };

    // 2. Construct the JSON request body
    final body = json.encode({
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': currentLatitude,
            'longitude': currentLongitude,
          },
          'radius': 5000.0, // Radius in meters (must be a double)
        },
      },
      'includedTypes': ['tourist_attraction'], // Use includedTypes
      'maxResultCount': 8, // Max results
    });

    // 3. Make the POST request WITH the body
    final response = await http.post(url, headers: headers, body: body); // <-- This is the key change

    if (response.statusCode != 200) {
      debugPrint('Error response status: ${response.statusCode}');
      debugPrint('Error response body: ${response.body}');
      throw Exception('Failed to load landmarks: ${response.statusCode} - ${response.body}');
    }

    final data = json.decode(response.body);
    debugPrint('Fetched Landmarks : $data');

    // Handle case where 'places' might be null or empty if no results
    if (data['places'] == null || (data['places'] is! List) || (data['places'] as List).isEmpty) {
      debugPrint('No places found or invalid places data in response.');
      return [];
    }

    return (data['places'] as List)
        .map((json) => Landmark.fromJson(json))
        .toList();
  }
}