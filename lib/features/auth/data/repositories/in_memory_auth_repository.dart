import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/providers/auth_providers.dart';

/// In-memory prototype implementation of [AuthRepository].
class InMemoryAuthRepository implements AuthRepository {
  final List<AuthUser> _users = [
    const AuthUser(
      id: 'user-customer-1',
      name: 'Henok Tadesse',
      email: 'customer@cafeteria.local',
      role: UserRole.customer,
      password: 'password123',
    ),
    const AuthUser(
      id: 'user-staff-1',
      name: 'Selamawit Bekele',
      email: 'staff@cafeteria.local',
      role: UserRole.staff,
      password: 'password123',
    ),
    const AuthUser(
      id: 'user-manager-1',
      name: 'Abebe Kebede',
      email: 'manager@cafeteria.local',
      role: UserRole.manager,
      password: 'password123',
    ),
  ];

  @override
  AuthUser? findByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email.toLowerCase() == normalized) {
        return user;
      }
    }
    return null;
  }

  @override
  AuthUser authenticate({
    required String email,
    required String password,
    UserRole? role,
  }) {
    final normalized = email.trim().toLowerCase();
    final existing = findByEmail(normalized);
    if (existing != null) {
      if (existing.password != password) {
        throw ArgumentError('Incorrect password for $normalized');
      }
      if (role != null && existing.role != role) {
        return existing.copyWith(role: role);
      }
      return existing;
    }

    // Prototype fallback: allow newly entered valid credentials to sign in.
    final fallbackName = normalized.split('@').first;
    final displayName = fallbackName.isEmpty
        ? 'Customer'
        : '${fallbackName[0].toUpperCase()}${fallbackName.substring(1)}';
    final created = AuthUser(
      id: 'user-${_users.length + 1}',
      name: displayName,
      email: normalized,
      role: role ?? UserRole.customer,
      password: password,
    );
    _users.add(created);
    return created;
  }

  @override
  AuthUser register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) {
    final normalized = email.trim().toLowerCase();
    if (findByEmail(normalized) != null) {
      throw ArgumentError('An account with $normalized already exists');
    }

    final user = AuthUser(
      id: 'user-${_users.length + 1}',
      name: name.trim(),
      email: normalized,
      role: role,
      password: password,
    );
    _users.add(user);
    return user;
  }

  @override
  AuthUser demoUserForRole(UserRole role) {
    return _users.firstWhere((user) => user.role == role);
  }
}
