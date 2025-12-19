import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS/Web.
  // Since we are likely on Windows dev, localhost might work for desktop app,
  // but if using emulator use 10.0.2.2.
  // For safety, let's try generic localhost first or make it configurable.
  // Given user is on Windows running 'flutter run -d windows', localhost is fine.
  static String get baseUrl => '${AppConfig.baseUrl}/auth';

  Future<Map<String, dynamic>> register(String name, String email, String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'nim': nim,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _saveToken(data['token']);
        final prefs = await SharedPreferences.getInstance();
        if (data['user'] != null && data['user']['name'] != null) {
          await prefs.setString('user_name', data['user']['name']);
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String nim, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nim': nim,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveToken(data['token']);
        final prefs = await SharedPreferences.getInstance();
        if (data['user'] != null && data['user']['name'] != null) {
          await prefs.setString('user_name', data['user']['name']);
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('getProfile status: ${response.statusCode}');
      print('getProfile body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        throw Exception('UA_401'); // Treat 404 (User not found) as auth error
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<bool> updateProfile(String name, String? password, {XFile? imageFile}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/update'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['name'] = name;
      if (password != null && password.isNotEmpty) {
        request.fields['password'] = password;
      }

      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          bytes,
          filename: imageFile.name,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update failed: ${response.body}');
        return false;
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
