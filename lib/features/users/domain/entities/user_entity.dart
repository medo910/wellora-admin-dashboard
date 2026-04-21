// // lib/features/users/domain/entities/user_entity.dart

// enum UserRole { patient, doctor, admin }

// enum UserStatus { active, suspended, blocked, pending }

// // lib/features/users/domain/entities/user_entity.dart

// class UserEntity {
//   final int userId;
//   final String fullName;
//   final String email;
//   final String? phoneNumber;
//   final bool isBlocked;
//   final bool isSuspended;
//   final bool? isVerified; // للدكاترة بس
//   final String? specialization; // للدكاترة بس
//   final String? bloodType; // للمرضى بس
//   final String createdAt;
//   final String userType; // "Doctor" or "Patient"

//   UserEntity({
//     required this.userId, required this.fullName, required this.email,
//     this.phoneNumber, required this.isBlocked, required this.isSuspended,
//     this.isVerified, this.specialization, this.bloodType,
//     required this.createdAt, required this.userType,
//   });
// }

// lib/features/users/domain/entities/user_entity.dart

enum UserType { doctor, patient }

class UserEntity {
  final int userId;
  final int? specificId; // doctorId or patientId
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? specialization; // للدكاترة بس
  final String? bloodType; // للمرضى بس
  final bool isBlocked;
  final bool isSuspended;
  final bool? isVerified;
  final String createdAt;
  final UserType userType;

  UserEntity({
    required this.userId,
    this.specificId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.specialization,
    this.bloodType,
    required this.isBlocked,
    required this.isSuspended,
    this.isVerified,
    required this.createdAt,
    required this.userType,
  });
}
