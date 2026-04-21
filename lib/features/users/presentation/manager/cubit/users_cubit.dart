import 'package:admin_dashboard_graduation_project/features/users/data/models/user_response_model.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/block_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/get_user_status_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/get_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/suspend_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/unblock_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/unsuspend_users_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final BlockUserUseCase blockUserUseCase;
  final UnblockUserUseCase unblockUserUseCase;
  final SuspendUserUseCase suspendUserUseCase;
  final UnsuspendUserUseCase unsuspendUserUseCase;
  final GetUserStatusUseCase getUserStatusUseCase;

  UsersCubit({
    required this.getUsersUseCase,
    required this.blockUserUseCase,
    required this.unblockUserUseCase,
    required this.suspendUserUseCase,
    required this.unsuspendUserUseCase,
    required this.getUserStatusUseCase,
  }) : super(UsersInitial());

  int doctorsPage = 1;
  int patientsPage = 1;
  String? lastSearchTerm;

  // 1. جلب المستخدمين (مع دعم البحث والفلترة)
  Future<void> fetchAllUsers({
    String? searchTerm,
    bool isRefresh = true,
  }) async {
    if (isRefresh) emit(UsersLoading());
    lastSearchTerm = searchTerm;

    final result = await getUsersUseCase(
      doctorsPage: doctorsPage,
      patientsPage: patientsPage,
      searchTerm: searchTerm,
    );

    result.fold(
      (failure) => emit(UsersFailure(failure.errmessage)),
      (response) => emit(UsersSuccess(response)),
    );
  }

  // 2. ميثود موحدة لتنفيذ الأكشنز (Block, Unblock, etc.)
  Future<void> _performAction(
    Future<dynamic> actionCall,
    String successMsg,
  ) async {
    emit(UserActionLoading());
    final result = await actionCall;

    result.fold((failure) => emit(UserActionFailure(failure.errmessage)), (_) {
      emit(UserActionSuccess(successMsg));
      // تحديث القائمة فوراً بعد نجاح الأكشن بدون إظهار Loading الصفحة كاملة
      fetchAllUsers(searchTerm: lastSearchTerm, isRefresh: false);
    });
  }

  // أكشن الحظر
  Future<void> blockUser(int userId, String reason) async {
    await _performAction(
      blockUserUseCase(userId, reason),
      "User blocked successfully",
    );
  }

  // أكشن فك الحظر
  Future<void> unblockUser(int userId) async {
    await _performAction(
      unblockUserUseCase(userId),
      "User unblocked successfully",
    );
  }

  // أكشن الإيقاف المؤقت
  Future<void> suspendUser(int userId, String reason, String endDate) async {
    await _performAction(
      suspendUserUseCase(userId, reason, endDate),
      "User suspended successfully",
    );
  }

  // أكشن فك الإيقاف
  Future<void> unsuspendUser(int userId) async {
    await _performAction(
      unsuspendUserUseCase(userId),
      "User unsuspended successfully",
    );
  }

  // ميثود لجلب حالة المستخدم (ممكن نستخدمها في الـ UserDetailsPage)
  Future<UserStatusDetailsEntity> fetchUserStatus(int userId) async {
    final result = await getUserStatusUseCase(userId);

    return result.fold(
      (failure) =>
          UserStatusDetailsEntity(), // في حالة الفشل بنرجع Entity فاضية
      (statusDetails) => statusDetails,
    );
  }
}
