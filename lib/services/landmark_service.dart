import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time_trails/models/landmark.dart';

class LandmarkService {
  final String _functionUrl =
      'https://fetchnearbylandmarks-ceqbukz3fa-uc.a.run.app';

  Future<List<Landmark>> fetchNearbyLandmarks(
    double currentLatitude,
    double currentLongitude,
  ) async {
    final url = Uri.parse(_functionUrl);

    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'latitude': currentLatitude,
      'longitude': currentLongitude,
      'radius': 5000.0,
      'maxResultCount': 8,
      'includedTypes': ['tourist_attraction'],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      debugPrint('Error response status: ${response.statusCode}');
      debugPrint('Error response body: ${response.body}');
      throw Exception(
        'Failed to load landmarks: ${response.statusCode} - ${response.body}',
      );
    }

    final data = json.decode(response.body);
    debugPrint('Fetched Landmarks : $data');

    if (data['places'] == null ||
        (data['places'] is! List) ||
        (data['places'] as List).isEmpty) {
      debugPrint('No places found or invalid places data in response.');
      return [];
    }

    return (data['places'] as List)
        .map((json) => Landmark.fromJson(json))
        .toList();
  }
}