import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  @override
  Future<void> updateAvatar(String filePath) async {
    final user = currentUser;
    if (user == null) return;

    final file = File(filePath);
    final fileExt = filePath.split('.').last;
    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final path = 'avatars/$fileName';

    // Upload image to storage
    await _client.storage.from('profiles').upload(path, file);
    
    // Get public URL
    final imageUrl = _client.storage.from('profiles').getPublicUrl(path);

    // Update user metadata
    await _client.auth.updateUser(
      UserAttributes(
        data: {'avatar_url': imageUrl},
      ),
    );
  }
}
