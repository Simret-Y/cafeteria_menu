import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/validators/form_validators.dart';
import '../providers/auth_providers.dart';

/// Customer, staff, and manager login screen with form validation and
/// prototype role-selection shortcuts.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final selectedRole = ref.watch(selectedLoginRoleProvider);
    final obscurePassword = ref.watch(loginObscurePasswordProvider);
    final theme = Theme.of(context);
    final compactTonalStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 38),
      padding: const EdgeInsets.symmetric(horizontal: 12),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_cafe,
                          size: 30,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cafeteria App',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (authState.errorMessage != null) ...[
                      Card(
                        color: theme.colorScheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(
                      key: const ValueKey('login_email_field'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'customer@cafeteria.local',
                        prefixIcon: Icon(Icons.email_outlined),
                        isDense: true,
                      ),
                      validator: FormValidators.email,
                      onChanged: (_) =>
                          ref.read(authProvider.notifier).clearError(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      key: const ValueKey('login_password_field'),
                      controller: _passwordController,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        isDense: true,
                        suffixIcon: IconButton(
                          onPressed: () => ref
                              .read(loginObscurePasswordProvider.notifier)
                              .toggle(),
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          tooltip: obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                        ),
                      ),
                      validator: FormValidators.password,
                      onChanged: (_) =>
                          ref.read(authProvider.notifier).clearError(),
                      onFieldSubmitted: (_) => _submitForm(selectedRole),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<UserRole>(
                      segments: [
                        for (final role in UserRole.values)
                          ButtonSegment<UserRole>(
                            value: role,
                            label: Text(role.label),
                          ),
                      ],
                      selected: {selectedRole},
                      onSelectionChanged: (selection) {
                        ref
                            .read(selectedLoginRoleProvider.notifier)
                            .select(selection.first);
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      key: const ValueKey('login_submit_button'),
                      onPressed: () => _submitForm(selectedRole),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: const Text("Don't have an account? Register"),
                    ),
                    const Divider(height: 16),
                    Text(
                      'Prototype Demo Access',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.tonalIcon(
                          style: compactTonalStyle,
                          onPressed: () => _demoSignIn(UserRole.customer),
                          icon: const Icon(Icons.restaurant, size: 18),
                          label: const Text('Continue as Customer'),
                        ),
                        FilledButton.tonalIcon(
                          style: compactTonalStyle,
                          onPressed: () => _demoSignIn(UserRole.staff),
                          icon: const Icon(Icons.badge, size: 18),
                          label: const Text('Continue as Staff'),
                        ),
                        FilledButton.tonalIcon(
                          style: compactTonalStyle,
                          onPressed: () => _demoSignIn(UserRole.manager),
                          icon: const Icon(
                            Icons.admin_panel_settings,
                            size: 18,
                          ),
                          label: const Text('Continue as Manager'),
                        ),
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

  void _submitForm(UserRole role) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success = ref
        .read(authProvider.notifier)
        .loginWithCredentials(
          email: _emailController.text,
          password: _passwordController.text,
          role: role,
        );
    if (!success) return;

    final signedInRole = ref.read(authProvider).role ?? role;
    _navigateForRole(signedInRole);
  }

  void _demoSignIn(UserRole role) {
    ref.read(authProvider.notifier).signIn(role);
    _navigateForRole(role);
  }

  void _navigateForRole(UserRole role) {
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
