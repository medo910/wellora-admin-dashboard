import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_entity.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_details_dialog/details_header.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_details_dialog/info_sections.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_details_dialog/penalty_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildCloseButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: const Text("Close", style: TextStyle(color: Colors.black87)),
    ),
  );
}

void showUserDetailsDialog(BuildContext context, UserEntity user) {
  final usersCubit = context.read<UsersCubit>();

  showDialog(
    context: context,
    builder: (context) => BlocProvider.value(
      value: usersCubit,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _UserDetailsDialogBody(user: user),
      ),
    ),
  );
}

class _UserDetailsDialogBody extends StatefulWidget {
  final UserEntity user;
  const _UserDetailsDialogBody({required this.user});

  @override
  State<_UserDetailsDialogBody> createState() => _UserDetailsDialogBodyState();
}

class _UserDetailsDialogBodyState extends State<_UserDetailsDialogBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(24),
      child: FutureBuilder<UserStatusDetailsEntity>(
        future: context.read<UsersCubit>().fetchUserStatus(widget.user.userId),
        builder: (context, snapshot) {
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsHeader(user: widget.user),
                  const Divider(height: 40),
                  const SectionTitle(title: "Account Information"),
                  const SizedBox(height: 12),
                  GeneralInfoSection(user: widget.user),
                  const SizedBox(height: 24),
                  if (widget.user.userType == UserType.doctor)
                    DoctorInfoSection(user: widget.user)
                  else
                    PatientInfoSection(user: widget.user),
                  if (widget.user.isBlocked || widget.user.isSuspended) ...[
                    const SizedBox(height: 24),
                    PenaltySection(
                      user: widget.user,
                      details: snapshot.data,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildCloseButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
