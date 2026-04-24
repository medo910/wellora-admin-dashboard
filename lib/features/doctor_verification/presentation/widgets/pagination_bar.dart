import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorVerificationCubit, DoctorVerificationState>(
      builder: (context, state) {
        if (state is! DoctorVerificationSuccess) return const SizedBox();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing page ${state.page} of ${((state.totalItems) / 10).ceil()}",
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              Row(
                children: [
                  _pageButton(
                    label: "Previous",
                    icon: Icons.chevron_left,
                    isEnabled: state.page > 1,
                    onTap: () => context
                        .read<DoctorVerificationCubit>()
                        .fetchVerificationData(page: state.page - 1),
                  ),
                  const SizedBox(width: 12),
                  _pageButton(
                    label: "Next",
                    icon: Icons.chevron_right,
                    isEnabled: state.hasNextPage,
                    onTap: () => context
                        .read<DoctorVerificationCubit>()
                        .fetchVerificationData(page: state.page + 1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pageButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: isEnabled ? onTap : null,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnabled ? Colors.teal : Colors.grey,
        side: BorderSide(
          color: isEnabled ? Colors.teal.shade200 : Colors.grey.shade200,
        ),
      ),
    );
  }
}
