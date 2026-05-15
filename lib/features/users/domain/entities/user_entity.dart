enum UserType { doctor, patient }

class UserEntity {
  final int userId;
  final int? specificId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? specialization;
  final String? bloodType;
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
