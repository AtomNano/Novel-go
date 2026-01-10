import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/favorite.dart';

class CollectionService {
  // Get user's favorites
  Future<List<Favorite>> getUserFavorites(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlCollection}/favorites/$userId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Favorite.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } on SocketException catch (e) {
      throw Exception('Tidak bisa connect ke server');
    } catch (e) {
      throw Exception('Error loading favorites: $e');
    }
  }

  // Add to favorites
  Future<Favorite> addToFavorites({
    required int userId,
    required int novelId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrlCollection}/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'novelId': novelId,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Favorite.fromJson(data['favorite']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to add to favorites');
      }
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(int favoriteId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrlCollection}/favorites/$favoriteId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  // Remove by user and novel ID
  Future<void> removeByUserAndNovel(int userId, int novelId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrlCollection}/favorites/user/$userId/novel/$novelId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  // Check if novel is favorited
  Future<bool> isFavorited(int userId, int novelId) async {
    try {
      final favorites = await getUserFavorites(userId);
      return favorites.any((fav) => fav.novelId == novelId);
    } catch (e) {
      return false;
    }
  }
}
