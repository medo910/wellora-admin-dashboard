import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/auth_entity.dart';

abstract class LoginResultEntity {}

class LoginOtpRequiredEntity extends LoginResultEntity {
  final String mfaToken;
  final String message;

  LoginOtpRequiredEntity({required this.mfaToken, required this.message});
}

class LoginSuccessEntity extends LoginResultEntity {
  final AuthEntity user;

  LoginSuccessEntity({required this.user});
}
