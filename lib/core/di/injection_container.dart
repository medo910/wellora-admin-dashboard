// lib/core/di/injection_container.dart
import 'package:admin_dashboard_graduation_project/core/di/session_manager.dart';
import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/auth/data/repos/auth_repo_impl.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/use_cases/login_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/data/repositories/notification_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/repositories/notification_repository.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/notification_cubit/notification_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/sidebar_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/data/data_sources/doctor_verification_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/data/repositories/doctor_verification_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/repositories/doctor_verification_repository.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/approve_verification_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/get_verification_stats_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/get_verifications_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/use_cases/reject_verification_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/data/datasources/review_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/data/repositories/review_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/delete_review_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/get_deleted_reviews_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/get_reviews_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/restore_review_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/manager/review_moderation_cubit/review_moderation_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/data/data_sources/support_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/data/repositories/support_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_support_stats_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_ticket_messages_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_tickets_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/respond_to_ticket_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_priority_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_status_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_chat_cubit/support_chat_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_cubit/support_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/users/data/data_sources/users_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/users/data/repositories/users_repository_impl.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/block_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/get_user_status_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/get_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/suspend_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/unblock_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/use_cases/unsuspend_users_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton<SignalRService>(() => SignalRService());

  sl.registerLazySingleton(() => AuthRemoteDataSource(sl<ApiService>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl()));

  sl.registerLazySingleton(() => SessionManager(sl<AuthRepository>()));

  sl.registerLazySingleton(() => SidebarCubit());
  sl.registerLazySingleton(() => DashboardRemoteDataSource(sl<ApiService>()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetDashboardOverviewUseCase(sl()));
  sl.registerFactory(() => DashboardCubit(sl()));

  sl.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(sl()),
  );

  sl.registerFactory(() => NotificationCubit(sl(), sl()));
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => BlockUserUseCase(sl()));
  sl.registerLazySingleton(() => UnblockUserUseCase(sl()));
  sl.registerLazySingleton(() => SuspendUserUseCase(sl()));
  sl.registerLazySingleton(() => UnsuspendUserUseCase(sl()));
  sl.registerLazySingleton(() => GetUserStatusUseCase(sl()));

  sl.registerFactory(
    () => UsersCubit(
      getUsersUseCase: sl(),
      blockUserUseCase: sl(),
      unblockUserUseCase: sl(),
      suspendUserUseCase: sl(),
      unsuspendUserUseCase: sl(),
      getUserStatusUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<DoctorVerificationRemoteDataSource>(
    () => DoctorVerificationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DoctorVerificationRepository>(
    () => DoctorVerificationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetVerificationsUseCase(sl()));
  sl.registerLazySingleton(() => ApproveVerificationUseCase(sl()));
  sl.registerLazySingleton(() => RejectVerificationUseCase(sl()));
  sl.registerLazySingleton(() => GetVerificationStatsUseCase(sl()));

  sl.registerFactory(
    () => DoctorVerificationCubit(
      getVerificationsUseCase: sl(),
      approveUseCase: sl(),
      rejectUseCase: sl(),
      getStatsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSourceImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(sl<SupportRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetTicketsUseCase(sl<SupportRepository>()));
  sl.registerLazySingleton(
    () => GetSupportStatsUseCase(sl<SupportRepository>()),
  );
  sl.registerLazySingleton(
    () => GetTicketMessagesUseCase(sl<SupportRepository>()),
  );
  sl.registerLazySingleton(
    () => RespondToTicketUseCase(sl<SupportRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateTicketStatusUseCase(sl<SupportRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateTicketPriorityUseCase(sl<SupportRepository>()),
  );

  sl.registerFactory(
    () => SupportCubit(
      getTicketsUseCase: sl<GetTicketsUseCase>(),
      getStatsUseCase: sl<GetSupportStatsUseCase>(),
      updateStatusUseCase: sl<UpdateTicketStatusUseCase>(),
      updatePriorityUseCase: sl<UpdateTicketPriorityUseCase>(),
      signalRService: sl<SignalRService>(),
    ),
  );

  sl.registerFactory(
    () => SupportChatCubit(
      getMessagesUseCase: sl<GetTicketMessagesUseCase>(),
      respondUseCase: sl<RespondToTicketUseCase>(),
      updateStatusUseCase: sl<UpdateTicketStatusUseCase>(),
      updatePriorityUseCase: sl<UpdateTicketPriorityUseCase>(),
      signalRService: sl<SignalRService>(),
    ),
  );

  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetReviewsUseCase(sl()));
  sl.registerLazySingleton(() => GetDeletedReviewsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerLazySingleton(() => RestoreReviewUseCase(sl()));

  sl.registerFactory(
    () => ReviewModerationCubit(
      getReviewsUseCase: sl(),
      getDeletedUseCase: sl(),
      deleteReviewUseCase: sl(),
      restoreUseCase: sl(),
    ),
  );
}
