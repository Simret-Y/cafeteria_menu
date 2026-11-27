import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/validators/form_validators.dart';
import '../providers/auth_providers.dart';

/// Registration screen with form validation and prototype role assignment.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final selectedRole = ref.watch(selectedRegisterRoleProvider);
    final obscurePassword = ref.watch(registerObscurePasswordProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create Account',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Register to browse meals and place orders in advance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (authState.errorMessage != null) ...[
                      Card(
                        color: theme.colorScheme.errorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            authState.errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      key: const ValueKey('register_name_field'),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: FormValidators.fullName,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('register_email_field'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: FormValidators.email,
                      onChanged: (_) =>
                          ref.read(authProvider.notifier).clearError(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('register_password_field'),
                      controller: _passwordController,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => ref
                              .read(registerObscurePasswordProvider.notifier)
                              .toggle(),
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: FormValidators.password,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('register_confirm_password_field'),
                      controller: _confirmPasswordController,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_reset_outlined),
                      ),
                      validator: (value) => FormValidators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                      onFieldSubmitted: (_) => _submit(selectedRole),
                    ),
                    const SizedBox(height: 16),
                    Text('Account Role', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 8),
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
                            .read(selectedRegisterRoleProvider.notifier)
                            .select(selection.first);
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const ValueKey('register_submit_button'),
                      onPressed: () => _submit(selectedRole),
                      child: const Text('Register Account'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Back to Login'),
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

  void _submit(UserRole role) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final success = ref
        .read(authProvider.notifier)
        .registerAccount(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: role,
        );
    if (!success) return;

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
