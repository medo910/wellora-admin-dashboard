// part of 'dashboard_cubit.dart';

// @immutable
// sealed class DashboardState {}

// final class DashboardInitial extends DashboardState {}

// class DashboardLoading extends DashboardState {}

// class DashboardSuccess extends DashboardState {
//   final DashboardOverviewModel data;
//   DashboardSuccess(this.data);
// }

// class DashboardError extends DashboardState {
//   final String message;
//   DashboardError(this.message);
// }

// lib/features/dashboard/presentation/manager/dashboard_cubit/dashboard_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/dashboard_overview_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final DashboardOverviewEntity overview;
  const DashboardSuccess(this.overview);

  @override
  List<Object?> get props => [overview];
}

class DashboardFailure extends DashboardState {
  final String errMessage;
  const DashboardFailure(this.errMessage);

  @override
  List<Object?> get props => [errMessage];
}
