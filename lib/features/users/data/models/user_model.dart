// lib/features/users/data/models/user_model.dart

import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    super.specificId,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.specialization,
    super.bloodType,
    required super.isBlocked,
    required super.isSuspended,
    super.isVerified,
    required super.createdAt,
    required super.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, UserType type) {
    return UserModel(
      userId: json['userId'],
      specificId: type == UserType.doctor
          ? json['doctorId']
          : json['patientId'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      bloodType: json['bloodType'],
      isVerified: json['isVerified'],
      isBlocked: json['isBlocked'] ?? false,
      isSuspended: json['isSuspended'] ?? false,
      createdAt: json['createdAt'] ?? '',
      userType: type,
    );
  }
}
