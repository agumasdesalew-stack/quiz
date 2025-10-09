// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Sign up
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user != null) {
      // Insert profile
      await supabase.from('profiles').insert({
        'id': response.user!.id,
        'username': username,
        'email': email,
      });
      return UserModel(id: response.user!.id, username: username, email: email);
    }
    return null;
  }

  // Sign in
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user != null) {
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();
      return UserModel.fromMap(profile);
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Current user session
  Session? get currentSession => supabase.auth.currentSession;
  User? get currentUser => supabase.auth.currentUser;
}
