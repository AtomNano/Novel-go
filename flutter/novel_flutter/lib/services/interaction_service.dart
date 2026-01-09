import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class InteractionService {
  Future<List<dynamic>> getComments(int novelId) async {
    final response = await http.get(Uri.parse('${Config.baseUrlInteraction}/comments/novel/$novelId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> postComment(int userId, int novelId, String content) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrlInteraction}/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'novel_id': novelId,
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post comment');
    }
  }
}
