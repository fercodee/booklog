import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../ui/login/login_screen.dart';
import '../../ui/login/login_view_model.dart';
import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(AuthRepository authRepository) => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginScreen(
              viewModel: LoginViewModel(
                repository: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            // TODO: Implement HomeScreen
            return Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
              ),
              body: const Center(
                child: Text('Home Screen - Coming Soon'),
              ),
            );
          },
        ),
      ],
    );

/// Redirect logic based on authentication state.
/// 
/// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final authRepository = context.read<AuthRepository>();
  final loggedIn = authRepository.currentSession() != null;
  final loggingIn = state.matchedLocation == Routes.login;

  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
