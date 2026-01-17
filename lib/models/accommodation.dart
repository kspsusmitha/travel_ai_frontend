class Accommodation {
  final String id;
  final String name;
  final String type; // 'hotel', 'airbnb', 'hostel', etc.
  final String location;
  final double? pricePerNight;
  final double? rating;
  final String? imageUrl;
  final String? description;
  final Map<String, dynamic>? amenities;

  Accommodation({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    this.pricePerNight,
    this.rating,
    this.imageUrl,
    this.description,
    this.amenities,
  });
}
