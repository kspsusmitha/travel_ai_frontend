/// Guest booking model
class GuestBooking {
  final String id;
  final String referenceId;
  final String guestName;
  final String phoneNumber;
  final String serviceId;
  final String serviceName;
  final DateTime bookingDate;
  final DateTime bookingTime;
  final String status; // pending, confirmed, cancelled
  final double totalAmount;
  final DateTime createdAt;

  GuestBooking({
    required this.id,
    required this.referenceId,
    required this.guestName,
    required this.phoneNumber,
    required this.serviceId,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    this.status = 'pending',
    required this.totalAmount,
    required this.createdAt,
  });
}
