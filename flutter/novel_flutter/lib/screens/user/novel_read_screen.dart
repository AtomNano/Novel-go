import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/novel.dart';
import '../../services/novel_service.dart';

class NovelReadScreen extends StatefulWidget {
  final Novel novel;

  const NovelReadScreen({Key? key, required this.novel}) : super(key: key);

  @override
  _NovelReadScreenState createState() => _NovelReadScreenState();
}

class _NovelReadScreenState extends State<NovelReadScreen> {
  final NovelService _novelService = NovelService();
  bool _viewTracked = false;

  @override
  void initState() {
    super.initState();
    _trackView();
  }

  Future<void> _trackView() async {
    if (_viewTracked) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      await _novelService.trackView(widget.novel.id, userId);
      _viewTracked = true;
    } catch (e) {
      print('Failed to track view: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novel.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.novel.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'by ${widget.novel.author}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            Divider(height: 32),
            
            // Content
            Text(
              widget.novel.content ?? 'Content not available',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
