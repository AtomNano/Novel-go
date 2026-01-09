import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/content_service.dart';
import '../services/interaction_service.dart';
import '../services/collection_service.dart';

class NovelDetailScreen extends StatefulWidget {
  final int novelId;

  NovelDetailScreen({required this.novelId});

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  final _contentService = ContentService();
  final _interactionService = InteractionService();
  final _collectionService = CollectionService();
  
  Map<String, dynamic>? _novel;
  List<dynamic> _comments = [];
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final novel = await _contentService.getNovelDetails(widget.novelId);
      final comments = await _interactionService.getComments(widget.novelId);
      setState(() {
        _novel = novel;
        _comments = comments;
      });
    } catch (e) {
      print(e);
    }
  }

  void _postComment() async {
     final prefs = await SharedPreferences.getInstance();
     final userId = prefs.getInt('userId');
     if (userId == null) return;

    await _interactionService.postComment(userId, widget.novelId, _commentController.text);
    _commentController.clear();
    _loadData(); // Refresh comments
  }

  void _addToLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    try {
      await _collectionService.addToLibrary(userId, widget.novelId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to Library')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add to library')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_novel == null) return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(_novel!['title'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_novel!['content']),
            ),
            ElevatedButton(onPressed: _addToLibrary, child: Text('Add to Library')),
            Divider(),
            Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_comments[index]['content']));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: _commentController, decoration: InputDecoration(hintText: 'Add a comment'))),
                  IconButton(icon: Icon(Icons.send), onPressed: _postComment),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
