class Location {
  String name;
  String country;
  double lat;
  double lon;

  Location({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json['name'] ?? 'N/A',
        country: json['country'] ?? 'N/A',
        lat: json['latitude']?.toDouble(),
        lon: json['longitude']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'latitude': lat,
        'longitude': lon,
      };
}
