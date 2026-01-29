class TravelActivity {
  final int id;
  final String name;
  final String description;
  final String location;
  final DateTime? startTime;
  final DateTime? endTime;
  final double cost;
  final double? latitude;
  final double? longitude;

  TravelActivity({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.startTime,
    this.endTime,
    required this.cost,
    this.latitude,
    this.longitude,
  });

  factory TravelActivity.fromJson(Map<String, dynamic> json) {
    return TravelActivity(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      cost: (json['cost'] as num).toDouble(),
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'cost': cost,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
