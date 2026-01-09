import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ContentService {
  Future<List<dynamic>> getNovels() async {
    final response = await http.get(Uri.parse('${Config.baseUrlContent}/novels'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load novels');
    }
  }

  Future<Map<String, dynamic>> getNovelDetails(int id) async {
    final response = await http.get(Uri.parse('${Config.baseUrlContent}/novels/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load novel details');
    }
  }
}
