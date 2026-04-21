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

  // 1. جلب البيانات كاملة (الجدول + الإحصائيات)
  Future<void> fetchVerificationData({
    int page = 1, // استلام رقم الصفحة، الديفولت 1
    String? status,
    bool isRefresh = true,
  }) async {
    if (isRefresh) emit(DoctorVerificationLoading());
    currentStatus = status;

    // بننادي الإحصائيات والبيانات مع بعض
    final statsResult = await getStatsUseCase();
    final listResult = await getVerificationsUseCase(
      page: currentPage,
      status: status,
    );

    statsResult.fold(
      (failure) => emit(DoctorVerificationFailure(failure.errmessage)),
      (stats) {
        // listResult.fold(
        //   (failure) => emit(DoctorVerificationFailure(failure.errmessage)),
        //   (list) => emit(DoctorVerificationSuccess(list, stats)),
        // );
        listResult.fold(
          (failure) => emit(DoctorVerificationFailure(failure.errmessage)),
          (paginatedData) {
            // هنا بنبعت كل المعلومات للـ State
            emit(
              DoctorVerificationSuccess(
                verifications: paginatedData.data, // لستة الدكاترة
                stats: stats,
                page: currentPage,
                hasNextPage:
                    paginatedData.hasNextPage, // القيمة دي جاية من الـ API
              ),
            );
          },
        );
      },
    );
  }

  // 2. ميثود الموافقة
  Future<void> approveDoc(int doctorId, String? notes) async {
    emit(VerificationActionLoading());
    final result = await approveUseCase(doctorId, notes);
    result.fold(
      (failure) => emit(VerificationActionFailure(failure.errmessage)),
      (msg) {
        emit(VerificationActionSuccess(msg));
        fetchVerificationData(status: currentStatus, isRefresh: false);
      },
    );
  }

  // 3. ميثود الرفض
  Future<void> rejectDoc(int doctorId, String reason, String? notes) async {
    emit(VerificationActionLoading());
    final result = await rejectUseCase(
      doctorId: doctorId,
      reason: reason,
      adminNotes: notes,
    );
    result.fold(
      (failure) => emit(VerificationActionFailure(failure.errmessage)),
      (msg) {
        emit(VerificationActionSuccess(msg));
        fetchVerificationData(status: currentStatus, isRefresh: false);
      },
    );
  }
}
