// import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
// import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
// import 'package:admin_dashboard_graduation_project/features/auth/data/data_sources/auth_remote_data_source.dart';
// import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/auth_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/auth/domain/models/auth_token_model.dart';
// import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';

// class AuthRepoImpl implements AuthRepository {
//   // lib/features/auth/data/repositories/auth_repository_impl.dart
//   final AuthRemoteDataSource remoteDataSource;

//   AuthRepoImpl(this.remoteDataSource);
//   @override
//   Future<Either<Failure, LoginResultEntity>> login({
//     required String email,
//     required String password,
//     String? otpCode,
//   }) async {
//     try {
//       final response = await remoteDataSource.login(
//         email: email,
//         password: password,
//         otpCode: otpCode ?? "",
//       );

//       if (response['isSuccess'] == true) {
//         // بناءً على ستاندرد الباك إند [cite: 114]
//         // الحالة 1: الـ OTP لسه متبعتش (النداء الأول)
//         if (otpCode == null || otpCode.isEmpty) {
//           return Right(
//             LoginOtpRequiredEntity(
//               mfaToken: response['data']['mfaToken'] ?? "",
//               message: response['data']['message'] ?? "OTP Sent",
//             ),
//           );
//         }
//         // الحالة 2: الـ OTP موجود وبنفك التوكن (النداء الثاني) [cite: 81, 87]
//         else {
//           final tokenModel = AuthTokenModel.fromJson(response);
//           Map<String, dynamic> payload = JwtDecoder.decode(
//             tokenModel.accessToken,
//           );
//           String role = (payload['Role'] ?? payload['role'] ?? '')
//               .toString()
//               .toLowerCase();

//           // فحص الـ Admin Role [cite: 87, 88]
//           if (role != 'admin') {
//             return Left(
//               ServerFailure("Access Denied: Admin privileges required."),
//             );
//           }

//           // حفظ التوكنز والبيانات [cite: 90, 97]
//           await SecureStorageHelper.saveFullUserData(
//             accessToken: tokenModel.accessToken,
//             refreshToken: tokenModel.refreshToken,
//             role: role,
//             userId: (payload['UserID'] ?? '').toString(),
//             name: (payload['Name'] ?? '').toString(),
//             email: (payload['Email'] ?? '').toString(),
//             jti: (payload['jti'] ?? '').toString(),
//           );

//           return Right(
//             LoginSuccessEntity(
//               user: AuthEntity(
//                 id: (payload['UserID'] ?? '').toString(),
//                 name: (payload['Name'] ?? '').toString(),
//                 email: (payload['Email'] ?? '').toString(),
//                 role: role,
//               ),
//             ),
//           );
//         }
//       } else {
//         return Left(
//           ServerFailure(response['error'] ?? "Login failed"),
//         ); // [cite: 122]
//       }
//     } on DioException catch (e) {
//       return Left(ServerFailure.fromDioException(e)); // [cite: 124]
//     }
//   }
// }

// lib/features/auth/data/repositories/auth_repository_impl.dart
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
      // 1. تنفيذ نداء الـ API
      final response = await remoteDataSource.login(
        email: email,
        password: password,
        otpCode: otpCode ?? "",
      );

      // 2. تحويل الـ JSON لموديل الاستجابة المنظم
      final loginModel = LoginResponseModel.fromJson(response);

      if (loginModel.isSuccess) {
        // --- الحالة الأولى: النداء الأول (بدون OTP) --- [cite: 80, 111]
        if (otpCode == null || otpCode.isEmpty) {
          return Right(
            LoginOtpRequiredEntity(
              mfaToken: loginModel.mfaToken ?? "",
              message: loginModel.message ?? "OTP sent to your email.",
            ),
          );
        }
        // --- الحالة الثانية: النداء الثاني (مع OTP) --- [cite: 81, 112]
        else {
          final tokenModel = loginModel.tokens!;

          // أ. فك التشفير من الـ JWT للتأكد من الصلاحيات [cite: 87, 101]
          Map<String, dynamic> payload = JwtDecoder.decode(
            tokenModel.accessToken,
          );
          String role = (payload['Role'] ?? payload['role'] ?? '')
              .toString()
              .toLowerCase();

          // ب. التحقق من صلاحية الأدمن [cite: 82, 88]
          if (role != 'admin') {
            return Left(
              ServerFailure(
                "Access Denied: You are not authorized as an Admin.",
              ),
            );
          }

          // ج. حفظ البيانات في الـ Secure Storage [cite: 90, 96]
          await SecureStorageHelper.saveFullUserData(
            accessToken: tokenModel.accessToken,
            refreshToken: tokenModel.refreshToken,
            role: role,
            userId: (payload['UserID'] ?? payload['uid'] ?? '').toString(),
            jti: (payload['jti'] ?? '').toString(),
            name: (payload['Name'] ?? payload['name'] ?? '').toString(),
            email: (payload['Email'] ?? payload['email'] ?? '').toString(),
          );

          // د. إرجاع كيان النجاح للـ UI
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
