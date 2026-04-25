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
  static const kOtp = '/otp'; // إضافة مسار الـ OTP
  static const kUsers = '/admin/users'; // 1. إضافة مسار المستخدمين
  static const kDoctorVerification = '/admin/doctor-verification';
  static const kSupportTickets = '/admin/support-tickets';
  static const kReviewModeration = '/admin/review-moderation';

  static final router = GoRouter(
    initialLocation: kDashboard,
    redirect: (context, state) async {
      // final token = await SecureStorageHelper.getAccessToken(); // [cite: 98]
      // final bool loggingIn = state.matchedLocation == kLogin;
      // final bool isOtpPage = state.matchedLocation == kOtp; // 1. ضيف السطر ده

      // if (token == null) {
      //   if (loggingIn || isOtpPage) return null;
      //   return kLogin;
      // }

      // if (loggingIn || isOtpPage) return kDashboard;
      // return null;
      final session = sl<SessionManager>();

      // 1. نادى الـ validateSession عشان يحمل البيانات
      final status = await session.validateSession();

      // 2. حدد إحنا فين دلوقتي
      final bool loggingIn = state.matchedLocation == kLogin;
      final bool isOtpPage =
          state.matchedLocation == kOtp; // 🚀 لازم نضيف السطر ده

      // 3. لو الجلسة غير صالحة (يعني مفيش Token)
      if (status == SessionStatus.invalid) {
        // 💡 لو هو بيحاول يروح للوجين أو الـ OTP سيبه يروح (رجع null)
        if (loggingIn || isOtpPage) return null;

        // غير كدا، لو بيحاول يدخل أي صفحة تانية وهو مش مسجل، اطرده للوجين
        return kLogin;
      }

      // 4. لو الجلسة صالحة (مسجل دخول كامل) وهو لسه واقف في اللوجين أو الـ OTP
      if (status == SessionStatus.valid) {
        if (loggingIn || isOtpPage) return kDashboard;
      }

      return null; // سيبه يكمل في طريقه العادي
    },
    routes: [
      GoRoute(path: kLogin, builder: (context, state) => const LoginPage()),
      GoRoute(
        path: kOtp,
        builder: (context, state) {
          // استقبال البيانات المطلوبة لصفحة الـ OTP
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
          // بنغلف الـ AdminScaffold بالكيوبت عشان الـ Sidebar يقدر يشوفه
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
          // GoRoute(
          //   path: kUsers,
          //   builder: (context, state) => const UserManagementPage(),
          //   // ملحوظة: لما تعمل UsersCubit، هتلف الصفحة بـ BlocProvider هنا زي الداشبورد
          // )
          // ,
          GoRoute(
            path: kUsers,
            builder: (context, state) {
              // 💡 لازم نلف الصفحة بالـ Provider هنا عشان الـ context بتاعها يشوف الكيوبت
              return BlocProvider(
                create: (context) =>
                    sl<UsersCubit>()
                      ..fetchAllUsers(), // بينادي الداتا أول ما يفتح
                child: const UserManagementPage(),
              );
            },
          ),
          GoRoute(
            path: kDoctorVerification,
            builder: (context, state) {
              return BlocProvider(
                // بننادي الداتا أول ما الصفحة تفتح أوتوماتيكياً
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
