// features/review_moderation/data/datasources/review_remote_data_source.dart
import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';

abstract class ReviewRemoteDataSource {
  Future<Map<String, dynamic>> getReviews(Map<String, dynamic> params);
  Future<Map<String, dynamic>> getDeletedReviews(int page, int pageSize);
  Future<String> deleteReview(int reviewId, String reason);
  Future<String> restoreReview(int reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService _apiService;
  ReviewRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> getReviews(Map<String, dynamic> params) async {
    final response = await _apiService.get(
      endpoint: "admin/reviews",
      queryParameters: params,
    );
    return response;
  }

  @override
  Future<Map<String, dynamic>> getDeletedReviews(int page, int pageSize) async {
    final response = await _apiService.get(
      endpoint: "admin/reviews/deleted",
      queryParameters: {"page": page, "pageSize": pageSize},
    );
    return response;
  }

  @override
  Future<String> deleteReview(int reviewId, String reason) async {
    final response = await _apiService.post(
      endpoint: "admin/reviews/delete",
      body: {"reviewId": reviewId, "reason": reason},
    );
    return response['message'];
  }

  @override
  Future<String> restoreReview(int reviewId) async {
    final response = await _apiService.post(
      endpoint: "admin/reviews/restore",
      body: {"reviewId": reviewId},
    );
    return response['message'];
  }
}
