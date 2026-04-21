// lib/features/dashboard/data/data_sources/dashboard_remote_data_source.dart
import '../../../../core/network/api_service.dart';

class DashboardRemoteDataSource {
  final ApiService _apiService;

  DashboardRemoteDataSource(this._apiService);

  Future<Map<String, dynamic>> getOverview() async {
    // افترضنا إن ده الـ Endpoint حسب الـ Swagger بتاعك
    return await _apiService.get(endpoint: 'Admin/Dashboard/Overview');
  }
}
