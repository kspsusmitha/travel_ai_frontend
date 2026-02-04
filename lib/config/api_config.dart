import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  // Authentication
  static String get register => '$baseUrl/auth/register/';
  static String get login => '$baseUrl/auth/login/';
  // Travel Activities
  static String get activities => '$baseUrl/activities/';
  static String activityDetail(int id) => '$baseUrl/activities/$id/';
  // Accommodations
  static String get accommodations => '$baseUrl/accommodations/';
  static String accommodationDetail(int id) => '$baseUrl/accommodations/$id/';
  // Travel Routes
  static String get routes => '$baseUrl/routes/';
  static String routeDetail(int id) => '$baseUrl/routes/$id/';
  // Bookings
  static String get bookings => '$baseUrl/bookings/';
  static String bookingDetail(int id) => '$baseUrl/bookings/$id/';
  // Booking Sub-resources
  static String get bookingAccommodations =>
      '$baseUrl/bookings/accommodations/';
  static String bookingAccommodationDetail(int id) =>
      '$baseUrl/bookings/accommodations/$id/';
  static String get bookingActivities => '$baseUrl/bookings/activities/';
  static String bookingActivityDetail(int id) =>
      '$baseUrl/bookings/activities/$id/';
  static String get bookingRoutes => '$baseUrl/bookings/routes/';
  static String bookingRouteDetail(int id) => '$baseUrl/bookings/routes/$id/';
  // AI Communication
  static String get aiCommunication => '$baseUrl/api_communication/';

  // User Profile (Assumed endpoint for profile management)
  static String get profile => '$baseUrl/auth/profile/';
}

// Request Body Constants
class ApiConstants {
  // AI Communication
  static const String paramLatitude = 'latitude';
  static const String paramLongitude = 'longitude';
  static const String paramPrompt = 'prompt';
  // Filters
  static const String paramSearch = 'search';
  static const String paramMinCost = 'min_cost';
  static const String paramMaxCost = 'max_cost';
  static const String paramLat = 'lat';
  static const String paramLng = 'lng';
  static const String paramRadius = 'radius';
  // Booking Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  // Payment Status
  static const String paymentUnpaid = 'unpaid';
  static const String paymentPaid = 'paid';
  static const String paymentRefunded = 'refunded';
}
