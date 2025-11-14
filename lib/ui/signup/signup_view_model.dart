import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../data/repositories/auth/auth_repository.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel({
    required AuthRepository repository,
  }) : _repository = repository {
    // Inicializa os Commands apontando para as ações privadas
    signUpCommand = Command0(_signUp);
  }

  final AuthRepository _repository;
  final _log = Logger('SignUpViewModel');

  // Campos públicos usados pela UI antes de executar o Command
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  // Command público
  late Command0<void> signUpCommand;

  // Ação privada para o Command
  Future<Result<void>> _signUp() async {
    try {
      // Validações básicas
      if (name == null || name!.isEmpty) {
        return Result.error(Exception('Nome é obrigatório'));
      }
      if (email == null || email!.isEmpty) {
        return Result.error(Exception('Email é obrigatório'));
      }
      if (password == null || password!.isEmpty) {
        return Result.error(Exception('Senha é obrigatória'));
      }
      if (password != confirmPassword) {
        return Result.error(Exception('As senhas não correspondem'));
      }
      if (password!.length < 6) {
        return Result.error(Exception('A senha deve ter pelo menos 6 caracteres'));
      }

      // Chama o repositório para cadastro
      final result = await _repository.signUp(
        name: name!,
        email: email!,
        password: password!,
      );

      if (result is Error<void>) {
        return result;
      }

      _log.info('Cadastro realizado com sucesso para: $email');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro inesperado ao cadastrar', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}
