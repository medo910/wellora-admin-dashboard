import 'package:admin_dashboard_graduation_project/features/users/data/models/user_model.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_entity.dart';

class UserResponseModel {
  final PaginatedData doctors;
  final PaginatedData patients;
  final int totalUsers;
  final bool isSuccess;

  UserResponseModel({
    required this.doctors,
    required this.patients,
    required this.totalUsers,
    required this.isSuccess,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      isSuccess: json['isSuccess'] ?? false,
      totalUsers: json['totalUsers'] ?? 0,
      doctors: PaginatedData.fromJson(json['doctors'], UserType.doctor),
      patients: PaginatedData.fromJson(json['patients'], UserType.patient),
    );
  }
}

class PaginatedData {
  final List<UserModel> data;
  final int totalCount;
  final int page;
  final bool hasNextPage;

  PaginatedData({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.hasNextPage,
  });

  factory PaginatedData.fromJson(Map<String, dynamic> json, UserType type) {
    return PaginatedData(
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      data: (json['data'] as List)
          .map((i) => UserModel.fromJson(i, type))
          .toList(),
    );
  }
}
