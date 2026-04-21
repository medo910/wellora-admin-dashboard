// import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/dashboard_overview_model.dart';
// import 'package:admin_dashboard_graduation_project/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

// part 'dashboard_state.dart';

// class DashboardCubit extends Cubit<DashboardState> {
//   final GetDashboardOverviewUseCase getDashboardOverviewUseCase;
//   DashboardCubit(this.getDashboardOverviewUseCase) : super(DashboardInitial());

//   Future<void> getOverview() async {
//     emit(DashboardLoading());
//     final result = await getDashboardOverviewUseCase();
//     result.fold(
//       (failure) => emit(DashboardError(failure.errmessage)),
//       (data) => emit(DashboardSuccess(data)),
//     );
//   }
// }

// lib/features/dashboard/presentation/manager/dashboard_cubit/dashboard_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/get_dashboard_overview_use_case.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardOverviewUseCase getDashboardOverviewUseCase;

  DashboardCubit(this.getDashboardOverviewUseCase) : super(DashboardInitial());

  Future<void> getOverview() async {
    emit(DashboardLoading());

    final result = await getDashboardOverviewUseCase.call();

    result.fold(
      (failure) => emit(DashboardFailure(failure.errmessage)),
      (overview) => emit(DashboardSuccess(overview)),
    );
  }
}
