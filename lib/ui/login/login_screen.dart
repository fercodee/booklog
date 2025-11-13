import 'package:flutter/material.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  // Agora recebe o viewModel conforme convenção
  final LoginViewModel viewModel;
  const LoginScreen({super.key, required this.viewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // Adiciona listeners aos Commands do ViewModel
    widget.viewModel.signInCommand.addListener(_onSignIn);
    widget.viewModel.signUpCommand.addListener(_onSignUp);
    widget.viewModel.resetPasswordCommand.addListener(_onResetPassword);
  }

  @override
  void dispose() {
    // Remove listeners e limpa controllers
    widget.viewModel.signInCommand.removeListener(_onSignIn);
    widget.viewModel.signUpCommand.removeListener(_onSignUp);
    widget.viewModel.resetPasswordCommand.removeListener(_onResetPassword);
    _emailCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  // Callbacks dos listeners — reagem ao estado dos Commands
  void _onSignIn() {
    final cmd = widget.viewModel.signInCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao logar')),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso')),
      );
      // TODO: navegar para a tela principal após login
    }
  }

  void _onSignUp() {
    final cmd = widget.viewModel.signUpCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar')),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso')),
      );
      Navigator.of(context).pop(); // fecha o diálogo de cadastro
    }
  }

  void _onResetPassword() {
    final cmd = widget.viewModel.resetPasswordCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar e-mail de recuperação')),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de recuperação enviado')),
      );
      Navigator.of(context).pop(); // fecha o diálogo de recuperação
    }
  }

  void _showSignUpDialog() {
    final signupFormKey = GlobalKey<FormState>();
    final nameCtr = TextEditingController();
    final emailCtr = TextEditingController();
    final passwordCtr = TextEditingController();
    final confirmCtr = TextEditingController();
    bool obscureSignup = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setStateDialog) {
          return AlertDialog(
            title: const Text('Cadastrar usuário'),
            content: SingleChildScrollView(
              child: Form(
                key: signupFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtr,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Informe o nome' : null,
                    ),
                    TextFormField(
                      controller: emailCtr,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Informe o e-mail';
                        if (!s.contains('@')) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordCtr,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(obscureSignup ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setStateDialog(() => obscureSignup = !obscureSignup),
                        ),
                      ),
                      obscureText: obscureSignup,
                      validator: (v) => (v ?? '').length < 6 ? 'Senha mínima 6 caracteres' : null,
                    ),
                    TextFormField(
                      controller: confirmCtr,
                      decoration: const InputDecoration(labelText: 'Confirmar senha'),
                      obscureText: obscureSignup,
                      validator: (v) => v != passwordCtr.text ? 'Senhas não coincidem' : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (signupFormKey.currentState!.validate()) {
                    // Preenche o ViewModel e executa o Command
                    widget.viewModel.name = nameCtr.text.trim();
                    widget.viewModel.email = emailCtr.text.trim();
                    widget.viewModel.password = passwordCtr.text;
                    widget.viewModel.signUpCommand.execute();
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showForgotPasswordDialog() {
    final emailResetCtr = TextEditingController();
    final formResetKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar senha'),
        content: Form(
          key: formResetKey,
          child: TextFormField(
            controller: emailResetCtr,
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (v) {
              final s = (v ?? '').trim();
              if (s.isEmpty) return 'Informe o e-mail';
              if (!s.contains('@')) return 'E-mail inválido';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (!formResetKey.currentState!.validate()) return;
              widget.viewModel.email = emailResetCtr.text.trim();
              widget.viewModel.resetPasswordCommand.execute();
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailCtr,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Informe o e-mail';
                        if (!s.contains('@')) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordCtr,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      obscureText: _obscure,
                      validator: (v) => (v ?? '').isEmpty ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedBuilder(
                        // Observa o ViewModel para atualizar o estado do botão
                        animation: widget.viewModel,
                        builder: (context, _) {
                          final running = widget.viewModel.signInCommand.running;
                          return ElevatedButton(
                            onPressed: running
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) return;
                                    widget.viewModel.email = _emailCtr.text.trim();
                                    widget.viewModel.password = _passwordCtr.text;
                                    widget.viewModel.signInCommand.execute();
                                  },
                            child: running
                                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Entrar'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: _showSignUpDialog, child: const Text('Cadastrar')),
                        TextButton(onPressed: _showForgotPasswordDialog, child: const Text('Esqueci minha senha')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
