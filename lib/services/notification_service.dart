import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class NotificationService {
  static String get baseUrl => '${AppConfig.baseUrl}/notifications';

  Future<List<dynamic>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<void> markAsRead(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token == null) return;

    try {
      await http.put(
        Uri.parse('$baseUrl/$id/read'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      // Ignore error for now
    }
  }
}
