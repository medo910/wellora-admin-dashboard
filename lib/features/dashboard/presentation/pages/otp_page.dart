// lib/features/auth/presentation/pages/otp_page.dart
import 'dart:async';

import 'package:admin_dashboard_graduation_project/core/routes/app_router.dart';
import 'package:admin_dashboard_graduation_project/core/theme/app_colors.dart';
import 'package:admin_dashboard_graduation_project/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatefulWidget {
  final String mfaToken;
  final String email;
  final String password;

  const OtpPage({
    super.key,
    required this.mfaToken,
    required this.email,
    required this.password,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  int _timerSeconds = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // 1. التوجيه للداشبورد فور النجاح
          context.go(AppRouter.kDashboard);
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Two-Step Verification",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "We've sent a verification code to ${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 32),

                  // حقول الـ OTP (ممكن تستخدم pinput أو TextField عادي)
                  TextField(
                    controller: _otpController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: _otpInputDecoration(),
                  ),

                  const SizedBox(height: 32),

                  _buildVerifyButton(context),

                  const SizedBox(height: 24),

                  _buildResendSection(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't receive the code? "),
        _timerSeconds > 0
            ? Text(
                "Resend in ${_timerSeconds}s",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : TextButton(
                onPressed: () {
                  context.read<AuthCubit>().resendOtp(widget.mfaToken); //
                  setState(() => _timerSeconds = 60);
                  _startTimer();
                },
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: state is LoginLoading
                ? null
                : () {
                    // هنا بننادي على اللوج إن تاني بس بالـ OTP
                    context.read<AuthCubit>().login(
                      email: widget.email,
                      password: widget.password,
                      otpCode: _otpController.text,
                    );
                  },
            child: state is LoginLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Verify & Access Dashboard",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        );
      },
    );
  }

  InputDecoration _otpInputDecoration() => InputDecoration(
    counterText: "",
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
