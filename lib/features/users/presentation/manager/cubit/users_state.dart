part of 'users_cubit.dart';

@immutable
sealed class UsersState {}

final class UsersInitial extends UsersState {}

// حالات جلب البيانات (الفلترة والبحث)
class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final UserResponseModel userResponse;
  UsersSuccess(this.userResponse);
}

class UsersFailure extends UsersState {
  final String errMessage;
  UsersFailure(this.errMessage);
}

// حالات الأكشنز (Block, Suspend, etc.)
class UserActionLoading extends UsersState {}

class UserActionSuccess extends UsersState {
  final String message;
  UserActionSuccess(this.message);
}

class UserActionFailure extends UsersState {
  final String errMessage;
  UserActionFailure(this.errMessage);
}
