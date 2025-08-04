import 'dart:convert';
import 'package:http/http.dart' as http;

class DistanceMatrixService {
  Future<String> calculateDistanceToLandmark({
    required double currentLatitude,
    required double currentLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    String mode = 'walking',
  }) async {
    final response = await http.post(
      Uri.parse('https://fetchdistancetolandmark-ceqbukz3fa-uc.a.run.app'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'currentLatitude': currentLatitude,
        'currentLongitude': currentLongitude,
        'destinationLatitude': destinationLatitude,
        'destinationLongitude': destinationLongitude,
        'mode': mode,
      }),
    );

    final data = json.decode(response.body);

    return data['rows'][0]['elements'][0]['distance']['text'];
  }
}
