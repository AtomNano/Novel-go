import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';
import 'user_form_screen.dart';

class UsersManagementScreen extends StatefulWidget {
  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrlAuth}/users'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteUser(int userId, String userName) async {
    try {
      final response = await http.delete(
        Uri.parse('${Config.baseUrlAuth}/users/$userId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User "$userName" deleted')),
        );
        _loadUsers();
      } else {
        throw Exception('Failed to delete user');
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
        title: Text('Manage Users'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No users found'))
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user['name'].substring(0, 1).toUpperCase()),
                          ),
                          title: Text(user['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['email']),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: user['role'] == 'admin' ? Colors.red : Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['role'].toString().toUpperCase(),
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'view',
                                child: Row(
                                  children: [
                                    Icon(Icons.info, size: 20),
                                    SizedBox(width: 8),
                                    Text('View Details'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit User'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete User', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'view') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('User Details'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailRow('ID', user['id'].toString()),
                                        _buildDetailRow('Name', user['name']),
                                        _buildDetailRow('Email', user['email']),
                                        _buildDetailRow('Role', user['role']),
                                        if (user['address'] != null)
                                          _buildDetailRow('Address', user['address']),
                                        if (user['created_at'] != null)
                                          _buildDetailRow('Joined', user['created_at']),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserFormScreen(user: user),
                                  ),
                                ).then((result) {
                                  if (result == true) _loadUsers();
                                });
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete User'),
                                    content: Text('Are you sure you want to delete "${user['name']}"? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteUser(user['id'], user['name']);
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
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserFormScreen(),
            ),
          ).then((result) {
            if (result == true) _loadUsers();
          });
        },
        icon: Icon(Icons.person_add),
        label: Text('Add User'),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
