// lib/features/doctor_verification/data/data_sources/doctor_verification_remote_data_source.dart

import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/data/models/doctor_verification_response_model.dart';
import '../models/doctor_verification_model.dart';
import '../models/verification_stats_model.dart';

abstract class DoctorVerificationRemoteDataSource {
  Future<DoctorVerificationResponseModel> getVerifications(
    Map<String, dynamic> queryParams,
  );
  Future<Map<String, dynamic>> approveVerification(int doctorId, String? notes);
  Future<Map<String, dynamic>> rejectVerification(
    int doctorId,
    String reason,
    String? notes,
  );
  Future<VerificationStatsModel> getStatistics();
}

class DoctorVerificationRemoteDataSourceImpl
    implements DoctorVerificationRemoteDataSource {
  final ApiService apiService;
  DoctorVerificationRemoteDataSourceImpl(this.apiService);

  @override
  Future<DoctorVerificationResponseModel> getVerifications(
    Map<String, dynamic> queryParams,
  ) async {
    final response = await apiService.get(
      endpoint: 'admin/doctor-verifications',
      queryParameters: queryParams,
    );
    // هنفترض إن "data" هي اللي شايلة لستة الدكاترة بعد التجميع
    return DoctorVerificationResponseModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> approveVerification(
    int doctorId,
    String? notes,
  ) async {
    return await apiService.post(
      endpoint: 'admin/doctor-verifications/$doctorId/approve',
      body: {"adminNotes": notes},
    );
  }

  @override
  Future<Map<String, dynamic>> rejectVerification(
    int doctorId,
    String reason,
    String? notes,
  ) async {
    return await apiService.post(
      endpoint: 'admin/doctor-verifications/$doctorId/reject',
      body: {"rejectionReason": reason, "adminNotes": notes},
    );
  }

  @override
  Future<VerificationStatsModel> getStatistics() async {
    final response = await apiService.get(
      endpoint: 'admin/doctor-verifications/statistics',
    );
    return VerificationStatsModel.fromJson(response);
  }
}
