import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import '../widgets/verification_header.dart';
import '../widgets/verification_stats_bar.dart';
import '../widgets/verification_tabs_view.dart';
import '../widgets/pagination_bar.dart';

class DoctorVerificationPage extends StatefulWidget {
  const DoctorVerificationPage({super.key});

  @override
  State<DoctorVerificationPage> createState() => _DoctorVerificationPageState();
}

class _DoctorVerificationPageState extends State<DoctorVerificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorVerificationCubit>().fetchVerificationData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorVerificationCubit, DoctorVerificationState>(
      listener: (context, state) {
        if (state is VerificationActionSuccess) {
          _showSnackBar(context, state.message, Colors.green);
        }
        if (state is VerificationActionFailure) {
          _showSnackBar(context, state.errMessage, Colors.red);
        }
      },

      builder: (context, state) {
        final cubit = context.read<DoctorVerificationCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerificationHeader(),
                  const SizedBox(height: 32),

                  if (state is DoctorVerificationSuccess ||
                      cubit.lastStats != null) ...[
                    VerificationStatsBar(
                      stats: state is DoctorVerificationSuccess
                          ? state.stats
                          : cubit.lastStats!,
                    ),
                    const SizedBox(height: 32),

                    VerificationTabsView(
                      verifications: state is DoctorVerificationSuccess
                          ? state.verifications
                          : [],
                      currentStatus: state is DoctorVerificationSuccess
                          ? state.currentStatus
                          : cubit.currentStatus,
                    ),
                    const SizedBox(height: 32),
                    const PaginationBar(),
                  ] else if (state is DoctorVerificationLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(100.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state is DoctorVerificationFailure)
                    Center(child: Text(state.errMessage)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
