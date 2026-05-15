import '../../../../core/network/api_service.dart';

class DashboardRemoteDataSource {
  final ApiService _apiService;

  DashboardRemoteDataSource(this._apiService);

  Future<Map<String, dynamic>> getOverview() async {
    return await _apiService.get(endpoint: 'Admin/Dashboard/Overview');
  }
}
