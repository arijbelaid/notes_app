import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../providers/auth_provider.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';
import '../widgets/edit_note_modal.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() { _isLoading = true; _error = null; });
    try {
      final fetchedNotes = await _noteService.getNotes(userId: authProvider.user?.$id);
      setState(() { _notes = fetchedNotes; _isLoading = false; });
    } catch (e) {
      setState(() { _error = 'Failed to load notes. Please try again.'; _isLoading = false; });
    }
  }

  void _showAddNoteDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        userId: authProvider.user?.$id ?? '',
        onNoteAdded: (newNote) => setState(() => _notes = [newNote, ..._notes]),
      ),
    );
  }

  void _showEditNoteDialog(Document note) {
    showDialog(
      context: context,
      builder: (context) => EditNoteModal(
        note: note,
        onNoteUpdated: (updatedNote) {
          setState(() {
            _notes = _notes.map((n) => n.$id == updatedNote.$id ? updatedNote : n).toList();
          });
        },
      ),
    );
  }

  void _handleNoteDeleted(String noteId) {
    setState(() { _notes = _notes.where((n) => n.$id != noteId).toList(); });
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("You don't have any notes yet.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Tap the + button to create your first note!", style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: _isLoading && _notes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _notes.isEmpty
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _notes.isEmpty
                  ? _buildEmptyView()
                  : RefreshIndicator(
                      onRefresh: _fetchNotes,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          return NoteItem(
                            note: _notes[index],
                            onNoteDeleted: _handleNoteDeleted,
                            onEdit: () => _showEditNoteDialog(_notes[index]),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
