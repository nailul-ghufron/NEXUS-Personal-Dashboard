import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  Future<AuthResponse> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> updateAvatar(String filePath);
}
