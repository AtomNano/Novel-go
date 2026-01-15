import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/comment.dart';

class InteractionService {
  // Get comments for a novel
  Future<List<Comment>> getCommentsByNovel(int novelId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlInteraction}/comments?novel_id=$novelId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } on SocketException catch (e) {
      throw Exception('Tidak bisa connect ke server');
    } catch (e) {
      throw Exception('Error loading comments: $e');
    }
  }

  // Post comment
  Future<Comment> postComment({
    required int userId,
    required int novelId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrlInteraction}/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'novel_id': novelId,
          'content': content,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Comment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to post comment');
      }
    } catch (e) {
      throw Exception('Error posting comment: $e');
    }
  }

  // Update comment
  Future<Comment> updateComment(int commentId, String content) async {
    try {
      final response = await http.put(
        Uri.parse('${Config.baseUrlInteraction}/comments/$commentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Comment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update comment');
      }
    } catch (e) {
      throw Exception('Error updating comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(int commentId) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrlInteraction}/comments/$commentId'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  // Admin: Get all comments
  Future<List<Comment>> getAllComments() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlInteraction}/comments'),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error loading comments: $e');
    }
  }
}
