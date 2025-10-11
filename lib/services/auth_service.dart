import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Sign up with username, email, and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        print('Sign-up failed: No user returned');
        return null;
      }

      // Insert profile
      try {
        await supabase.from('profiles').insert({
          'id': response.user!.id,
          'username': username,
          'email': email,
        });
      } catch (e) {
        print('Profile insert error: $e');
        return null;
      }

      return UserModel(id: response.user!.id, username: username, email: email);
    } catch (e) {
      print('Sign-up error: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        print('Sign-in failed: No user returned');
        return null;
      }

      try {
        final profile = await supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();
        return UserModel.fromMap(profile);
      } catch (e) {
        print('Profile fetch error: $e');
        // Create profile if it doesn't exist
        final defaultUsername = response.user!.email!.split('@')[0];
        await supabase.from('profiles').insert({
          'id': response.user!.id,
          'username': defaultUsername,
          'email': response.user!.email,
        });
        return UserModel(
          id: response.user!.id,
          username: defaultUsername,
          email: response.user!.email!,
        );
      }
    } on AuthException catch (e) {
      print('Sign-in error: ${e.message}, code: ${e.code}');
      return null;
    } catch (e) {
      print('Unexpected sign-in error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Sign-out error: $e');
    }
  }

  // Current user session
  Session? get currentSession => supabase.auth.currentSession;
  User? get currentUser => supabase.auth.currentUser;
}
