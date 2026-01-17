class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String type; // 'Solo' or 'Group'
  final List<String> travelers;
  final double? budget;
  final String? description;
  final String createdBy;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.travelers,
    this.budget,
    this.description,
    required this.createdBy,
    required this.createdAt,
  });

  int get duration => endDate.difference(startDate).inDays + 1;
}
