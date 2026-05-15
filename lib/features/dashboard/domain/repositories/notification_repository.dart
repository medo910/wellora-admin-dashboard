import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/notification_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    int page = 1,
    bool unreadOnly = false,
  });
  Future<Either<Failure, String>> markAsRead(String id);
  Future<Either<Failure, String>> markAllAsRead();
}
