import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/favorite.dart';
import '../../services/collection_service.dart';
import 'novel_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final CollectionService _collectionService = CollectionService();
  List<Favorite> _favorites = [];
  bool _isLoading = true;
  String? _error;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('userId');
      
      if (_userId == null) {
        throw Exception('Please login first');
      }

      final favorites = await _collectionService.getUserFavorites(_userId!);
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Favorite favorite) async {
    try {
      await _collectionService.removeFromFavorites(favorite.id);
      _loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: _buildBody(),
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
              onPressed: _loadFavorites,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('No favorites yet'),
            SizedBox(height: 8),
            Text('Add novels to your favorites from the detail page'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final favorite = _favorites[index];
        final novel = favorite.novel;
          
          if (novel == null) return SizedBox();

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
              title: Text(
                novel.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(novel.publisher),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${novel.viewCount} views'),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Remove Favorite'),
                      content: Text('Remove this novel from favorites?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _removeFavorite(favorite);
                          },
                          child: Text('Remove'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NovelDetailScreen(novel: novel),
                  ),
                ).then((_) => _loadFavorites());
              },
            ),
          );
        },
      ),
    );
  }
}
