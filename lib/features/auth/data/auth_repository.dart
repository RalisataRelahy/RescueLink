import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:rescuelink/core/errors/app_exception.dart';
import 'package:rescuelink/features/auth/domain/user_profile_model.dart';

class AuthRepository {
  AuthRepository({supabase.SupabaseClient? client})
      : _supabase = client ?? supabase.Supabase.instance.client;

  final supabase.SupabaseClient _supabase;

  supabase.User? get currentUser => _supabase.auth.currentUser;
  Stream<supabase.AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<UserProfileModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw const AppAuthException('User authentication failed');

      return UserProfileModel(id: user.id, email: user.email ?? email);
    } on supabase.AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserProfileModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      final user = response.user;
      if (user == null) throw const AppAuthException('Registration failed');

      final profile = UserProfileModel(
        id: user.id,
        email: email,
        fullName: fullName,
      );

      try {
        await _supabase.from('profiles').insert(profile.toJson());
      } catch (_) {}

      return profile;
    } on supabase.AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
