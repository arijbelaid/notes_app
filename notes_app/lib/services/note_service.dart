import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../config/appwrite_config.dart';

class NoteService {
  late final Databases _databases;

  NoteService() {
    _databases = Databases(AppwriteConfig.client);
  }

  Future<List<Document>> getNotes({String? userId}) async {
    try {
      List<String> queries = [];
      if (userId != null) queries.add(Query.equal('user_id', userId));
      queries.add(Query.orderDesc('createdAt'));

      final response = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: queries,
      );
      return response.documents;
    } catch (e) {
      rethrow;
    }
  }

  Future<Document> createNote(Map<String, dynamic> data) async {
    try {
      final noteData = {
        ...data,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      return await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: ID.unique(),
        data: noteData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: noteId,
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      final noteData = { ...data, 'updatedAt': DateTime.now().toIso8601String() };
      return await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: noteId,
        data: noteData,
      );
    } catch (e) {
      rethrow;
    }
  }
}
