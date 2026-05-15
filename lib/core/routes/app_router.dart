// lib/core/routes/app_router.dart
import 'package:admin_dashboard_graduation_project/core/di/injection_container.dart';
import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:admin_dashboard_graduation_project/core/di/session_manager.dart';
import 'package:admin_dashboard_graduation_project/core/shared_widgets/admin_scaffold.dart';
import 'package:admin_dashboard_graduation_project/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/auth/presentation/pages/login_page.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/notification_cubit/notification_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/sidebar_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/pages/dashboard_overview_page.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/pages/otp_page.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/pages/doctor_verification_page.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/manager/review_moderation_cubit/review_moderation_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/pages/review_moderation_page.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_cubit/support_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/pages/support_tickets_page.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/pages/user_management_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const kLogin = '/login';
  static const kDashboard = '/admin';
  static const kOtp = '/otp';
  static const kUsers = '/admin/users';
  static const kDoctorVerification = '/admin/doctor-verification';
  static const kSupportTickets = '/admin/support-tickets';
  static const kReviewModeration = '/admin/review-moderation';

  static final router = GoRouter(
    initialLocation: kDashboard,
    redirect: (context, state) async {
      final session = sl<SessionManager>();

      final status = await session.validateSession();

      final bool loggingIn = state.matchedLocation == kLogin;
      final bool isOtpPage = state.matchedLocation == kOtp;

      if (status == SessionStatus.invalid) {
        if (loggingIn || isOtpPage) return null;

        return kLogin;
      }

      if (status == SessionStatus.valid) {
        if (loggingIn || isOtpPage) return kDashboard;
      }

      return null;
    },
    routes: [
      GoRoute(path: kLogin, builder: (context, state) => const LoginPage()),
      GoRoute(
        path: kOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: OtpPage(
              mfaToken: extra['mfaToken'],
              email: extra['email'],
              password: extra['password'],
            ),
          );
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<SidebarCubit>()),
              BlocProvider(
                create: (context) =>
                    sl<NotificationCubit>()..fetchNotifications(),
              ),
            ],
            child: AdminScaffold(child: child),
          );
        },
        routes: [
          GoRoute(
            path: kDashboard,
            builder: (context, state) => BlocProvider(
              create: (context) => sl<DashboardCubit>()..getOverview(),
              child: const DashboardOverviewPage(),
            ),
          ),

          GoRoute(
            path: kUsers,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => sl<UsersCubit>()..fetchAllUsers(),
                child: const UserManagementPage(),
              );
            },
          ),
          GoRoute(
            path: kDoctorVerification,
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    sl<DoctorVerificationCubit>()..fetchVerificationData(),
                child: const DoctorVerificationPage(),
              );
            },
          ),
          GoRoute(
            path: kSupportTickets,
            builder: (context, state) {
              return BlocProvider(
                create: (context) => sl<SupportCubit>()..fetchSupportData(),
                child: const SupportTicketsPage(),
              );
            },
          ),
          GoRoute(
            path: kReviewModeration,
            builder: (context, state) {
              return BlocProvider(
                create: (context) =>
                    sl<ReviewModerationCubit>()..fetchReviews(),
                child: const ReviewModerationPage(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
