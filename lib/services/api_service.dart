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

class ApiService {
  // Get base URL based on platform
  // Android Emulator: Use 10.0.2.2 to access host machine's localhost
  // iOS Simulator: Use 127.0.0.1 (localhost works)
  // Physical Devices: Use your computer's IP address (e.g., 192.168.x.x)
  // Web: Use localhost or your server's public URL
  static String get baseUrl {
    String url;

    if (kIsWeb) {
      // For web platform, use localhost
      url = 'http://127.0.0.1:8000';
      debugPrint('🌐 Platform: Web - Using baseUrl: $url');
    } else {
      // For mobile platforms, check using defaultTargetPlatform
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          // For Android emulator, use 10.0.2.2 to access host machine
          // For physical Android device, replace with your computer's IP address
          url = 'http://10.0.2.2:8000';
          debugPrint('🤖 Platform: Android - Using baseUrl: $url');
          break;
        case TargetPlatform.iOS:
          // iOS simulator can use localhost
          url = 'http://127.0.0.1:8000';
          debugPrint('🍎 Platform: iOS - Using baseUrl: $url');
          break;
        default:
          // For desktop platforms (Windows, macOS, Linux), use localhost
          url = 'http://127.0.0.1:8000';
          debugPrint('💻 Platform: Desktop - Using baseUrl: $url');
      }
    }

    return url;
  }

  static const String apiPrefix = '/api';

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
      final url = Uri.parse('$baseUrl$apiPrefix/auth/register/');
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
        debugPrint(
          '💡 Tip: Check if URL is correct: $baseUrl$apiPrefix/auth/register/',
        );
      }
      rethrow;
    }
  }

  static Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$apiPrefix/auth/login/');
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
      final url = Uri.parse('$baseUrl$apiPrefix/activities/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/activities/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return TravelActivity.fromJson(data as Map<String, dynamic>);
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
      final url = Uri.parse('$baseUrl$apiPrefix/accommodations/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/accommodations/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return Accommodation.fromJson(data as Map<String, dynamic>);
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
    final url = Uri.parse('$baseUrl$apiPrefix/routes/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/routes/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return TravelRoute.fromJson(data as Map<String, dynamic>);
  }

  // Bookings APIs
  static Future<List<Booking>> getBookings({
    String? status,
    String? paymentStatus,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/$id/');

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
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/');
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

  // Booking Accommodations APIs
  static Future<List<BookingAccommodation>> getBookingAccommodations({
    int? bookingId,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/accommodations/')
        .replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/accommodations/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingAccommodation.fromJson(data as Map<String, dynamic>);
  }

  // Booking Activities APIs
  static Future<List<BookingActivity>> getBookingActivities({
    int? bookingId,
  }) async {
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/activities/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/activities/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingActivity.fromJson(data as Map<String, dynamic>);
  }

  // Booking Routes APIs
  static Future<List<BookingRoute>> getBookingRoutes({int? bookingId}) async {
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/routes/').replace(
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
    final url = Uri.parse('$baseUrl$apiPrefix/bookings/routes/$id/');

    final response = await http.get(url, headers: await _getHeaders());

    final data = _handleResponse(response);
    return BookingRoute.fromJson(data as Map<String, dynamic>);
  }

  // AI Communication API
  static Future<AIResponse> aiCommunication({
    required String prompt,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$apiPrefix/api_communication/');
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
}
