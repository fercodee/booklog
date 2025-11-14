import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/models/session_model.dart';
import '../../services/api/supabase_client.dart';

import '../../../utils/result.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository extends AuthRepository {
  SupabaseAuthRepository({SupabaseClientService? clientService}) : _service = clientService ?? SupabaseClientService();

  final SupabaseClientService _service;
  final _log = Logger('SupabaseAuthRepository');

  @override
  Future<Result<void>> signIn({required String email, required String password}) async {
    try {
      final res = await _service.signInWithPassword(email: email, password: password);
      final session = res.session;
      if (session == null) {
        return Result.error(Exception('Sign in failed: no session returned'));
      }
      notifyListeners();
      return const Result.ok(null);
    } on AuthException catch (e, st) {
      _log.warning('signIn failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('signIn unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> signUp({required String name, required String email, required String password}) async {
    try {
      // supabase_flutter: signUp takes email, password and optional userMetadata via 'data'
      final res = await _service.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      // Se houver sessão (email confirmation desabilitado), notifica
      if (res.session != null) {
        notifyListeners();
      }

      // If using email confirmation, user/session may be null; treat creation as success.
      return const Result.ok(null);
    } on AuthException catch (e, st) {
      _log.warning('signUp failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('signUp unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword({required String email}) async {
    try {
  await _service.resetPasswordForEmail(email);
  // If no exception, consider it successful.
      return const Result.ok(null);
    } on AuthException catch (e, st) {
      _log.warning('resetPassword failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('resetPassword unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _service.signOut();
      notifyListeners();
      return const Result.ok(null);
    } on AuthException catch (e, st) {
      _log.warning('signOut failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('signOut unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  UserModel? currentUser() => _service.currentUser;

  @override
  SessionModel? currentSession() => _service.currentSession;

  @override
  Future<Result<void>> updateUser({String? email, String? phone, String? password}) async {
    try {
  final attributes = UserAttributes(email: email, phone: phone, password: password);
      final res = await _service.updateUser(attributes);
      if (res == null) {
        return Result.error(Exception('updateUser failed: no user returned'));
      }
      return const Result.ok(null);
    } on AuthException catch (e, st) {
      _log.warning('updateUser failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('updateUser unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }
}
