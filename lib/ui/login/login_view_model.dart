import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
// ...existing code...
// Ajuste os imports abaixo conforme sua estrutura (utils/command.dart e utils/result.dart fazem parte da convenção)
import '../../utils/command.dart';
import '../../utils/result.dart';
import '../../data/repositories/auth/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AuthRepository repository,
  }) : _repository = repository {
    // Inicializa os Commands apontando para as ações privadas
    signInCommand = Command0(_signIn);
    resetPasswordCommand = Command0(_resetPassword);
  }

  final AuthRepository _repository;
  final _log = Logger('LoginViewModel');

  // Campos públicos usados pela UI antes de executar os Commands
  String? email;
  String? password;

  // Commands públicos
  late Command0<void> signInCommand;
  late Command0<void> resetPasswordCommand;

  // Ações privadas — integração com Supabase/AuthRepository
  Future<Result<void>> _signIn() async {
    try {
      if (email == null || email!.isEmpty) {
        return Result.error(Exception('Email é obrigatório'));
      }
      if (password == null || password!.isEmpty) {
        return Result.error(Exception('Senha é obrigatória'));
      }

      // Autentica com email/password usando o repositório
      final result = await _repository.signIn(
        email: email!,
        password: password!,
      );

      if (result is Error<void>) {
        return result;
      }

      _log.info('Login realizado com sucesso para: $email');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro em _signIn', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _resetPassword() async {
    try {
      if (email == null || email!.isEmpty) {
        return Result.error(Exception('Email é obrigatório'));
      }

      // Solicita reset de senha via _repository
      final result = await _repository.resetPassword(email: email!);

      if (result is Error<void>) {
        return result;
      }

      _log.info('Email de recuperação enviado para: $email');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro em _resetPassword', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}