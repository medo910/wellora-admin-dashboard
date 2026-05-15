import 'package:admin_dashboard_graduation_project/core/routes/app_router.dart';
import 'package:admin_dashboard_graduation_project/core/theme/app_colors.dart';
import 'package:admin_dashboard_graduation_project/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) context.go(AppRouter.kDashboard);

        if (state is LoginOtpRequired) {
          context.push(
            AppRouter.kOtp,
            extra: {
              'email': _emailController.text.trim(),
              'mfaToken': state.mfaToken,
              'password': _passwordController.text.trim(),
            },
          );
        }

        if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your admin credentials to access the dashboard",
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 32),

            _buildLabel("Email Address"),
            TextField(
              controller: _emailController,
              decoration: _inputDecoration("admin@wellora.com"),
            ),

            const SizedBox(height: 20),

            _buildLabel("Password"),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration("••••••••"),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: state is LoginLoading
                    ? null
                    : () {
                        context.read<AuthCubit>().login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                child: state is LoginLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Sign In to Dashboard",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );
}
