import 'package:flutter/material.dart';
import '../../models/novel.dart';
import '../../services/novel_service.dart';
import 'novel_form_screen.dart';
import '../user/novel_detail_screen.dart';

class NovelsManagementScreen extends StatefulWidget {
  @override
  _NovelsManagementScreenState createState() => _NovelsManagementScreenState();
}

class _NovelsManagementScreenState extends State<NovelsManagementScreen> {
  final NovelService _novelService = NovelService();
  List<Novel> _novels = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNovels();
  }

  Future<void> _loadNovels() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final novels = await _novelService.getAllNovels();
      setState(() {
        _novels = novels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNovel(Novel novel) async {
    try {
      await _novelService.deleteNovel(novel.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Novel deleted successfully')),
      );
      _loadNovels();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete novel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Novels'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NovelFormScreen(),
            ),
          ).then((_) => _loadNovels());
        },
        icon: Icon(Icons.add),
        label: Text('Add Novel'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 16),
            Text('Error: $_error'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNovels,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_novels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('No novels yet'),
            SizedBox(height: 8),
            Text('Tap + button to add a novel'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNovels,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _novels.length,
        itemBuilder: (context, index) {
          final novel = _novels[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  novel.cover,
                  width: 60,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.book),
                    );
                  },
                ),
              ),
              title: Text(novel.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('by ${novel.author}'),
                  Text('${novel.viewCount} views', style: TextStyle(fontSize: 12)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailScreen(novel: novel),
                  ),
                ).then((_) => _loadNovels());
              },
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NovelFormScreen(novel: novel),
                      ),
                    ).then((_) => _loadNovels());
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Novel'),
                        content: Text('Are you sure you want to delete "${novel.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteNovel(novel);
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
