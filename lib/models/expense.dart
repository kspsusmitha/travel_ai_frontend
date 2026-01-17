class Expense {
  final String id;
  final String tripId;
  final String category;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> sharedWith;
  final DateTime date;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.tripId,
    required this.category,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.sharedWith,
    required this.date,
    required this.createdAt,
  });
}
