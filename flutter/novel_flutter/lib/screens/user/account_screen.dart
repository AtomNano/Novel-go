import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;
  int _favoritesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId != null) {
        // Get user profile
        final response = await _authService.getProfile(userId);
        setState(() {
          _user = User.fromJson(response);
        });

        // Get favorites count
        final countResponse = await _authService.getFavoritesCount(userId);
        setState(() {
          _favoritesCount = countResponse['count'] ?? 0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                if (_user != null) {
                  await _authService.deleteAccount(_user!.id);
                  _logout();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete account')),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
              ? Center(child: Text('Please login'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      // Profile Photo
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: _user!.profilePhoto != null
                            ? ClipOval(
                                child: Image.network(
                                  _user!.profilePhoto!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.person, size: 50);
                                  },
                                ),
                              )
                            : Icon(Icons.person, size: 50),
                      ),
                      SizedBox(height: 16),
                      // Name
                      Text(
                        _user!.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      //Email
                      Text(
                        _user!.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),
                      // Stats
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.favorite, color: Colors.red),
                                  SizedBox(height: 8),
                                  Text(
                                    '$_favoritesCount',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Favorites'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Menu Options
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit Profile'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(user: _user!),
                            ),
                          ).then((_) => _loadUserInfo());
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(userId: _user!.id),
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.orange),
                        title: Text('Logout'),
                        onTap: _logout,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.delete_forever, color: Colors.red),
                        title: Text('Delete Account', style: TextStyle(color: Colors.red)),
                        onTap: _deleteAccount,
                      ),
                    ],
                  ),
                ),
    );
  }
}
