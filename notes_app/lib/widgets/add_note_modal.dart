import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';

class AddNoteModal extends StatefulWidget {
  final String userId;
  final Function(Document) onNoteAdded;

  const AddNoteModal({Key? key, required this.userId, required this.onNoteAdded}) : super(key: key);

  @override
  _AddNoteModalState createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteService = NoteService();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      setState(() { _error = 'Please fill in both title and content'; });
      return;
    }

    try {
      setState(() { _isLoading = true; _error = null; });
      final newNote = await _noteService.createNote({ 'title': title, 'content': content, 'user_id': widget.userId });
      widget.onNoteAdded(newNote);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() { _error = 'Failed to save note. Please try again.'; });
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _contentController, decoration: const InputDecoration(hintText: 'Content', border: OutlineInputBorder()), maxLines: 5),
        ],
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _isLoading ? null : _handleSave, child: Text(_isLoading ? 'Saving...' : 'Save Note')),
      ],
    );
  }
}
