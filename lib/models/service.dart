/// Service model for booking system
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final String category;
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    this.isActive = true,
  });
}
