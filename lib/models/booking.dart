enum BookingStatus {
  pending,
  confirmed,
  cancelled,
}

enum PaymentStatus {
  unpaid,
  paid,
  refunded,
}

extension BookingStatusExtension on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

extension PaymentStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.unpaid:
        return 'unpaid';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'unpaid':
        return PaymentStatus.unpaid;
      case 'paid':
        return PaymentStatus.paid;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.unpaid;
    }
  }
}

class Booking {
  final int id;
  final int? userId;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double totalCost;
  final List<BookingActivity>? bookedActivities;
  final List<BookingRoute>? bookedRoutes;
  final List<BookingAccommodation>? bookedAccommodations;

  Booking({
    required this.id,
    this.userId,
    required this.status,
    required this.paymentStatus,
    required this.totalCost,
    this.bookedActivities,
    this.bookedRoutes,
    this.bookedAccommodations,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      userId: json['user'] as int?,
      status: BookingStatusExtension.fromString(
        json['status'] as String,
      ),
      paymentStatus: PaymentStatusExtension.fromString(
        json['payment_status'] as String,
      ),
      totalCost: (json['total_cost'] as num).toDouble(),
      bookedActivities: json['booked_activities'] != null
          ? (json['booked_activities'] as List)
              .map((e) => BookingActivity.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      bookedRoutes: json['booked_routes'] != null
          ? (json['booked_routes'] as List)
              .map((e) => BookingRoute.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      bookedAccommodations: json['booked_accommodations'] != null
          ? (json['booked_accommodations'] as List)
              .map((e) =>
                  BookingAccommodation.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'status': status.value,
      'payment_status': paymentStatus.value,
      'total_cost': totalCost,
      'booked_activities': bookedActivities?.map((e) => e.toJson()).toList(),
      'booked_routes': bookedRoutes?.map((e) => e.toJson()).toList(),
      'booked_accommodations':
          bookedAccommodations?.map((e) => e.toJson()).toList(),
    };
  }
}

class BookingActivity {
  final int id;
  final int bookingId;
  final int activityId;

  BookingActivity({
    required this.id,
    required this.bookingId,
    required this.activityId,
  });

  factory BookingActivity.fromJson(Map<String, dynamic> json) {
    return BookingActivity(
      id: json['id'] as int,
      bookingId: json['booking'] as int,
      activityId: json['activity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking': bookingId,
      'activity': activityId,
    };
  }
}

class BookingRoute {
  final int id;
  final int bookingId;
  final int routeId;

  BookingRoute({
    required this.id,
    required this.bookingId,
    required this.routeId,
  });

  factory BookingRoute.fromJson(Map<String, dynamic> json) {
    return BookingRoute(
      id: json['id'] as int,
      bookingId: json['booking'] as int,
      routeId: json['route'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking': bookingId,
      'route': routeId,
    };
  }
}

class BookingAccommodation {
  final int id;
  final int bookingId;
  final int accommodationId;

  BookingAccommodation({
    required this.id,
    required this.bookingId,
    required this.accommodationId,
  });

  factory BookingAccommodation.fromJson(Map<String, dynamic> json) {
    return BookingAccommodation(
      id: json['id'] as int,
      bookingId: json['booking'] as int,
      accommodationId: json['accommodation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking': bookingId,
      'accommodation': accommodationId,
    };
  }
}
