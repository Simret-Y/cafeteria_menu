import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// Display label helper for Simret's [UserRole] enum without modifying
/// `auth_providers.dart`.
String userRoleLabel(UserRole role) {
  switch (role) {
    case UserRole.customer:
      return 'Customer';
    case UserRole.staff:
      return 'Staff';
    case UserRole.manager:
      return 'Manager';
  }
}

/// Customer-facing UI display name kept separate from Simret's [AuthState].
///
/// Used for the Customer Home greeting and Checkout name prefill during
/// prototype flows until real user profiles are integrated in Milestone 2.
class CustomerDisplayNameNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setName(String name) {
    final trimmed = name.trim();
    state = trimmed.isEmpty ? null : trimmed;
  }

  void setFromEmail(String email) {
    final localPart = email.trim().split('@').first;
    final words = localPart
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .toList();
    state = words.isEmpty ? null : words.join(' ');
  }

  void clear() => state = null;
}

final customerDisplayNameProvider =
    NotifierProvider<CustomerDisplayNameNotifier, String?>(
      CustomerDisplayNameNotifier.new,
    );

/// Selected role in the Login form UI.
class SelectedLoginRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.customer;

  void select(UserRole role) => state = role;
}

final selectedLoginRoleProvider =
    NotifierProvider<SelectedLoginRoleNotifier, UserRole>(
      SelectedLoginRoleNotifier.new,
    );

/// Selected role in the Registration form UI.
class SelectedRegisterRoleNotifier extends Notifier<UserRole> {
  @override
  UserRole build() => UserRole.customer;

  void select(UserRole role) => state = role;
}

final selectedRegisterRoleProvider =
    NotifierProvider<SelectedRegisterRoleNotifier, UserRole>(
      SelectedRegisterRoleNotifier.new,
    );

/// Password visibility toggle for the Login form UI.
class LoginObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final loginObscurePasswordProvider =
    NotifierProvider<LoginObscurePasswordNotifier, bool>(
      LoginObscurePasswordNotifier.new,
    );

/// Password visibility toggle for the Registration form UI.
class RegisterObscurePasswordNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final registerObscurePasswordProvider =
    NotifierProvider<RegisterObscurePasswordNotifier, bool>(
      RegisterObscurePasswordNotifier.new,
    );
