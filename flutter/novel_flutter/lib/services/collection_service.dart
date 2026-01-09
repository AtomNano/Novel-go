import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class CollectionService {
  Future<List<dynamic>> getLibrary(int userId) async {
    final response = await http.get(Uri.parse('${Config.baseUrlCollection}/library/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load library');
    }
  }

  Future<void> addToLibrary(int userId, int novelId) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrlCollection}/library'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'novelId': novelId,
        'status': 'Reading',
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add to library');
    }
  }
}
