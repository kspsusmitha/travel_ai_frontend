class Activity {
  final String id;
  final String name;
  final String type;
  final String location;
  final double? price;
  final double? rating;
  final String? imageUrl;
  final String? description;
  final int? duration; // in minutes

  Activity({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    this.price,
    this.rating,
    this.imageUrl,
    this.description,
    this.duration,
  });
}
