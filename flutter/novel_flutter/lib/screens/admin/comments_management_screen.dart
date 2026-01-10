import 'package:flutter/material.dart';
import '../../services/interaction_service.dart';
import '../../models/comment.dart';

class CommentsManagementScreen extends StatefulWidget {
  @override
  _CommentsManagementScreenState createState() => _CommentsManagementScreenState();
}

class _CommentsManagementScreenState extends State<CommentsManagementScreen> {
  final InteractionService _interactionService = InteractionService();
  List<Comment> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final comments = await _interactionService.getAllComments();
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading comments')),
      );
    }
  }

  Future<void> _deleteComment(int commentId) async {
    try {
      await _interactionService.deleteComment(commentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment deleted')),
      );
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Comments'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _comments.isEmpty
              ? Center(child: Text('No comments yet'))
              : RefreshIndicator(
                  onRefresh: _loadComments,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
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
                                    child: Text(comment.userName?.substring(0, 1).toUpperCase() ?? 'U'),
                                    radius: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.userName ?? 'Unknown',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        if (comment.createdAt != null)
                                          Text(
                                            comment.createdAt!,
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete Comment'),
                                          content: Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteComment(comment.id);
                                              },
                                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                ),
    );
  }
}
