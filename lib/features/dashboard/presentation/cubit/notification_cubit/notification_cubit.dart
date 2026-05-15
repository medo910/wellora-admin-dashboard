import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/notification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/notification_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/repositories/notification_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  final SignalRService signalRService;
  NotificationCubit(this.repository, this.signalRService)
    : super(NotificationInitial()) {
    _subscribeToSignalR();
  }
  int unreadCount = 0;
  int currentPage = 1;
  bool hasNextPage = true;

  void _subscribeToSignalR() {
    signalRService.on("NotificationReceived", (arguments) {
      print("🔔 SIGNALR TRIGGERED! Raw data: $arguments");
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final newNoti = NotificationModel.fromJson(
            arguments[0] as Map<String, dynamic>,
          );

          if (state is NotificationSuccess ||
              state is NotificationLoadingMore) {
            List<NotificationEntity> currentList = [];
            if (state is NotificationSuccess) {
              currentList = (state as NotificationSuccess).notifications;
            } else {
              currentList = (state as NotificationLoadingMore).notifications;
            }

            final updatedList = [newNoti, ...currentList];
            unreadCount++;
            emit(NotificationSuccess(updatedList));
          }
        } catch (e) {
          print("❌ Error parsing SignalR notification: $e");
        }
      }
    });
  }

  Future<void> fetchMore() async {
    if (!hasNextPage ||
        state is NotificationLoadingMore ||
        state is! NotificationSuccess)
      return;

    final oldNotifications = (state as NotificationSuccess).notifications;
    emit(NotificationLoadingMore(oldNotifications));

    currentPage++;
    final result = await repository.getNotifications(page: currentPage);

    result.fold((f) => emit(NotificationFailure(f.errmessage)), (data) {
      hasNextPage = data.hasNextPage;
      final updatedList = [...oldNotifications, ...data.notifications];
      emit(NotificationSuccess(updatedList));
    });
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    currentPage = 1;
    final result = await repository.getNotifications(page: currentPage);
    result.fold((f) => emit(NotificationFailure(f.errmessage)), (data) {
      unreadCount = data.unreadCount;
      hasNextPage = data.hasNextPage;
      emit(NotificationSuccess(data.notifications));
    });
  }

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is NotificationSuccess) {
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
      final newList = currentState.notifications
          .map((n) => n.isRead ? n : _markRead(n))
          .toList();
      unreadCount = 0;
      emit(NotificationSuccess(newList));
    }
    await repository.markAllAsRead();
  }
}
