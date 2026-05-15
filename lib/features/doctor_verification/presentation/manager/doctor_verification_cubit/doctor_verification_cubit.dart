import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/approve_verification_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/get_verification_stats_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/get_verifications_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/reject_verification_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'doctor_verification_state.dart';

class DoctorVerificationCubit extends Cubit<DoctorVerificationState> {
  final GetVerificationsUseCase getVerificationsUseCase;
  final ApproveVerificationUseCase approveUseCase;
  final RejectVerificationUseCase rejectUseCase;
  final GetVerificationStatsUseCase getStatsUseCase;

  DoctorVerificationCubit({
    required this.getVerificationsUseCase,
    required this.approveUseCase,
    required this.rejectUseCase,
    required this.getStatsUseCase,
  }) : super(DoctorVerificationInitial());

  int currentPage = 1;
  String? currentStatus;
  VerificationStatsEntity? lastStats;

  Future<void> fetchVerificationData({
    int? page,
    String? status,
    bool isRefresh = true,
  }) async {
    if (isRefresh) emit(DoctorVerificationLoading());
    if (page != null) currentPage = page;

    if (status != null) {
      currentStatus = (status == "All") ? null : status;
    }

    final statsResult = await getStatsUseCase();
    final listResult = await getVerificationsUseCase(
      page: currentPage,
      status: currentStatus,
    );

    statsResult.fold(
      (failure) => emit(DoctorVerificationFailure(failure.errmessage)),
      (stats) {
        lastStats = stats;
        listResult.fold(
          (failure) => emit(DoctorVerificationFailure(failure.errmessage)),
          (paginatedData) {
            emit(
              DoctorVerificationSuccess(
                verifications: paginatedData.data,
                stats: stats,
                page: currentPage,
                hasNextPage: paginatedData.hasNextPage,
                totalItems: paginatedData.totalCount,
                currentStatus: currentStatus,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> approveDoc(int doctorId, String? notes) async {
    emit(VerificationActionLoading());
    final result = await approveUseCase(doctorId, notes);
    result.fold(
      (failure) {
        if (!isClosed) emit(VerificationActionFailure(failure.errmessage));
      },
      (msg) {
        if (!isClosed) {
          emit(VerificationActionSuccess(msg));
          fetchVerificationData(status: currentStatus, isRefresh: false);
        }
      },
    );
  }

  Future<void> rejectDoc(int doctorId, String reason, String? notes) async {
    emit(VerificationActionLoading());
    final result = await rejectUseCase(
      doctorId: doctorId,
      reason: reason,
      adminNotes: notes,
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(VerificationActionFailure(failure.errmessage));
      },
      (msg) {
        if (!isClosed) {
          emit(VerificationActionSuccess(msg));
          fetchVerificationData(status: currentStatus, isRefresh: false);
        }
      },
    );
  }
}
