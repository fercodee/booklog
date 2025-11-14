import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../../ui/core/colors.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Adiciona listeners aos Commands do ViewModel
    widget.viewModel.signInCommand.addListener(_onSignIn);
    widget.viewModel.resetPasswordCommand.addListener(_onResetPassword);
  }

  @override
  void dispose() {
    // Remove listeners e limpa controllers
    widget.viewModel.signInCommand.removeListener(_onSignIn);
    widget.viewModel.resetPasswordCommand.removeListener(_onResetPassword);
    _emailCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  // Callbacks dos listeners
  void _onSignIn() {
    final cmd = widget.viewModel.signInCommand;
    if (cmd.error) {
      final errorMsg = (cmd.result as dynamic).error?.toString() ?? 'Erro ao fazer login';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Redirecionamento é feito automaticamente pelo GoRouter
    }
  }

  void _onResetPassword() {
    final cmd = widget.viewModel.resetPasswordCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro ao recuperar senha'),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail de recuperação enviado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.viewModel.email = _emailCtr.text;
      widget.viewModel.password = _passwordCtr.text;
      widget.viewModel.signInCommand.execute();
    }
  }

  void _showResetPasswordDialog() {
    final resetFormKey = GlobalKey<FormState>();
    final emailCtr = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Recuperar Senha'),
          content: Form(
            key: resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailCtr,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (resetFormKey.currentState?.validate() ?? false) {
                  widget.viewModel.email = emailCtr.text;
                  widget.viewModel.resetPasswordCommand.execute();
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Log'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const SizedBox(height: 32),
              const Icon(
                Icons.library_books,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Bem-vindo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Faça login para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Campo Email
              TextFormField(
                controller: _emailCtr,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'seu.email@exemplo.com',
                  prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Senha
              TextFormField(
                controller: _passwordCtr,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Sua senha',
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Link para recuperar senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showResetPasswordDialog,
                  child: const Text('Esqueceu a senha?'),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de Login
              ElevatedButton.icon(
                onPressed: widget.viewModel.signInCommand.running
                    ? null
                    : _handleSignIn,
                icon: widget.viewModel.signInCommand.running
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.textOnPrimary,
                          ),
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  widget.viewModel.signInCommand.running
                      ? 'Entrando...'
                      : 'Entrar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Divisor
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: TextStyle(
                        color: AppColors.gray500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 24),

              // Link para Cadastro
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.signup),
                icon: const Icon(Icons.person_add),
                label: const Text(
                  'Criar nova conta',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Texto adicional
              Center(
                child: Text(
                  'Não tem uma conta? Clique em "Criar nova conta"',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
