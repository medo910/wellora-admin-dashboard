import 'dart:developer';

import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/models/auth_token_model.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/models/login_response_model.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/login_result_entity.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
    String? otpCode,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
        otpCode: otpCode ?? "",
      );

      final loginModel = LoginResponseModel.fromJson(response);

      if (loginModel.isSuccess) {
        if (otpCode == null || otpCode.isEmpty) {
          return Right(
            LoginOtpRequiredEntity(
              mfaToken: loginModel.mfaToken ?? "",
              message: loginModel.message ?? "OTP sent to your email.",
            ),
          );
        } else {
          final tokenModel = loginModel.tokens!;

          Map<String, dynamic> payload = JwtDecoder.decode(
            tokenModel.accessToken,
          );
          String role = (payload['Role'] ?? payload['role'] ?? '')
              .toString()
              .toLowerCase();

          if (role != 'admin') {
            return Left(
              ServerFailure(
                "Access Denied: You are not authorized as an Admin.",
              ),
            );
          }

          await SecureStorageHelper.saveFullUserData(
            accessToken: tokenModel.accessToken,
            refreshToken: tokenModel.refreshToken,
            role: role,
            userId: (payload['UserID'] ?? payload['uid'] ?? '').toString(),
            jti: (payload['jti'] ?? '').toString(),
            name: (payload['Name'] ?? payload['name'] ?? '').toString(),
            email: (payload['Email'] ?? payload['email'] ?? '').toString(),
          );

          return Right(
            LoginSuccessEntity(
              user: AuthEntity(
                id: (payload['UserID'] ?? '').toString(),
                name: (payload['Name'] ?? '').toString(),
                email: (payload['Email'] ?? '').toString(),
                role: role,
              ),
            ),
          );
        }
      } else {
        return Left(
          ServerFailure(
            loginModel.message ??
                "Login failed. Please check your credentials.",
          ),
        );
      }
    } catch (e) {
      return Left(
        ServerFailure("An unexpected error occurred: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final userId = await SecureStorageHelper.getUserId();
      final jti = await SecureStorageHelper.getJti();
      await remoteDataSource.logout(userId: int.parse(userId!), jti: jti!);
      await SecureStorageHelper.clearAll();

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAccessValidity(String accessToken) async {
    try {
      final res = await remoteDataSource.checkToken();
      log(res.toString());
      return Right(res['summary'] == 'all_valid');
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, AuthTokenModel>> refreshToken({
    required String refreshToken,
    required String accessToken,
  }) async {
    try {
      final res = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );

      if (res['success'] == true) {
        final tokens = res['data'] ?? res;
        return Right(AuthTokenModel.fromJson(tokens));
      } else {
        final msg = res['data']?['message'] ?? 'Refresh token failed';
        return Left(ServerFailure(msg));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resendOtp({
    required String mfaToken,
  }) async {
    try {
      final res = await remoteDataSource.resendOtp(mfaToken: mfaToken);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
