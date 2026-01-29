enum TravelMode {
  flight,
  train,
  bus,
  car,
  walking,
}

extension TravelModeExtension on TravelMode {
  String get value {
    switch (this) {
      case TravelMode.flight:
        return 'flight';
      case TravelMode.train:
        return 'train';
      case TravelMode.bus:
        return 'bus';
      case TravelMode.car:
        return 'car';
      case TravelMode.walking:
        return 'walking';
    }
  }

  static TravelMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'flight':
        return TravelMode.flight;
      case 'train':
        return TravelMode.train;
      case 'bus':
        return TravelMode.bus;
      case 'car':
        return TravelMode.car;
      case 'walking':
        return TravelMode.walking;
      default:
        return TravelMode.car;
    }
  }
}

class TravelRoute {
  final int id;
  final String name;
  final TravelMode travelMode;
  final String description;
  final String startLocation;
  final String endLocation;
  final double cost;

  TravelRoute({
    required this.id,
    required this.name,
    required this.travelMode,
    required this.description,
    required this.startLocation,
    required this.endLocation,
    required this.cost,
  });

  factory TravelRoute.fromJson(Map<String, dynamic> json) {
    return TravelRoute(
      id: json['id'] as int,
      name: json['name'] as String,
      travelMode: TravelModeExtension.fromString(
        json['travel_mode'] as String,
      ),
      description: json['description'] as String,
      startLocation: json['start_location'] as String,
      endLocation: json['end_location'] as String,
      cost: (json['cost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'travel_mode': travelMode.value,
      'description': description,
      'start_location': startLocation,
      'end_location': endLocation,
      'cost': cost,
    };
  }
}
