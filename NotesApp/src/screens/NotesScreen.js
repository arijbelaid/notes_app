import React, { useState, useEffect, useContext } from "react";
import {
  View, Text, FlatList, StyleSheet, TouchableOpacity, ActivityIndicator,
} from "react-native";
import { getNotes, deleteNote, updateNote } from "../services/note.service";
import { AuthContext } from "../contexts/AuthContext";
import NoteItem from "../components/NoteItem";
import AddNoteModal from "../components/AddNoteModal";
import EditNoteModal from "../components/EditNoteModal";

const NotesScreen = () => {
  const [notes, setNotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [addModalVisible, setAddModalVisible] = useState(false);
  const [editingNote, setEditingNote] = useState(null);
  const { user } = useContext(AuthContext);

  const fetchNotes = async () => {
    setLoading(true);
    try {
      const fetchedNotes = await getNotes(user?.$id);
      setNotes(fetchedNotes);
    } catch (err) {
      setError("Failed to load notes. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) fetchNotes();
  }, [user]);

  const handleNoteAdded = (newNote) => {
    setNotes((current) => [newNote, ...current]);
  };

  const handleNoteDeleted = (noteId) => {
    setNotes((current) => current.filter((n) => n.$id !== noteId));
  };

  const handleNoteUpdated = (updatedNote) => {
    setNotes((current) => current.map((n) => (n.$id === updatedNote.$id ? updatedNote : n)));
  };

  const renderEmptyComponent = () => (
    <View style={styles.emptyContainer}>
      <Text style={styles.emptyText}>You don't have any notes yet.</Text>
      <Text style={styles.emptySubtext}>Tap the + button to create your first note!</Text>
    </View>
  );

  if (loading && notes.length === 0) {
    return <View style={styles.centered}><ActivityIndicator size="large" color="#007BFF" /></View>;
  }

  if (error && notes.length === 0) {
    return <View style={styles.centered}><Text style={styles.errorText}>{error}</Text></View>;
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>My Notes</Text>
        <TouchableOpacity style={styles.addButton} onPress={() => setAddModalVisible(true)}>
          <Text style={styles.addButtonText}>+ Add Note</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={notes}
        keyExtractor={(item) => item.$id}
        renderItem={({ item }) => (
          <NoteItem
            note={item}
            onNoteDeleted={handleNoteDeleted}
            onEdit={() => setEditingNote(item)}
          />
        )}
        contentContainerStyle={notes.length === 0 ? { flex: 1 } : {}}
        ListEmptyComponent={!loading && renderEmptyComponent()}
        refreshing={loading}
        onRefresh={fetchNotes}
      />

      <AddNoteModal
        visible={addModalVisible}
        onClose={() => setAddModalVisible(false)}
        onNoteAdded={handleNoteAdded}
        userId={user?.$id}
      />

      <EditNoteModal
        visible={!!editingNote}
        onClose={() => setEditingNote(null)}
        onNoteUpdated={handleNoteUpdated}
        note={editingNote}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#f5f5f5" },
  header: { flexDirection: "row", justifyContent: "space-between", alignItems: "center", padding: 16 },
  title: { fontSize: 24, fontWeight: "bold", color: "#333" },
  addButton: { backgroundColor: "#2196F3", paddingVertical: 8, paddingHorizontal: 12, borderRadius: 5 },
  addButtonText: { color: "white", fontWeight: "bold" },
  centered: { flex: 1, justifyContent: "center", alignItems: "center" },
  errorText: { color: "red", fontSize: 16, textAlign: "center" },
  emptyContainer: { flex: 1, justifyContent: "center", alignItems: "center", padding: 20 },
  emptyText: { fontSize: 18, fontWeight: "bold", marginBottom: 10 },
  emptySubtext: { fontSize: 16, color: "#666", textAlign: "center" },
});

export default NotesScreen;
