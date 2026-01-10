import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

class CommentService {
  // Get comments for a chapter
  Future<List<dynamic>> getCommentsByChapter(int chapterId) async {
    try {
      print('[COMMENT] Fetching comments for chapter $chapterId...');
      final response = await http.get(
        Uri.parse('${Config.baseUrlInteraction}/comments?chapter_id=$chapterId'),
      ).timeout(Duration(seconds: 10));

      print('[COMMENT] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List;
      } else {
        throw Exception('Failed to load comments');
      }
    } on SocketException catch (e) {
      print('[COMMENT ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server comment');
    } catch (e) {
      print('[COMMENT ERROR] $e');
      throw Exception('Error loading comments: $e');
    }
  }

  // Add new comment
  Future<Map<String, dynamic>> addComment({
    required int userId,
    required int novelId,
    required int chapterId,
    required String content,
  }) async {
    try {
      print('[COMMENT] Adding comment for chapter $chapterId...');
      final response = await http.post(
        Uri.parse('${Config.baseUrlInteraction}/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'novel_id': novelId,
          'chapter_id': chapterId,
          'content': content,
        }),
      ).timeout(Duration(seconds: 10));

      print('[COMMENT] Response status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add comment');
      }
    } on SocketException catch (e) {
      print('[COMMENT ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server comment');
    } catch (e) {
      print('[COMMENT ERROR] $e');
      throw Exception('Error adding comment: $e');
    }
  }

  // Update comment
  Future<Map<String, dynamic>> updateComment(int commentId, String content) async {
    try {
      print('[COMMENT] Updating comment $commentId...');
      final response = await http.put(
        Uri.parse('${Config.baseUrlInteraction}/comments/$commentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': content}),
      ).timeout(Duration(seconds: 10));

      print('[COMMENT] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update comment');
      }
    } on SocketException catch (e) {
      print('[COMMENT ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server comment');
    } catch (e) {
      print('[COMMENT ERROR] $e');
      throw Exception('Error updating comment: $e');
    }
  }

  // Delete comment
  Future<void> deleteComment(int commentId) async {
    try {
      print('[COMMENT] Deleting comment $commentId...');
      final response = await http.delete(
        Uri.parse('${Config.baseUrlInteraction}/comments/$commentId'),
      ).timeout(Duration(seconds: 10));

      print('[COMMENT] Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete comment');
      }
    } on SocketException catch (e) {
      print('[COMMENT ERROR] Network error: $e');
      throw Exception('Tidak bisa connect ke server comment');
    } catch (e) {
      print('[COMMENT ERROR] $e');
      throw Exception('Error deleting comment: $e');
    }
  }
}
