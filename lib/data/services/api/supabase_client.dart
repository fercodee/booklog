import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/auth_response_model.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/models/session_model.dart';
import '../model/auth_response_mapper.dart';

/// Lightweight wrapper around `Supabase.instance.client` to centralize
/// Supabase access and make it injectable for testing.
class SupabaseClientService {
  SupabaseClientService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  /// Get the client, ensuring Supabase is initialized
  SupabaseClient get client {
    if (_client != null) return _client;
    if (!Supabase.instance.isInitialized) {
      throw StateError('Supabase must be initialized before accessing the client');
    }
    return Supabase.instance.client;
  }

  // Auth API surface used by AuthRepository, but returning domain models.
  Future<AuthResponseModel> signInWithPassword({required String email, required String password}) async {
    final res = await client.auth.signInWithPassword(email: email, password: password);
    return AuthResponseMapper.fromSupabase(res);
  }

  Future<AuthResponseModel> signUp({required String email, required String password, Map<String, dynamic>? data}) async {
    final res = await client.auth.signUp(email: email, password: password, data: data);
    return AuthResponseMapper.fromSupabase(res);
  }

  Future<void> resetPasswordForEmail(String email) => client.auth.resetPasswordForEmail(email);

  Future<void> signOut() => client.auth.signOut();

  UserModel? get currentUser {
    final u = client.auth.currentUser;
    if (u == null) return null;
    return AuthResponseMapper.mapUser(u);
  }

  SessionModel? get currentSession {
    final s = client.auth.currentSession;
    if (s == null) return null;
    return AuthResponseMapper.mapSession(s);
  }

  Future<UserModel?> updateUser(UserAttributes attributes) async {
    final res = await client.auth.updateUser(attributes);
    if (res.user == null) return null;
    return AuthResponseMapper.mapUser(res.user);
  }
}
