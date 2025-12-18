import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FacilityService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<dynamic>> getFacilities({String? query}) async {
    try {
      String url = '$baseUrl/facilities';
      if (query != null && query.isNotEmpty) {
        url += '?search=$query';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load facilities');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<Map<String, dynamic>> createBooking(
      int facilityId, DateTime date, int startTime, int endTime) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return {'success': false, 'message': 'Unauthorized. Please login first.'};
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/booking'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'facilityId': facilityId,
          'date': date.toIso8601String(),
          'startTime': startTime,
          'endTime': endTime,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Booking failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
}
