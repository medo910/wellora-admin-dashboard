part of 'doctor_verification_cubit.dart';

@immutable
sealed class DoctorVerificationState {}

final class DoctorVerificationInitial extends DoctorVerificationState {}

class DoctorVerificationLoading extends DoctorVerificationState {}

class DoctorVerificationSuccess extends DoctorVerificationState {
  final List<DoctorVerificationEntity> verifications;
  final VerificationStatsEntity stats;
  final int page; // الصفحة الحالية
  final bool hasNextPage; // هل فيه صفحة تانية؟

  DoctorVerificationSuccess({
    required this.verifications,
    required this.stats,
    required this.page,
    required this.hasNextPage,
  });
}

class DoctorVerificationFailure extends DoctorVerificationState {
  final String errMessage;
  DoctorVerificationFailure(this.errMessage);
}

// حالات خاصة بالأكشنز (Approve/Reject) عشان مانعملش Reload للصفحة كلها
class VerificationActionLoading extends DoctorVerificationState {}

class VerificationActionSuccess extends DoctorVerificationState {
  final String message;
  VerificationActionSuccess(this.message);
}

class VerificationActionFailure extends DoctorVerificationState {
  final String errMessage;
  VerificationActionFailure(this.errMessage);
}
