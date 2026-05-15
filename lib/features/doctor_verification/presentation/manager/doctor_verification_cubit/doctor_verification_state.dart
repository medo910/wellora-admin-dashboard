part of 'doctor_verification_cubit.dart';

@immutable
sealed class DoctorVerificationState {}

final class DoctorVerificationInitial extends DoctorVerificationState {}

class DoctorVerificationLoading extends DoctorVerificationState {}

class DoctorVerificationSuccess extends DoctorVerificationState {
  final List<DoctorVerificationEntity> verifications;
  final VerificationStatsEntity stats;
  final int page;
  final bool hasNextPage;
  final int totalItems;
  final String? currentStatus;

  DoctorVerificationSuccess({
    required this.verifications,
    required this.stats,
    required this.page,
    required this.hasNextPage,
    required this.totalItems,
    this.currentStatus,
  });
}

class DoctorVerificationFailure extends DoctorVerificationState {
  final String errMessage;
  DoctorVerificationFailure(this.errMessage);
}

class VerificationActionLoading extends DoctorVerificationState {}

class VerificationActionSuccess extends DoctorVerificationState {
  final String message;
  VerificationActionSuccess(this.message);
}

class VerificationActionFailure extends DoctorVerificationState {
  final String errMessage;
  VerificationActionFailure(this.errMessage);
}
