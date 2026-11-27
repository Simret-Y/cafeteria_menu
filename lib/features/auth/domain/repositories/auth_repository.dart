import '../../presentation/providers/auth_providers.dart';
import '../entities/auth_user.dart';

/// Abstraction for prototype authentication and account registration.
abstract interface class AuthRepository {
  AuthUser? findByEmail(String email);

  AuthUser authenticate({
    required String email,
    required String password,
    UserRole? role,
  });

  AuthUser register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  AuthUser demoUserForRole(UserRole role);
}
