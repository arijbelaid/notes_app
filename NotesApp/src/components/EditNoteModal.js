import React, { useState, useEffect } from "react";
import { Modal, View, TextInput, StyleSheet, Text, TouchableOpacity } from "react-native";
import { updateNote } from "../services/note.service";

const EditNoteModal = ({ visible, onClose, onNoteUpdated, note }) => {
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (note) { setTitle(note.title || ""); setContent(note.content || ""); }
  }, [note]);

  const handleClose = () => { setError(null); onClose(); };

  const handleSave = async () => {
    if (!title.trim() || !content.trim()) { setError("Please fill in both title and content"); return; }
    try {
      setLoading(true);
      setError(null);
      const updatedNote = await updateNote(note.$id, { title: title.trim(), content: content.trim() });
      onClose();
      if (onNoteUpdated) onNoteUpdated(updatedNote);
    } catch (err) {
      setError("Failed to update note. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  if (!note) return null;

  return (
    <Modal visible={visible} animationType="slide" transparent={true} onRequestClose={handleClose}>
      <View style={styles.centeredView}>
        <View style={styles.modalView}>
          <Text style={styles.modalTitle}>Edit Note</Text>
          {error && <Text style={styles.errorText}>{error}</Text>}
          <TextInput style={styles.input} placeholder="Title" value={title} onChangeText={setTitle} />
          <TextInput style={[styles.input, styles.contentInput]} placeholder="Content" value={content} onChangeText={setContent} multiline={true} textAlignVertical="top" />
          <View style={styles.buttonContainer}>
            <TouchableOpacity style={[styles.button, styles.cancelButton]} onPress={handleClose} disabled={loading}>
              <Text style={styles.buttonText}>Cancel</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.button, styles.saveButton]} onPress={handleSave} disabled={loading}>
              <Text style={styles.buttonText}>{loading ? "Saving..." : "Save Changes"}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  centeredView: { flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "rgba(0,0,0,0.5)" },
  modalView: { width: "90%", backgroundColor: "white", borderRadius: 10, padding: 20, elevation: 5 },
  modalTitle: { fontSize: 18, fontWeight: "bold", marginBottom: 16, textAlign: "center" },
  input: { borderWidth: 1, borderColor: "#ddd", borderRadius: 5, padding: 10, marginBottom: 15 },
  contentInput: { height: 150 },
  buttonContainer: { flexDirection: "row", justifyContent: "space-between" },
  button: { borderRadius: 5, padding: 10, minWidth: "45%", alignItems: "center" },
  cancelButton: { backgroundColor: "#ccc" },
  saveButton: { backgroundColor: "#2196F3" },
  buttonText: { color: "white", fontWeight: "bold" },
  errorText: { color: "red", marginBottom: 10, textAlign: "center" },
});

export default EditNoteModal;
