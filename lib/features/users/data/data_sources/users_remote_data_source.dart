// lib/features/users/data/data_sources/users_remote_data_source.dart

import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
import 'package:admin_dashboard_graduation_project/features/users/data/models/user_status_details_model.dart';

import '../models/user_response_model.dart';

abstract class UsersRemoteDataSource {
  Future<UserResponseModel> getAllUsers({
    int doctorsPage = 1,
    int patientsPage = 1,
    int doctorsPageSize = 10,
    int patientsPageSize = 10,
    String? searchTerm,
  });

  Future<void> blockUser({required int userId, required String reason});
  Future<void> unblockUser({required int userId});
  Future<void> suspendUser({
    required int userId,
    required String reason,
    required String endDate,
  });
  Future<void> unsuspendUser({required int userId});
  Future<UserStatusDetailsModel> getUserStatus(int userId);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiService apiService;

  UsersRemoteDataSourceImpl(this.apiService);

  @override
  Future<UserResponseModel> getAllUsers({
    int doctorsPage = 1,
    int patientsPage = 1,
    int doctorsPageSize = 10,
    int patientsPageSize = 10,
    String? searchTerm,
  }) async {
    final response = await apiService.get(
      endpoint: 'admin/users/all',
      queryParameters: {
        'DoctorsPage': doctorsPage,
        'DoctorsPageSize': doctorsPageSize,
        'PatientsPage': patientsPage,
        'PatientsPageSize': patientsPageSize,
        if (searchTerm != null) 'SearchTerm': searchTerm,
      },
    );
    return UserResponseModel.fromJson(response);
  }

  @override
  Future<void> blockUser({required int userId, required String reason}) async {
    await apiService.post(
      endpoint: 'admin/users/block',
      body: {'userId': userId, 'reason': reason},
    );
  }

  @override
  Future<void> unblockUser({required int userId}) async {
    await apiService.post(
      endpoint: 'admin/users/unblock',
      body: {'userId': userId},
    );
  }

  @override
  Future<void> suspendUser({
    required int userId,
    required String reason,
    required String endDate,
  }) async {
    await apiService.post(
      endpoint: 'admin/users/suspend',
      body: {
        'userId': userId,
        'reason': reason,
        'suspensionEndDate': endDate, // ISO 8601 String
      },
    );
  }

  @override
  Future<void> unsuspendUser({required int userId}) async {
    await apiService.post(
      endpoint: 'admin/users/unsuspend',
      body: {'userId': userId},
    );
  }

  @override
  Future<UserStatusDetailsModel> getUserStatus(int userId) async {
    final response = await apiService.get(
      endpoint: 'admin/users/$userId/status', // المسار اللي أحمد الدسوقي عامله
    );
    return UserStatusDetailsModel.fromJson(response);
  }
}
