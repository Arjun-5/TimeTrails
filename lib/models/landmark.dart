class Landmark {
  final String name;

  final String address;

  final double lat;

  final double long;

  final String? photoReference;

  Landmark({
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.photoReference,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    final location = json['location'];

    final photos = json['photos'] as List?;

    final photoRef = photos != null && photos.isNotEmpty
        ? photos.first['name']
        : null;

    return Landmark(
      name: json['displayName']['text'],
      address: json['formattedAddress'],
      lat: location['latitude'],
      long: location['longitude'],
      photoReference: photoRef,
    );
  }
}
