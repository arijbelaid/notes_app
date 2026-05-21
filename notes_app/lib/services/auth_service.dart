import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../config/appwrite_config.dart';

class AuthService {
  late final Account account;

  AuthService() {
    account = Account(AppwriteConfig.client);
  }

  Future<Session> createAccount(String email, String password, String name) async {
    try {
      final user = await account.create(
        userId: ID.unique(), email: email, password: password, name: name,
      );
      if (user.$id.isNotEmpty) {
        return login(email, password);
      } else {
        throw Exception('Failed to create account');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Session> login(String email, String password) async {
    try {
      return await account.createEmailPasswordSession(email: email, password: password);
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return await account.get();
    } catch (error) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (error) {
      rethrow;
    }
  }
}
