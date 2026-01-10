import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/novel.dart';
import '../../models/comment.dart';
import '../../services/novel_service.dart';
import '../../services/interaction_service.dart';
import '../../services/collection_service.dart';
import 'novel_read_screen.dart';

class NovelDetailScreen extends StatefulWidget {
  final Novel novel;

  const NovelDetailScreen({Key? key, required this.novel}) : super(key: key);

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  final InteractionService _interactionService = InteractionService();
  final CollectionService _collectionService = CollectionService();
  final TextEditingController _commentController = TextEditingController();
  
  List<Comment> _comments = [];
  bool _isLoadingComments = false;
  bool _isFavorited = false;
  bool _isCheckingFavorite = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadComments();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    setState(() {
      _userId = userId;
    });
    if (userId != null) {
      _checkIfFavorited(userId);
    }
  }

  Future<void> _checkIfFavorited(int userId) async {
    try {
      final isFav = await _collectionService.isFavorited(userId, widget.novel.id);
      setState(() {
        _isFavorited = isFav;
        _isCheckingFavorite = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingFavorite = false;
      });
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
    });

    try {
      final comments = await _interactionService.getCommentsByNovel(widget.novel.id);
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingComments = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please login first')),
      );
      return;
    }

    try {
      await _interactionService.postComment(
        userId: _userId!,
        novelId: widget.novel.id,
        content: _commentController.text.trim(),
      );
      _commentController.clear();
      _loadComments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    if (_userId == null) return;

    try {
      if (_isFavorited) {
        await _collectionService.removeByUserAndNovel(_userId!, widget.novel.id);
        setState(() {
          _isFavorited = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        await _collectionService.addToFavorites(
          userId: _userId!,
          novelId: widget.novel.id,
        );
        setState(() {
          _isFavorited = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novel Details'),
        actions: [
          if (!_isCheckingFavorite)
            IconButton(
              icon: Icon(
                _isFavorited ? Icons.favorite : Icons.favorite_border,
                color: _isFavorited ? Colors.red : null,
              ),
              onPressed: _toggleFavorite,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Image.network(
              widget.novel.cover,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: Icon(Icons.book, size: 100, color: Colors.grey[600]),
                );
              },
            ),
            
            Padding(
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
                  
                  // Author & Publisher
                  Text(
                    'by ${widget.novel.author}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Text(
                    'Published by ${widget.novel.publisher}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  
                  // View Count
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${widget.novel.viewCount} views',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Description
                  if (widget.novel.description != null) ...[
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.novel.description!,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                  ],
                  
                  // Read Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.menu_book),
                      label: Text('Read Novel'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NovelReadScreen(novel: widget.novel),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Comments Section
                  Text(
                    'Comments (${_comments.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Add Comment
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addComment,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Comments List
                  _isLoadingComments
                      ? Center(child: CircularProgressIndicator())
                      : _comments.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('No comments yet'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                final comment = _comments[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              child: Text(
                                                comment.userName?.substring(0, 1).toUpperCase() ?? 'U',
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comment.userName ?? 'Unknown',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  if (comment.createdAt != null)
                                                    Text(
                                                      comment.createdAt!,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(comment.content),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
