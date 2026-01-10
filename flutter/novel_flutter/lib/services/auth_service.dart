import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('[AUTH] Login attempt for: $email');
      print('[AUTH] URL: ${Config.baseUrlAuth}/auth/login');
      
      final response = await http.post(
        Uri.parse('${Config.baseUrlAuth}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 10));

      print('[AUTH] Login response status: ${response.statusCode}');
      print('[AUTH] Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('userId', data['user']['id']);
        return data;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } on SocketException catch (e) {
      print('[AUTH ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server. Pastikan backend running dan gunakan emulator (bukan web)');
    } on TimeoutException catch (e) {
      print('[AUTH ERROR] Timeout: $e');
      throw Exception('Request timeout. Server tidak merespons');
    } catch (e) {
      print('[AUTH ERROR] Unexpected error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      print('[AUTH] Register attempt for: $email');
      print('[AUTH] URL: ${Config.baseUrlAuth}/auth/register');
      print('[AUTH] Payload: name=$name, email=$email');
      
      final response = await http.post(
        Uri.parse('${Config.baseUrlAuth}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      ).timeout(Duration(seconds: 10));

      print('[AUTH] Register response status: ${response.statusCode}');
      print('[AUTH] Register response body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Register failed: ${response.body}');
      }
    } on SocketException catch (e) {
      print('[AUTH ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server (${Config.baseUrlAuth}). Pastikan:\n1. Backend running (docker-compose up)\n2. Gunakan Android Emulator (bukan Chrome)\n3. Port 3001 tidak diblock firewall');
    } on TimeoutException catch (e) {
      print('[AUTH ERROR] Timeout: $e');
      throw Exception('Request timeout. Server tidak merespons dalam 10 detik');
    } catch (e) {
      print('[AUTH ERROR] Unexpected error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlAuth}/users/profile/$userId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getFavoritesCount(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlAuth}/users/$userId/favorites-count'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get favorites count');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteAccount(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrlAuth}/users/$userId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
