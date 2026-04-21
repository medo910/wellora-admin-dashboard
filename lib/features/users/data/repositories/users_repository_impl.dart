// lib/features/users/data/repositories/users_repository_impl.dart

import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/users_repository.dart';
import '../data_sources/users_remote_data_source.dart';
import '../models/user_response_model.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserResponseModel>> getUsers({
    int doctorsPage = 1,
    int patientsPage = 1,
    String? searchTerm,
  }) async {
    try {
      final result = await remoteDataSource.getAllUsers(
        doctorsPage: doctorsPage,
        patientsPage: patientsPage,
        searchTerm: searchTerm,
      );
      return Right(result);
    } catch (e) {
      // هنا بنستخدم ServerFailure اللي إنت أكيد عامله في الـ core
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> blockUser({
    required int userId,
    required String reason,
  }) async {
    return await _handleAction(
      () => remoteDataSource.blockUser(userId: userId, reason: reason),
    );
  }

  @override
  Future<Either<Failure, Unit>> unblockUser({required int userId}) async {
    return await _handleAction(
      () => remoteDataSource.unblockUser(userId: userId),
    );
  }

  @override
  Future<Either<Failure, Unit>> suspendUser({
    required int userId,
    required String reason,
    required String endDate,
  }) async {
    return await _handleAction(
      () => remoteDataSource.suspendUser(
        userId: userId,
        reason: reason,
        endDate: endDate,
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> unsuspendUser({required int userId}) async {
    return await _handleAction(
      () => remoteDataSource.unsuspendUser(userId: userId),
    );
  }

  @override
  Future<Either<Failure, UserStatusDetailsEntity>> getUserStatus(
    int userId,
  ) async {
    try {
      final result = await remoteDataSource.getUserStatus(userId);
      return Right(result);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  // ميثود مساعدة (Generic) عشان مكررش كود الـ try-catch في كل أكشن
  Future<Either<Failure, Unit>> _handleAction(
    Future<void> Function() action,
  ) async {
    try {
      await action();
      return const Right(unit); // unit دي يعني "تمام مفيش داتا محتاجة ترجع"
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioException(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
