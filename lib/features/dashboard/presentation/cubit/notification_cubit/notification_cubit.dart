import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/notification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/repositories/notification_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  NotificationCubit(this.repository) : super(NotificationInitial());
  int unreadCount = 0;

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    final result = await repository.getNotifications();
    result.fold((f) => emit(NotificationFailure(f.errmessage)), (data) {
      unreadCount = data.unreadCount;
      emit(NotificationSuccess(data.notifications));
    });
  }

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      // تحديث فوري في الذاكرة (UX)
      final newList = currentState.notifications
          .map((n) => n.id == id ? _markRead(n) : n)
          .toList();
      if (unreadCount > 0) unreadCount--;
      emit(NotificationSuccess(newList));
    }
    await repository.markAsRead(id);
  }

  NotificationEntity _markRead(NotificationEntity n) {
    return NotificationEntity(
      id: n.id,
      title: n.title,
      message: n.message,
      type: n.type,
      isRead: true,
      createdAt: n.createdAt,
      relatedEntityId: n.relatedEntityId,
      relatedEntityType: n.relatedEntityType,
    );
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
      // تحديث فوري في الذاكرة (UX)
      final newList = currentState.notifications
          .map((n) => n.isRead ? n : _markRead(n))
          .toList();
      unreadCount = 0;
      emit(NotificationSuccess(newList));
    }
    await repository.markAllAsRead();
  }
}
