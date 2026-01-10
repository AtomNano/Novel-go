import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/novel.dart';
import '../../services/novel_service.dart';
import '../../widgets/novel_card.dart';
import 'novel_detail_screen.dart';
import 'favorites_screen.dart';
import 'account_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NovelService _novelService = NovelService();
  List<Novel> _novels = [];
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadNovels();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novel-Go'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNovels,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Already on dashboard
            return;
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Novels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
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
            Text('No novels available'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNovels,
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _novels.length,
        itemBuilder: (context, index) {
          return NovelCard(
            novel: _novels[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailScreen(novel: _novels[index]),
                ),
              ).then((_) => _loadNovels()); // Refresh after returning
            },
          );
        },
      ),
    );
  }
}
