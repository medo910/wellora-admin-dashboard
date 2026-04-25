// features/dashboard/data/repositories/notification_repository_impl.dart
import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/notification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/notification_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService; // الـ Dio Helper بتاعك
  NotificationRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    int page = 1,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await apiService.get(
        endpoint: "notifications",
        queryParameters: {
          "page": page,
          "pageSize": 20,
          "unreadOnly": unreadOnly,
        },
      );
      final List<NotificationModel> list = (response['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList();

      return Right(
        NotificationsResultEntity(
          notifications: list,
          unreadCount: response['unreadCount'],
          totalCount: response['totalCount'],
          hasNextPage: response['hasNextPage'],
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAsRead(String id) async {
    try {
      final response = await apiService.post(
        endpoint: "notifications/$id/mark-as-read",
      );
      return Right(response['message']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> markAllAsRead() async {
    try {
      final response = await apiService.post(
        endpoint: "notifications/mark-all-as-read",
      );
      return Right(response['message']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
