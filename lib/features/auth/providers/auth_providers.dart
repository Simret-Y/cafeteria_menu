import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Prototype roles supported by the app.
///
/// NOTE: This is prototype role selection only — it is NOT real authentication.
/// Replace with a real auth provider (e.g. Firebase) in a later milestone.
enum UserRole { customer, staff, manager }

/// Immutable auth state for the prototype.
class AuthState {
  const AuthState({this.role});

  /// The currently selected role, or null when logged out.
  final UserRole? role;

  bool get isLoggedIn => role != null;

  AuthState copyWith({UserRole? role}) => AuthState(role: role ?? this.role);
}

/// Prototype auth notifier. Only tracks the selected role.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// "Signs in" by selecting a prototype role.
  void signIn(UserRole role) => state = AuthState(role: role);

  void signOut() => state = const AuthState();
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
