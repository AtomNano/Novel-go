import 'package:flutter/material.dart';
import '../../models/novel.dart';
import '../../services/novel_service.dart';

class NovelFormScreen extends StatefulWidget {
  final Novel? novel;

  const NovelFormScreen({Key? key, this.novel}) : super(key: key);

  @override
  _NovelFormScreenState createState() => _NovelFormScreenState();
}

class _NovelFormScreenState extends State<NovelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final NovelService _novelService = NovelService();
  
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _publisherController;
  late TextEditingController _coverController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.novel?.title ?? '');
    _authorController = TextEditingController(text: widget.novel?.author ?? '');
    _publisherController = TextEditingController(text: widget.novel?.publisher ?? '');
    _coverController = TextEditingController(text: widget.novel?.cover ?? '');
    _descriptionController = TextEditingController(text: widget.novel?.description ?? '');
    _contentController = TextEditingController(text: widget.novel?.content ?? '');
  }

  Future<void> _saveNovel() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.novel == null) {
        // Create new
        await _novelService.createNovel(
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          publisher: _publisherController.text.trim(),
          content: _contentController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          cover: _coverController.text.trim().isEmpty ? null : _coverController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Novel created successfully')),
        );
      } else {
        // Update existing
        await _novelService.updateNovel(widget.novel!.id, {
          'title': _titleController.text.trim(),
          'author': _authorController.text.trim(),
          'publisher': _publisherController.text.trim(),
          'content': _contentController.text.trim(),
          'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          'cover': _coverController.text.trim().isEmpty ? null : _coverController.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Novel updated successfully')),
        );
      }
      Navigator.pop(context);
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
        title: Text(widget.novel == null ? 'Add Novel' : 'Edit Novel'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title *'),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author *'),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _publisherController,
                decoration: InputDecoration(labelText: 'Publisher *'),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _coverController,
                decoration: InputDecoration(labelText: 'Cover URL'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content *'),
                maxLines: 10,
                validator: (value) => value?.trim().isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveNovel,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(widget.novel == null ? 'Create Novel' : 'Update Novel'),
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
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _coverController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
