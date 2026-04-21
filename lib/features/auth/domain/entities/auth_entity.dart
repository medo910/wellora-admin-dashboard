// lib/features/auth/domain/entities/auth_entity.dart
class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String role;

  AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}
