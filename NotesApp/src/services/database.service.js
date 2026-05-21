import { Databases, Query } from "appwrite";
import client from "../config/appwrite";
import { APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID } from "@env";

const databases = new Databases(client);

export const listDocuments = async (queries = []) => {
  try {
    const response = await databases.listDocuments(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID,
      queries
    );
    return response.documents;
  } catch (error) {
    console.error("Error listing documents:", error);
    throw error;
  }
};

export default databases;
