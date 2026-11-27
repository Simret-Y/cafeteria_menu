import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../providers/auth_providers.dart';

/// Prototype login screen.
///
/// NOTE: This is a temporary placeholder owned by the architecture lead so the
/// app can navigate end-to-end. Meresiet owns the real Login UI — replace the
/// body of this file when the real screen is ready.
///
/// Authentication here is prototype role selection only, NOT real auth.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cafeteria App',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Prototype sign-in — select a role',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _signIn(context, ref, UserRole.customer),
                icon: const Icon(Icons.restaurant),
                label: const Text('Continue as Customer'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _signIn(context, ref, UserRole.staff),
                icon: const Icon(Icons.badge),
                label: const Text('Continue as Staff'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () => _signIn(context, ref, UserRole.manager),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Continue as Manager'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go(AppRoutes.register),
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context, WidgetRef ref, UserRole role) {
    ref.read(authProvider.notifier).signIn(role);
    switch (role) {
      case UserRole.customer:
        context.go(AppRoutes.home);
      case UserRole.staff:
        context.go(AppRoutes.staffDashboard);
      case UserRole.manager:
        context.go(AppRoutes.managerDashboard);
    }
  }
}
