import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';

class UserFormScreen extends StatefulWidget {
  final Map<String, dynamic>? user;

  const UserFormScreen({Key? key, this.user}) : super(key: key);

  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _addressController;
  
  String _selectedRole = 'user';
  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.user != null;
    _nameController = TextEditingController(text: widget.user?['name'] ?? '');
    _emailController = TextEditingController(text: widget.user?['email'] ?? '');
    _passwordController = TextEditingController();
    _addressController = TextEditingController(text: widget.user?['address'] ?? '');
    _selectedRole = widget.user?['role'] ?? 'user';
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditMode) {
        // Update existing user
        await _updateUser();
      } else {
        // Create new user
        await _createUser();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditMode ? 'User updated successfully' : 'User created successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createUser() async {
    final response = await http.post(
      Uri.parse('${Config.baseUrlAuth}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      }),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to create user');
    }

    // Update role if admin was selected
    if (_selectedRole == 'admin') {
      final userData = jsonDecode(response.body);
      final userId = userData['user']['id'];
      await _updateUserRole(userId, 'admin');
    }
  }

  Future<void> _updateUser() async {
    Map<String, dynamic> updateData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    };

    // Only include password if it's not empty
    if (_passwordController.text.isNotEmpty) {
      updateData['password'] = _passwordController.text;
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrlAuth}/users/profile/${widget.user!['id']}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }

    // Update role if changed
    if (_selectedRole != widget.user!['role']) {
      await _updateUserRole(widget.user!['id'], _selectedRole);
    }
  }

  Future<void> _updateUserRole(int userId, String role) async {
    // Direct database update via custom endpoint or SQL
    // For now, we'll use a workaround since we don't have a dedicated role update endpoint
    final response = await http.put(
      Uri.parse('${Config.baseUrlAuth}/users/profile/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': role}),
    );

    if (response.statusCode != 200) {
      print('Warning: Failed to update role, may need manual DB update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit User' : 'Create User'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) return 'Required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: _isEditMode ? 'New Password (leave empty to keep current)' : 'Password *',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (!_isEditMode && (value?.isEmpty ?? true)) {
                    return 'Required';
                  }
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address (Optional)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              Text(
                'Role *',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        value: 'user',
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('User'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Admin'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveUser,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(_isEditMode ? 'Update User' : 'Create User'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
