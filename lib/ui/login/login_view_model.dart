import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
// ...existing code...
// Ajuste os imports abaixo conforme sua estrutura (utils/command.dart e utils/result.dart fazem parte da convenção)
import '../../utils/command.dart';
import '../../utils/result.dart';
import '../../data/auth_repository.dart'; // ...existing code...

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AuthRepository repository,
  }) : _repository = repository {
    // Inicializa os Commands apontando para as ações privadas
    signInCommand = Command0(_signIn);
    signUpCommand = Command0(_signUp);
    resetPasswordCommand = Command0(_resetPassword);
  }

  final AuthRepository _repository;
  final _log = Logger('LoginViewModel');

  // Campos públicos usados pela UI antes de executar os Commands
  String? name;
  String? email;
  String? password;

  // Commands públicos
  late Command0<void> signInCommand;
  late Command0<void> signUpCommand;
  late Command0<void> resetPasswordCommand;

  // Ações privadas (stubs) — TODO: implementar integração com Supabase/AuthRepository
  Future<Result<void>> _signIn() async {
    try {
      // TODO: usar _repository para autenticar com email/password
      return Result.error(Exception('Not implemented'));
    } catch (e, stack) {
      _log.severe('Erro em _signIn', e, stack);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _signUp() async {
    try {
      // TODO: criar usuário via _repository usando name, email, password
      return Result.error(Exception('Not implemented'));
    } catch (e, stack) {
      _log.severe('Erro em _signUp', e, stack);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _resetPassword() async {
    try {
      // TODO: solicitar reset de senha via _repository usando email
      return Result.error(Exception('Not implemented'));
    } catch (e, stack) {
      _log.severe('Erro em _resetPassword', e, stack);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}