import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/travel_activity.dart';
import '../models/accommodation.dart';
import '../models/travel_route.dart';
import '../models/booking.dart';
import '../models/ai_response.dart';
import 'auth_service.dart';
import '../config/api_config.dart';

class ApiService {
  // Helper method to get headers
  static Future<Map<String, String>> _getHeaders({
    bool authRequired = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (authRequired) {
      final token = await AuthService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Token $token';
      }
    }

    return headers;
  }

  // Helper method to handle API responses
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      try {
        return json.decode(response.body);
      } catch (e) {
        debugPrint('❌ API Error - Failed to parse response: $e');
        debugPrint('Response body: ${response.body}');
        throw Exception('Failed to parse response: $e');
      }
    } else {
      String errorMessage = 'Failed to load data: ${response.statusCode}';
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map<String, dynamic>) {
          // Try to extract error message from common error formats
          if (errorData.containsKey('error')) {
            errorMessage = errorData['error'].toString();
          } else if (errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          } else if (errorData.containsKey('detail')) {
            errorMessage = errorData['detail'].toString();
          } else if (errorData.containsKey('non_field_errors')) {
            errorMessage = (errorData['non_field_errors'] as List).join(', ');
          }
        }
      } catch (_) {
        // If parsing fails, use the raw body
        if (response.body.isNotEmpty) {
          errorMessage = '${response.statusCode}: ${response.body}';
        }
      }
      debugPrint('❌ API Error - Status: ${response.statusCode}');
      debugPrint('❌ API Error - URL: ${response.request?.url}');
      debugPrint('❌ API Error - Message: $errorMessage');
      debugPrint('❌ API Error - Response body: ${response.body}');
      throw Exception(errorMessage);
    }
  }

  // Authentication APIs
  static Future<AuthResponse> register({
    required String username,
    required String password,
    String? email,
    String? firstName,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.register);
      final body = <String, dynamic>{
        'username': username,
        'password': password,
      };

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      if (firstName != null && firstName.isNotEmpty) {
        body['first_name'] = firstName;
      }

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');
      debugPrint('📤 Headers: ${await _getHeaders()}');

      final response = await http
          .post(url, headers: await _getHeaders(), body: json.encode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              debugPrint('❌ Request Timeout - Register');
              throw Exception(
                'Request timeout. Please check if the server is running.',
              );
            },
          );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return AuthResponse.fromJson(data);
    } catch (e) {
      debugPrint('❌ Network Error - Register: $e');
      debugPrint('❌ Error Type: ${e.runtimeType}');
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        debugPrint(
          '💡 Tip: Make sure your Django server is running on port 8000',
        );
        debugPrint('💡 Tip: For Android emulator, ensure server is accessible');
        debugPrint(
          '💡 Tip: Run Django with: python manage.py runserver 0.0.0.0:8000',
        );
        debugPrint('💡 Tip: Check if URL is correct: ${ApiConfig.register}');
      }
      rethrow;
    }
  }

  static Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.login);
      final body = {'username': username, 'password': password};

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return AuthResponse.fromJson(data);
    } catch (e) {
      debugPrint('❌ Network Error - Login: $e');
      rethrow;
    }
  }

  // Activities APIs
  static Future<List<TravelActivity>> getActivities({
    String? search,
    double? minCost,
    double? maxCost,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.activities).replace(
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (minCost != null) 'min_cost': minCost.toString(),
          if (maxCost != null) 'max_cost': maxCost.toString(),
          if (lat != null) 'lat': lat.toString(),
          if (lng != null) 'lng': lng.toString(),
          if (radius != null) 'radius': radius.toString(),
        },
      );

      debugPrint('📤 API Request - GET $url');

      final response = await http.get(url, headers: await _getHeaders());

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      if (data is List) {
        return data
            .map((e) => TravelActivity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Network Error - Get Activities: $e');
      rethrow;
    }
  }

  static Future<TravelActivity> getActivity(int id) async {
    final url = Uri.parse(ApiConfig.activityDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return TravelActivity.fromJson(data as Map<String, dynamic>);
  }

  static Future<TravelActivity> createActivity({
    required String name,
    required String description,
    required double cost,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.activities);
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'cost': cost,
        'latitude': latitude,
        'longitude': longitude,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return TravelActivity.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Activity: $e');
      rethrow;
    }
  }

  static Future<TravelActivity> updateActivity({
    required int id,
    String? name,
    String? description,
    double? cost,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.activityDetail(id));
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (cost != null) body['cost'] = cost;
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;
      if (imageUrl != null) body['image_url'] = imageUrl;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return TravelActivity.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Activity: $e');
      rethrow;
    }
  }

  static Future<void> deleteActivity(int id) async {
    try {
      final url = Uri.parse(ApiConfig.activityDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Activity: $e');
      rethrow;
    }
  }

  // Accommodations APIs
  static Future<List<Accommodation>> getAccommodations({
    String? search,
    double? minCost,
    double? maxCost,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.accommodations).replace(
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (minCost != null) 'min_cost': minCost.toString(),
          if (maxCost != null) 'max_cost': maxCost.toString(),
          if (lat != null) 'lat': lat.toString(),
          if (lng != null) 'lng': lng.toString(),
          if (radius != null) 'radius': radius.toString(),
        },
      );

      debugPrint('📤 API Request - GET $url');

      final response = await http.get(url, headers: await _getHeaders());

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      if (data is List) {
        return data
            .map((e) => Accommodation.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Network Error - Get Accommodations: $e');
      rethrow;
    }
  }

  static Future<Accommodation> getAccommodation(int id) async {
    final url = Uri.parse(ApiConfig.accommodationDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return Accommodation.fromJson(data as Map<String, dynamic>);
  }

  static Future<Accommodation> createAccommodation({
    required String name,
    required String description,
    required double costPerNight,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.accommodations);
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'cost_per_night': costPerNight,
        'latitude': latitude,
        'longitude': longitude,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return Accommodation.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Accommodation: $e');
      rethrow;
    }
  }

  static Future<Accommodation> updateAccommodation({
    required int id,
    String? name,
    String? description,
    double? costPerNight,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.accommodationDetail(id));
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (costPerNight != null) body['cost_per_night'] = costPerNight;
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;
      if (imageUrl != null) body['image_url'] = imageUrl;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return Accommodation.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Accommodation: $e');
      rethrow;
    }
  }

  static Future<void> deleteAccommodation(int id) async {
    try {
      final url = Uri.parse(ApiConfig.accommodationDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Accommodation: $e');
      rethrow;
    }
  }

  // Routes APIs
  static Future<List<TravelRoute>> getRoutes({
    String? search,
    double? minCost,
    double? maxCost,
    double? lat,
    double? lng,
    double? radius,
  }) async {
    final url = Uri.parse(ApiConfig.routes).replace(
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (minCost != null) 'min_cost': minCost.toString(),
        if (maxCost != null) 'max_cost': maxCost.toString(),
        if (lat != null) 'lat': lat.toString(),
        if (lng != null) 'lng': lng.toString(),
        if (radius != null) 'radius': radius.toString(),
      },
    );

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    if (data is List) {
      return data
          .map((e) => TravelRoute.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<TravelRoute> getRoute(int id) async {
    final url = Uri.parse(ApiConfig.routeDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return TravelRoute.fromJson(data as Map<String, dynamic>);
  }

  static Future<TravelRoute> createRoute({
    required String name,
    required String description,
    required double cost,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.routes);
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'cost': cost,
        'start_latitude': startLatitude,
        'start_longitude': startLongitude,
        'end_latitude': endLatitude,
        'end_longitude': endLongitude,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return TravelRoute.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Route: $e');
      rethrow;
    }
  }

  static Future<TravelRoute> updateRoute({
    required int id,
    String? name,
    String? description,
    double? cost,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.routeDetail(id));
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (cost != null) body['cost'] = cost;
      if (startLatitude != null) body['start_latitude'] = startLatitude;
      if (startLongitude != null) body['start_longitude'] = startLongitude;
      if (endLatitude != null) body['end_latitude'] = endLatitude;
      if (endLongitude != null) body['end_longitude'] = endLongitude;
      if (imageUrl != null) body['image_url'] = imageUrl;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return TravelRoute.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Route: $e');
      rethrow;
    }
  }

  static Future<void> deleteRoute(int id) async {
    try {
      final url = Uri.parse(ApiConfig.routeDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Route: $e');
      rethrow;
    }
  }

  // Bookings APIs
  static Future<List<Booking>> getBookings({
    String? status,
    String? paymentStatus,
  }) async {
    final url = Uri.parse(ApiConfig.bookings).replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
        if (paymentStatus != null && paymentStatus.isNotEmpty)
          'payment_status': paymentStatus,
      },
    );

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    if (data is List) {
      return data
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<Booking> getBooking(int id) async {
    final url = Uri.parse(ApiConfig.bookingDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return Booking.fromJson(data as Map<String, dynamic>);
  }

  static Future<Booking> createBooking({
    int? userId,
    List<int>? activityIds,
    List<int>? routeIds,
    List<int>? accommodationIds,
    String? status,
    String? paymentStatus,
  }) async {
    final url = Uri.parse(ApiConfig.bookings);
    final body = <String, dynamic>{};

    if (userId != null) body['user_id'] = userId;
    if (activityIds != null && activityIds.isNotEmpty) {
      body['activity_ids'] = activityIds;
    }
    if (routeIds != null && routeIds.isNotEmpty) {
      body['route_ids'] = routeIds;
    }
    if (accommodationIds != null && accommodationIds.isNotEmpty) {
      body['accommodation_ids'] = accommodationIds;
    }
    if (status != null && status.isNotEmpty) body['status'] = status;
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      body['payment_status'] = paymentStatus;
    }

    final response = await http.post(
      url,
      headers: await _getHeaders(authRequired: true),
      body: json.encode(body),
    );

    final data = _handleResponse(response);
    return Booking.fromJson(data as Map<String, dynamic>);
  }

  static Future<Booking> updateBooking({
    required int id,
    String? status,
    String? paymentStatus,
    List<int>? activityIds,
    List<int>? routeIds,
    List<int>? accommodationIds,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingDetail(id));
      final body = <String, dynamic>{};

      if (status != null && status.isNotEmpty) body['status'] = status;
      if (paymentStatus != null && paymentStatus.isNotEmpty) {
        body['payment_status'] = paymentStatus;
      }
      if (activityIds != null && activityIds.isNotEmpty) {
        body['activity_ids'] = activityIds;
      }
      if (routeIds != null && routeIds.isNotEmpty) {
        body['route_ids'] = routeIds;
      }
      if (accommodationIds != null && accommodationIds.isNotEmpty) {
        body['accommodation_ids'] = accommodationIds;
      }

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return Booking.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Booking: $e');
      rethrow;
    }
  }

  static Future<void> deleteBooking(int id) async {
    try {
      final url = Uri.parse(ApiConfig.bookingDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Booking: $e');
      rethrow;
    }
  }

  // Booking Accommodations APIs
  static Future<List<BookingAccommodation>> getBookingAccommodations({
    int? bookingId,
  }) async {
    final url = Uri.parse(ApiConfig.bookingAccommodations).replace(
      queryParameters: {
        if (bookingId != null) 'booking_id': bookingId.toString(),
      },
    );

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    if (data is List) {
      return data
          .map((e) => BookingAccommodation.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<BookingAccommodation> getBookingAccommodation(int id) async {
    final url = Uri.parse(ApiConfig.bookingAccommodationDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingAccommodation.fromJson(data as Map<String, dynamic>);
  }

  static Future<BookingAccommodation> createBookingAccommodation({
    required int bookingId,
    required int accommodationId,
    String? checkInDate,
    String? checkOutDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingAccommodations);
      final body = <String, dynamic>{
        'booking_id': bookingId,
        'accommodation_id': accommodationId,
        if (checkInDate != null && checkInDate.isNotEmpty)
          'check_in_date': checkInDate,
        if (checkOutDate != null && checkOutDate.isNotEmpty)
          'check_out_date': checkOutDate,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingAccommodation.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Booking Accommodation: $e');
      rethrow;
    }
  }

  static Future<BookingAccommodation> updateBookingAccommodation({
    required int id,
    String? checkInDate,
    String? checkOutDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingAccommodationDetail(id));
      final body = <String, dynamic>{};

      if (checkInDate != null) body['check_in_date'] = checkInDate;
      if (checkOutDate != null) body['check_out_date'] = checkOutDate;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingAccommodation.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Booking Accommodation: $e');
      rethrow;
    }
  }

  static Future<void> deleteBookingAccommodation(int id) async {
    try {
      final url = Uri.parse(ApiConfig.bookingAccommodationDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Booking Accommodation: $e');
      rethrow;
    }
  }

  // Booking Activities APIs
  static Future<List<BookingActivity>> getBookingActivities({
    int? bookingId,
  }) async {
    final url = Uri.parse(ApiConfig.bookingActivities).replace(
      queryParameters: {
        if (bookingId != null) 'booking_id': bookingId.toString(),
      },
    );

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    if (data is List) {
      return data
          .map((e) => BookingActivity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<BookingActivity> getBookingActivity(int id) async {
    final url = Uri.parse(ApiConfig.bookingActivityDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingActivity.fromJson(data as Map<String, dynamic>);
  }

  static Future<BookingActivity> createBookingActivity({
    required int bookingId,
    required int activityId,
    String? scheduledDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingActivities);
      final body = <String, dynamic>{
        'booking_id': bookingId,
        'activity_id': activityId,
        if (scheduledDate != null && scheduledDate.isNotEmpty)
          'scheduled_date': scheduledDate,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingActivity.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Booking Activity: $e');
      rethrow;
    }
  }

  static Future<BookingActivity> updateBookingActivity({
    required int id,
    String? scheduledDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingActivityDetail(id));
      final body = <String, dynamic>{};

      if (scheduledDate != null) body['scheduled_date'] = scheduledDate;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingActivity.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Booking Activity: $e');
      rethrow;
    }
  }

  static Future<void> deleteBookingActivity(int id) async {
    try {
      final url = Uri.parse(ApiConfig.bookingActivityDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Booking Activity: $e');
      rethrow;
    }
  }

  // Booking Routes APIs
  static Future<List<BookingRoute>> getBookingRoutes({int? bookingId}) async {
    final url = Uri.parse(ApiConfig.bookingRoutes).replace(
      queryParameters: {
        if (bookingId != null) 'booking_id': bookingId.toString(),
      },
    );

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    if (data is List) {
      return data
          .map((e) => BookingRoute.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<BookingRoute> getBookingRoute(int id) async {
    final url = Uri.parse(ApiConfig.bookingRouteDetail(id));

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingRoute.fromJson(data as Map<String, dynamic>);
  }

  static Future<BookingRoute> createBookingRoute({
    required int bookingId,
    required int routeId,
    String? scheduledDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingRoutes);
      final body = <String, dynamic>{
        'booking_id': bookingId,
        'route_id': routeId,
        if (scheduledDate != null && scheduledDate.isNotEmpty)
          'scheduled_date': scheduledDate,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingRoute.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Create Booking Route: $e');
      rethrow;
    }
  }

  static Future<BookingRoute> updateBookingRoute({
    required int id,
    String? scheduledDate,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.bookingRouteDetail(id));
      final body = <String, dynamic>{};

      if (scheduledDate != null) body['scheduled_date'] = scheduledDate;

      debugPrint('📤 API Request - PATCH $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: await _getHeaders(authRequired: true),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return BookingRoute.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - Update Booking Route: $e');
      rethrow;
    }
  }

  static Future<void> deleteBookingRoute(int id) async {
    try {
      final url = Uri.parse(ApiConfig.bookingRouteDetail(id));

      debugPrint('📤 API Request - DELETE $url');

      final response = await http.delete(
        url,
        headers: await _getHeaders(authRequired: true),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      _handleResponse(response);
    } catch (e) {
      debugPrint('❌ Network Error - Delete Booking Route: $e');
      rethrow;
    }
  }

  // AI Communication API
  static Future<AIResponse> aiCommunication({
    required String prompt,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.aiCommunication);
      final body = {
        'prompt': prompt,
        'latitude': latitude,
        'longitude': longitude,
      };

      debugPrint('📤 API Request - POST $url');
      debugPrint('📤 Request body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: json.encode(body),
      );

      debugPrint('📥 API Response - Status: ${response.statusCode}');
      final data = _handleResponse(response);
      return AIResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Network Error - AI Communication: $e');
      rethrow;
    }
  }

  // Profile APIs
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final url = Uri.parse(ApiConfig.profile);
      debugPrint('📤 API Request - GET $url');

      final response = await http.get(
        url,
        headers: await _getHeaders(authRequired: true),
      );
      debugPrint('📥 API Response - Status: ${response.statusCode}');

      return _handleResponse(response) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Network Error - Get Profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? imagePath,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.profile);
      debugPrint('📤 API Request - PATCH/POST $url');

      final headers = await _getHeaders(authRequired: true);

      if (imagePath != null) {
        // Use MultipartRequest for image upload
        final request = http.MultipartRequest('POST', url)
          ..headers.addAll(headers);

        if (firstName != null) request.fields['first_name'] = firstName;
        if (lastName != null) request.fields['last_name'] = lastName;
        if (email != null) request.fields['email'] = email;

        request.files.add(
          await http.MultipartFile.fromPath('profile_picture', imagePath),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('📥 API Response - Status: ${response.statusCode}');
        return _handleResponse(response) as Map<String, dynamic>;
      } else {
        // Regular JSON update
        final body = <String, dynamic>{};
        if (firstName != null) body['first_name'] = firstName;
        if (lastName != null) body['last_name'] = lastName;
        if (email != null) body['email'] = email;

        final response = await http.patch(
          url,
          headers: headers,
          body: json.encode(body),
        );

        debugPrint('📥 API Response - Status: ${response.statusCode}');
        return _handleResponse(response) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('❌ Network Error - Update Profile: $e');
      rethrow;
    }
  }
}
