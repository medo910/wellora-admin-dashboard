import 'dart:async';
import 'dart:developer';
import 'package:admin_dashboard_graduation_project/features/users/data/models/user_response_model.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_pagination_bar.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/user_management_header.dart';
import '../widgets/user_table_widget.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    return BlocConsumer<UsersCubit, UsersState>(
      listener: (context, state) {
        if (state is UserActionSuccess) {
          _showSnackBar(context, state.message, Colors.green);
        }
        if (state is UserActionFailure) {
          _showSnackBar(context, state.errMessage, Colors.red);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserManagementHeader(onExport: () => log("Exporting...")),
              const SizedBox(height: 32),
              UserSearchBar(onSearch: (val) => _debounceSearch(val, cubit)),
              const SizedBox(height: 24),

              if (state is UsersLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF0D9488)),
                  ),
                )
              else if (state is UsersFailure)
                Expanded(
                  child: Center(
                    child: Text(
                      state.errMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else if (state is UsersSuccess)
                Expanded(child: _buildTabs(state.userResponse, cubit))
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(UserResponseModel data, UsersCubit cubit) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: const Color(0xFF0D9488),
            tabs: [
              Tab(text: "Doctors (${data.doctors.data.length})"),
              Tab(text: "Patients (${data.patients.data.length})"),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                _buildListView(data.doctors, true, cubit),
                _buildListView(data.patients, false, cubit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(
    PaginatedData paginatedData,
    bool isDoc,
    UsersCubit cubit,
  ) {
    return Column(
      children: [
        Expanded(
          child: UserTableWidget(
            users: paginatedData.data,
            // selectedUsers: selectedUsers,
            // onSelectAll: (v) {},
            onSelectUser: (u, v) {},
          ),
        ),
        const SizedBox(height: 16),
        UserPaginationBar(
          currentPage: paginatedData.page,
          onPrevious: paginatedData.page > 1
              ? () => _changePage(isDoc, -1, cubit)
              : null,
          onNext: paginatedData.hasNextPage
              ? () => _changePage(isDoc, 1, cubit)
              : null,
        ),
      ],
    );
  }

  void _debounceSearch(String query, UsersCubit cubit) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => cubit.fetchAllUsers(searchTerm: query),
    );
  }

  void _changePage(bool isDoc, int delta, UsersCubit cubit) {
    if (isDoc) {
      cubit.doctorsPage += delta;
    } else {
      cubit.patientsPage += delta;
    }
    cubit.fetchAllUsers(isRefresh: false);
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
