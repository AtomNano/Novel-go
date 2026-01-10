import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user.dart';
import '../../config.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _profilePhotoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _profilePhotoController = TextEditingController(text: widget.user.profilePhoto ?? '');
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('${Config.baseUrlAuth}/users/profile/${widget.user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'address': _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          'profile_photo': _profilePhotoController.text.trim().isEmpty ? null : _profilePhotoController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to update profile');
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
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
              TextFormField(
                controller: _profilePhotoController,
                decoration: InputDecoration(
                  labelText: 'Profile Photo URL (Optional)',
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                  ),
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
    _addressController.dispose();
    _profilePhotoController.dispose();
    super.dispose();
  }
}
