import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DistanceMatrixService {
  final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;

  Future<String> getDistanceToLandmark({
    required double currentLatitude,
    required double currentLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    String mode = 'walking',
  }) async {
    final endPoint = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
      '?origins=$currentLatitude,$currentLongitude'
      '&destinations=$destinationLatitude,$destinationLongitude'
      '&mode=$mode'
      '&key=$_apiKey',
    );

    final response = await http.get(endPoint);

    final data = json.decode(response.body);

    return data['rows'][0]['elements'][0]['distance']['text'];
  }
}
