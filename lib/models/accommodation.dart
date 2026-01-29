enum AccommodationCategory {
  premium,
  budgeted,
}

extension AccommodationCategoryExtension on AccommodationCategory {
  String get value {
    switch (this) {
      case AccommodationCategory.premium:
        return 'premium';
      case AccommodationCategory.budgeted:
        return 'budgeted';
    }
  }

  static AccommodationCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'premium':
        return AccommodationCategory.premium;
      case 'budgeted':
        return AccommodationCategory.budgeted;
      default:
        return AccommodationCategory.budgeted;
    }
  }
}

class Accommodation {
  final int id;
  final String name;
  final String description;
  final String location;
  final AccommodationCategory category;
  final String checkIn;
  final String checkOut;
  final double cost;
  final double? latitude;
  final double? longitude;

  Accommodation({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.checkIn,
    required this.checkOut,
    required this.cost,
    this.latitude,
    this.longitude,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: AccommodationCategoryExtension.fromString(
        json['category'] as String,
      ),
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String,
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
      'category': category.value,
      'check_in': checkIn,
      'check_out': checkOut,
      'cost': cost,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
