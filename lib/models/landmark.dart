class Landmark {
  final String name;
  final double latitude;
  final double longitude;
  final String photoRef;
  final String id;

  Landmark({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.photoRef,
    required this.id,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      name: json['displayName']['text'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      photoRef: json['photos']?[0]['name'] ?? '',
      id: json['id'],
    );
  }

  String photoUrl(String apiKey) =>
      'https://places.googleapis.com/v1/$photoRef/media?maxHeightPx=400&key=$apiKey';
}
