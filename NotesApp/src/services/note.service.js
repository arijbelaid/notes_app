import { Databases, ID, Query } from "appwrite";
import client from "../config/appwrite";
import { APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID } from "@env";

const databases = new Databases(client);

export const getNotes = async (userId = null) => {
  try {
    const queries = [];
    if (userId) {
      queries.push(Query.equal("user_id", userId));
    }
    queries.push(Query.orderDesc("createdAt"));
    const response = await databases.listDocuments(APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID, queries);
    return response.documents;
  } catch (error) {
    console.error("Error getting notes:", error);
    throw error;
  }
};

export const createNote = async (data) => {
  try {
    const noteData = {
      ...data,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    const response = await databases.createDocument(
      APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID, ID.unique(), noteData
    );
    return response;
  } catch (error) {
    console.error("Error creating note:", error);
    throw error;
  }
};

export const deleteNote = async (noteId) => {
  try {
    await databases.deleteDocument(APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID, noteId);
    return true;
  } catch (error) {
    console.error("Error deleting note:", error);
    throw error;
  }
};

export const updateNote = async (noteId, data) => {
  try {
    const noteData = { ...data, updatedAt: new Date().toISOString() };
    const response = await databases.updateDocument(
      APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID, noteId, noteData
    );
    return response;
  } catch (error) {
    console.error("Error updating note:", error);
    throw error;
  }
};
