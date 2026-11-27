import 'package:freezed_annotation/freezed_annotation.dart';

import '../../presentation/providers/auth_providers.dart';

part 'auth_user.freezed.dart';

/// Immutable user account model aligned with the proposal data model.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    required String password,
  }) = _AuthUser;
}
