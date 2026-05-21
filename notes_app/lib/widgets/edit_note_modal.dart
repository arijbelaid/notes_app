import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';

class EditNoteModal extends StatefulWidget {
  final Document note;
  final Function(Document) onNoteUpdated;

  const EditNoteModal({Key? key, required this.note, required this.onNoteUpdated}) : super(key: key);

  @override
  _EditNoteModalState createState() => _EditNoteModalState();
}

class _EditNoteModalState extends State<EditNoteModal> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _noteService = NoteService();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.data['title'] as String? ?? '');
    _contentController = TextEditingController(text: widget.note.data['content'] as String? ?? '');
  }

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
      final updatedNote = await _noteService.updateNote(widget.note.$id, { 'title': title, 'content': content });
      widget.onNoteUpdated(updatedNote);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() { _error = 'Failed to update note. Please try again.'; });
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
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
        ElevatedButton(onPressed: _isLoading ? null : _handleSave, child: Text(_isLoading ? 'Saving...' : 'Save Changes')),
      ],
    );
  }
}
