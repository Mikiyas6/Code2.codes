import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print("✅ Signed in: ${response.user!.email}");
      }

      return response;
    } catch (e) {
      print("❌ Email sign-in error: $e");
      return null;
    }
  }

  // Register with email and password
  Future<AuthResponse?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      final userEmail = response.user?.email;

      if (userId != null && userEmail != null) {
        await _insertUserIfNotExists(userId, userEmail);
        print("✅ User registered and added to 'profiles' table.");
      } else {
        print(
          "⚠️ Sign-up succeeded, but user is null (awaiting email verification?).",
        );
      }

      return response;
    } catch (e) {
      print("❌ Email registration error: $e");
      return null;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://yourdomain.com/login-callback', // must be http(s)
      );
      print("✅ Google sign-in initiated");
    } catch (e) {
      print("❌ Google sign-in error: $e");
    }
  }

  // Sign in with GitHub
  Future<void> signInWithGitHub() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'https://yourdomain.com/login-callback',
      );
      print("✅ GitHub sign-in initiated");
    } catch (e) {
      print("❌ GitHub sign-in error: $e");
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      print("✅ Password reset email sent");
      return true;
    } catch (e) {
      print("❌ Password reset error: $e");
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print("✅ Signed out");
    } catch (e) {
      print("❌ Sign-out error: $e");
    }
  }

  // Listen once to auth state change for OAuth sign-ins
  void setupAuthStateListener() {
    _supabase.auth.onAuthStateChange.listen((event) async {
      final user = event.session?.user;
      if (user != null) {
        await _insertUserIfNotExists(user.id, user.email ?? '');
      }
    });
  }

  // Insert user into 'profiles' table if not already there
  Future<void> _insertUserIfNotExists(String id, String email) async {
    try {
      final existing = await _supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (existing == null) {
        await _supabase.from('profiles').insert({
          'id': id,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });
        print("✅ Inserted user into 'profiles'.");
      } else {
        print("ℹ️ User already exists in 'profiles'.");
      }
    } catch (e) {
      print("❌ Error inserting user into 'profiles': $e");
    }
  }
}
