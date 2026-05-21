import React, { useState } from "react";
import { View, Text, StyleSheet, TouchableOpacity, Alert } from "react-native";
import { deleteNote } from "../services/note.service";

const NoteItem = ({ note, onNoteDeleted, onEdit }) => {
  const [deleting, setDeleting] = useState(false);

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const handleDelete = () => {
    Alert.alert("Delete Note", "Are you sure you want to delete this note?", [
      { text: "Cancel", style: "cancel" },
      {
        text: "Delete",
        style: "destructive",
        onPress: async () => {
          try {
            setDeleting(true);
            await deleteNote(note.$id);
            if (onNoteDeleted) onNoteDeleted(note.$id);
          } catch (error) {
            Alert.alert("Error", "Failed to delete note. Please try again.");
          } finally {
            setDeleting(false);
          }
        },
      },
    ]);
  };

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>{note.title}</Text>
        <Text style={styles.date}>Last updated: {formatDate(note.updatedAt)}</Text>
        <Text style={styles.noteContent} numberOfLines={3}>{note.content}</Text>
      </View>
      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.editButton} onPress={() => onEdit(note)}>
          <Text style={styles.editText}>Edit</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.deleteButton} onPress={handleDelete} disabled={deleting}>
          <Text style={styles.deleteText}>{deleting ? "..." : "Delete"}</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: { backgroundColor: "white", borderRadius: 8, padding: 16, marginHorizontal: 16, marginBottom: 12, shadowColor: "#000", shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.2, shadowRadius: 2, elevation: 2 },
  content: { flex: 1 },
  title: { fontSize: 18, fontWeight: "bold", marginBottom: 4 },
  date: { fontSize: 12, color: "#666", marginBottom: 8 },
  noteContent: { fontSize: 14, color: "#333" },
  buttonContainer: { flexDirection: "row", justifyContent: "flex-end", marginTop: 12, borderTopWidth: 1, borderTopColor: "#eee", paddingTop: 8 },
  editButton: { marginRight: 16 },
  editText: { color: "#2196F3", fontWeight: "500" },
  deleteButton: {},
  deleteText: { color: "red", fontWeight: "500" },
});

export default NoteItem;
