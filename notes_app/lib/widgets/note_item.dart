import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';

class NoteItem extends StatefulWidget {
  final Document note;
  final Function(String)? onNoteDeleted;
  final VoidCallback? onEdit;

  const NoteItem({Key? key, required this.note, this.onNoteDeleted, this.onEdit}) : super(key: key);

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  final NoteService _noteService = NoteService();
  bool _isDeleting = false;

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() { _isDeleting = true; });
        await _noteService.deleteNote(widget.note.$id);
        if (widget.onNoteDeleted != null) widget.onNoteDeleted!(widget.note.$id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete note.'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() { _isDeleting = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.note.data['title'] as String? ?? '';
    final content = widget.note.data['content'] as String? ?? '';
    final updatedAt = widget.note.data['updatedAt'] as String? ?? widget.note.$updatedAt;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Last updated: ${_formatDate(updatedAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: widget.onEdit, child: const Text('Edit')),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _isDeleting ? null : _handleDelete,
                  child: _isDeleting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
