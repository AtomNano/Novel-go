import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/novel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovelService {
  // Get all novels
  Future<List<Novel>> getAllNovels() async {
    try {
      print('[NOVEL] Fetching all novels...');
      final response = await http.get(
        Uri.parse('${Config.baseUrlNovel}/novels'),
      ).timeout(Duration(seconds: 10));

      print('[NOVEL] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Novel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load novels');
      }
    } on SocketException catch (e) {
      print('[NOVEL ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server novel');
    } catch (e) {
      print('[NOVEL ERROR] $e');
      throw Exception('Error loading novels: $e');
    }
  }

  // Get novel detail
  Future<Novel> getNovelDetail(int id) async {
    try {
      print('[NOVEL] Fetching novel $id...');
      final response = await http.get(
        Uri.parse('${Config.baseUrlNovel}/novels/$id'),
      ).timeout(Duration(seconds: 10));

      print('[NOVEL] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Novel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Novel not found');
      }
    } on SocketException catch (e) {
      print('[NOVEL ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server novel');
    } catch (e) {
      print('[NOVEL ERROR] $e');
      throw Exception('Error loading novel: $e');
    }
  }

  // Track view
  Future<void> trackView(int novelId, int? userId) async {
    try {
      print('[NOVEL] Tracking view for novel $novelId...');
      final response = await http.post(
        Uri.parse('${Config.baseUrlNovel}/novels/$novelId/view'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      ).timeout(Duration(seconds: 10));

      print('[NOVEL] View tracked: ${response.statusCode}');
    } catch (e) {
      print('[NOVEL ERROR] Error tracking view: $e');
      // Don't throw, view tracking shouldn't block user
    }
  }

  // Admin: Create novel
  Future<Novel> createNovel({
    required String title,
    required String author,
    required String publisher,
    required String content,
    String? description,
    String? cover,
    String? publishedDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('${Config.baseUrlNovel}/novels'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'author': author,
          'publisher': publisher,
          'content': content,
          'description': description,
          'cover': cover,
          'published_date': publishedDate,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Novel.fromJson(data);
      } else {
        throw Exception('Failed to create novel');
      }
    } catch (e) {
      throw Exception('Error creating novel: $e');
    }
  }

  // Admin: Update novel
  Future<Novel> updateNovel(int id, Map<String, dynamic> updates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('${Config.baseUrlNovel}/novels/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updates),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Novel.fromJson(data);
      } else {
        throw Exception('Failed to update novel');
      }
    } catch (e) {
      throw Exception('Error updating novel: $e');
    }
  }

  // Admin: Delete novel
  Future<void> deleteNovel(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('${Config.baseUrlNovel}/novels/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete novel');
      }
    } catch (e) {
      throw Exception('Error deleting novel: $e');
    }
  }
}
