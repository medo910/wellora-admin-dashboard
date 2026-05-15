import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_dashboard_overview_use_case.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardOverviewUseCase getDashboardOverviewUseCase;

  DashboardCubit(this.getDashboardOverviewUseCase) : super(DashboardInitial());

  Future<void> getOverview({bool isRefresh = false}) async {
    if (!isRefresh) emit(DashboardLoading());

    final result = await getDashboardOverviewUseCase.call();

    result.fold(
      (failure) => emit(DashboardFailure(failure.errmessage)),
      (overview) => emit(DashboardSuccess(overview)),
    );
  }
}
