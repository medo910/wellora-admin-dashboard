// part of 'support_cubit.dart';

// sealed class SupportState extends Equatable {
//   const SupportState();

//   @override
//   List<Object?> get props => [];
// }

// final class SupportInitial extends SupportState {}

// // 1. حالة التحميل لأول مرة فقط (الشاشة بيضاء)
// final class SupportLoading extends SupportState {}

// final class SupportFailure extends SupportState {
//   final String errorMessage;
//   const SupportFailure(this.errorMessage);

//   @override
//   List<Object?> get props => [errorMessage];
// }

// // ---------------------------------------------------------
// // 2. حالات الأكشنز (تغيير Priority، قفل تيكت، إلخ)
// // بنفصلهم عشان الـ Listener يلقطهم ويعمل SnackBar من غير ما يهز الـ UI الأساسي
// final class SupportActionLoading extends SupportState {}

// final class SupportActionSuccess extends SupportState {
//   final String successMessage;
//   const SupportActionSuccess(this.successMessage);

//   @override
//   List<Object?> get props => [successMessage];
// }

// final class SupportActionFailure extends SupportState {
//   final String errorMessage;
//   const SupportActionFailure(this.errorMessage);

//   @override
//   List<Object?> get props => [errorMessage];
// }

// final class SupportSuccess extends SupportState {
//   final List<SupportTicketEntity> tickets;
//   final SupportStatsEntity stats;
//   final int currentPage;
//   final bool hasNextPage;
//   final int totalItems;
//   final String? currentStatus;
//   final String? currentPriority;
//   final String? currentCategory;
//   final DateTimeRange? currentDateRange;
//   const SupportSuccess({
//     required this.tickets,
//     required this.stats,
//     required this.currentPage,
//     required this.hasNextPage,
//     required this.totalItems,
//     this.currentStatus,
//     this.currentPriority,
//     this.currentCategory,
//     this.currentDateRange,
//   });

//   SupportSuccess copyWith({
//     List<SupportTicketEntity>? tickets,
//     SupportStatsEntity? stats,
//     int? currentPage,
//     bool? hasNextPage,
//     int? totalItems,
//     String? currentStatus,
//     String? currentPriority,
//     String? currentCategory,
//     DateTimeRange? currentDateRange,
//   }) {
//     return SupportSuccess(
//       tickets: tickets ?? this.tickets,
//       stats: stats ?? this.stats,
//       currentPage: currentPage ?? this.currentPage,
//       hasNextPage: hasNextPage ?? this.hasNextPage,
//       totalItems: totalItems ?? this.totalItems,
//       currentStatus: currentStatus ?? this.currentStatus,
//       currentPriority: currentPriority ?? this.currentPriority,
//       currentCategory: currentCategory ?? this.currentCategory,
//       currentDateRange: currentDateRange ?? this.currentDateRange,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     tickets,
//     stats,
//     currentPage,
//     hasNextPage,
//     totalItems,
//     currentStatus,
//     currentPriority,
//     currentCategory,
//     currentDateRange,
//   ];
// }

part of 'support_cubit.dart';

sealed class SupportState extends Equatable {
  const SupportState();
  @override
  List<Object?> get props => [];
}

final class SupportInitial extends SupportState {}

final class SupportLoading extends SupportState {}

final class SupportSuccess extends SupportState {
  final List<SupportTicketEntity> tickets;
  final SupportStatsEntity stats;
  final int currentPage;
  final bool hasNextPage;
  final int totalItems;
  final String? currentStatus;
  final String? currentPriority;
  final String? currentCategory;
  final DateTimeRange? currentDateRange;
  final String? currentSearch;

  const SupportSuccess({
    required this.tickets,
    required this.stats,
    required this.currentPage,
    required this.hasNextPage,
    required this.totalItems,
    this.currentStatus,
    this.currentPriority,
    this.currentCategory,
    this.currentDateRange,
    this.currentSearch,
  });

  SupportSuccess copyWith({
    List<SupportTicketEntity>? tickets,
    SupportStatsEntity? stats,
    int? currentPage,
    bool? hasNextPage,
    int? totalItems,
    String? currentStatus,
    String? currentPriority,
    String? currentCategory,
    DateTimeRange? currentDateRange,
    String? currentSearch,
  }) {
    return SupportSuccess(
      tickets: tickets ?? this.tickets,
      stats: stats ?? this.stats,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalItems: totalItems ?? this.totalItems,
      currentStatus: currentStatus ?? this.currentStatus,
      currentPriority: currentPriority ?? this.currentPriority,
      currentCategory: currentCategory ?? this.currentCategory,
      currentDateRange: currentDateRange ?? this.currentDateRange,
      currentSearch: currentSearch ?? this.currentSearch,
    );
  }

  @override
  List<Object?> get props => [
    tickets,
    stats,
    currentPage,
    hasNextPage,
    totalItems,
    currentStatus,
    currentPriority,
    currentCategory,
    currentDateRange,
    currentSearch,
  ];
}

final class SupportFailure extends SupportState {
  final String errorMessage;
  const SupportFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

// حالات الأكشنز المنفصلة
final class SupportActionLoading extends SupportState {}

final class SupportActionSuccess extends SupportState {
  final String successMessage;
  const SupportActionSuccess(this.successMessage);
}

final class SupportActionFailure extends SupportState {
  final String errorMessage;
  const SupportActionFailure(this.errorMessage);
}
