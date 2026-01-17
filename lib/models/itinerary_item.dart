class ItineraryItem {
  final String id;
  final String tripId;
  final DateTime date;
  final String title;
  final String? description;
  final String type; // 'landmark', 'food', 'activity', 'accommodation'
  final String? location;
  final String? time;
  final int? estimatedDuration; // in minutes
  final double? cost;
  final int order;

  ItineraryItem({
    required this.id,
    required this.tripId,
    required this.date,
    required this.title,
    this.description,
    required this.type,
    this.location,
    this.time,
    this.estimatedDuration,
    this.cost,
    required this.order,
  });
}
