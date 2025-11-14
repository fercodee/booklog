import 'package:flutter/foundation.dart';

import '../../../utils/result.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/models/session_model.dart';

/// Abstração para autenticação. Implementações podem usar Supabase, mocks, etc.
/// Estende [ChangeNotifier] para permitir redirecionamento automático no GoRouter.
abstract class AuthRepository extends ChangeNotifier {
  /// Autentica um usuário com email e password.
  Future<Result<void>> signIn({required String email, required String password});

  /// Cria um novo usuário. [name] será salvo como user metadata quando possível.
  Future<Result<void>> signUp({required String name, required String email, required String password});

  /// Solicita envio de e-mail para reset de senha.
  Future<Result<void>> resetPassword({required String email});

  /// Desloga o usuário atual.
  Future<Result<void>> signOut();

  /// Usuário atual (pode ser null).
  UserModel? currentUser();

  /// Sessão atual (pode ser null).
  SessionModel? currentSession();

  /// Atualiza campos do usuário autenticado (email, phone, password são opcionais).
  Future<Result<void>> updateUser({String? email, String? phone, String? password});
}
