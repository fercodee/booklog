import 'package:flutter/material.dart';

import '../../ui/core/colors.dart';
import 'signup_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.viewModel});

  final SignUpViewModel viewModel;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmPasswordCtr = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Adiciona listener ao Command
    widget.viewModel.signUpCommand.addListener(_onSignUp);
  }

  @override
  void dispose() {
    // Remove listener e limpa controllers
    widget.viewModel.signUpCommand.removeListener(_onSignUp);
    _nameCtr.dispose();
    _emailCtr.dispose();
    _passwordCtr.dispose();
    _confirmPasswordCtr.dispose();
    super.dispose();
  }

  // Callback do listener
  void _onSignUp() {
    final cmd = widget.viewModel.signUpCommand;
    if (cmd.error) {
      final errorMsg = (cmd.result as dynamic).error?.toString() ?? 'Erro ao cadastrar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Navega de volta para login
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      // Atualiza os campos do ViewModel
      widget.viewModel.name = _nameCtr.text;
      widget.viewModel.email = _emailCtr.text;
      widget.viewModel.password = _passwordCtr.text;
      widget.viewModel.confirmPassword = _confirmPasswordCtr.text;

      // Executa o command
      widget.viewModel.signUpCommand.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const SizedBox(height: 16),
              const Icon(
                Icons.person_add,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Crie sua Conta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha os dados abaixo para se cadastrar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Campo Nome
              TextFormField(
                controller: _nameCtr,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  hintText: 'Seu nome completo',
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (value.length < 3) {
                    return 'Nome deve ter no mínimo 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

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
                  hintText: 'Crie uma senha segura',
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
                  if (value.length < 6) {
                    return 'Senha deve ter no mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Confirmar Senha
              TextFormField(
                controller: _confirmPasswordCtr,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  hintText: 'Confirme sua senha',
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmação de senha é obrigatória';
                  }
                  if (value != _passwordCtr.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botão de Cadastro
              ElevatedButton.icon(
                onPressed: widget.viewModel.signUpCommand.running
                    ? null
                    : _handleSignUp,
                icon: widget.viewModel.signUpCommand.running
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
                    : const Icon(Icons.app_registration),
                label: Text(
                  widget.viewModel.signUpCommand.running
                      ? 'Cadastrando...'
                      : 'Criar Conta',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Link para Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem uma conta? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Faça Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
