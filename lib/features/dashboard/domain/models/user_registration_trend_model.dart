import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_registration_trend_entity.dart';

class UserRegistrationTrendModel extends UserRegistrationTrendEntity {
  const UserRegistrationTrendModel({
    required super.month,
    required super.patients,
    required super.doctors,
  });
  factory UserRegistrationTrendModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationTrendModel(
      month: json['month'] ?? '',
      patients: json['patients'] ?? 0,
      doctors: json['doctors'] ?? 0,
    );
  }
}
