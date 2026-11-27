import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/in_memory_auth_repository.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.freezed.dart';

/// Prototype roles supported by the app.
///
/// NOTE: This is prototype role selection and in-memory account handling only —
/// replace with Firebase Authentication in Milestone 2.
enum UserRole {
  customer('Customer'),
  staff('Staff'),
  manager('Manager');

  const UserRole(this.label);

  final String label;
}

/// Immutable auth state for the prototype.
@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    UserRole? role,
    AuthUser? currentUser,
    String? errorMessage,
  }) = _AuthState;

  bool get isLoggedIn => role != null;
}

/// Provides the prototype authentication repository.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => InMemoryAuthRepository(),
);

/// Prototype auth notifier managing role selection, login, and registration.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Signs in using a quick demo role selection.
  void signIn(UserRole role) {
    final user = ref.read(authRepositoryProvider).demoUserForRole(role);
    state = AuthState(role: role, currentUser: user);
  }

  /// Signs in with validated email and password credentials.
  bool loginWithCredentials({
    required String email,
    required String password,
    UserRole? role,
  }) {
    try {
      final user = ref
          .read(authRepositoryProvider)
          .authenticate(email: email, password: password, role: role);
      state = AuthState(role: user.role, currentUser: user);
      return true;
    } on ArgumentError catch (error) {
      state = state.copyWith(errorMessage: error.message.toString());
      return false;
    }
  }

  /// Registers a new prototype account and signs the user in.
  bool registerAccount({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.customer,
  }) {
    try {
      final user = ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password, role: role);
      state = AuthState(role: user.role, currentUser: user);
      return true;
    } on ArgumentError catch (error) {
      state = state.copyWith(errorMessage: error.message.toString());
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void signOut() => state = const AuthState();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Selected role in the Login form.
class SelectedLoginRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.customer;

  void select(UserRole role) => state = role;
}

final selectedLoginRoleProvider =
    NotifierProvider<SelectedLoginRoleNotifier, UserRole>(
      SelectedLoginRoleNotifier.new,
    );

/// Selected role in the Registration form.
class SelectedRegisterRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.customer;

  void select(UserRole role) => state = role;
}

final selectedRegisterRoleProvider =
    NotifierProvider<SelectedRegisterRoleNotifier, UserRole>(
      SelectedRegisterRoleNotifier.new,
    );

/// Password visibility toggle for the Login screen.
class LoginObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final loginObscurePasswordProvider =
    NotifierProvider<LoginObscurePasswordNotifier, bool>(
      LoginObscurePasswordNotifier.new,
    );

/// Password visibility toggle for the Registration screen.
class RegisterObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final registerObscurePasswordProvider =
    NotifierProvider<RegisterObscurePasswordNotifier, bool>(
      RegisterObscurePasswordNotifier.new,
    );
