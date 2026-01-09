import 'package:flutter/material.dart';
import '../services/content_service.dart';
import 'novel_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _contentService = ContentService();
  List<dynamic> _novels = [];

  @override
  void initState() {
    super.initState();
    _loadNovels();
  }

  void _loadNovels() async {
    try {
      final novels = await _contentService.getNovels();
      setState(() {
        _novels = novels;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novel-Go Home')),
      body: ListView.builder(
        itemCount: _novels.length,
        itemBuilder: (context, index) {
          final novel = _novels[index];
          return ListTile(
            leading: Image.network(novel['cover'] ?? '', errorBuilder: (context, error, stackTrace) => Icon(Icons.book)),
            title: Text(novel['title']),
            subtitle: Text(novel['author']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NovelDetailScreen(novelId: novel['id'])),
              );
            },
          );
        },
      ),
    );
  }
}
