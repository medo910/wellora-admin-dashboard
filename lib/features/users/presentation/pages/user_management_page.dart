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

// class UserManagementPage extends StatefulWidget {
//   const UserManagementPage({super.key});

//   @override
//   State<UserManagementPage> createState() => _UserManagementPageState();
// }

// class _UserManagementPageState extends State<UserManagementPage> {
//   List<UserEntity> selectedUsers = [];
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     // أول ما الصفحة تفتح، بنادي الداتا
//     context.read<UsersCubit>().fetchAllUsers();
//   }

//   void _onSearchChanged(String query, BuildContext context) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (query.length >= 2 || query.isEmpty) {
//         context.read<UsersCubit>().fetchAllUsers(searchTerm: query);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<UsersCubit, UsersState>(
//       // الـ Listener للأكشنز (رسائل النجاح والفشل)
//       listener: (context, state) {
//         if (state is UserActionSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else if (state is UserActionFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errMessage),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       // الـ Builder لبناء واجهة الجدول
//       builder: (context, state) {
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               UserManagementHeader(onExport: () => log("Exporting users...")),
//               const SizedBox(height: 32),

//               // 1. شريط البحث (Search Bar)
//               _buildSearchBar(context),
//               const SizedBox(height: 24),

//               // 2. معالجة حالات الصفحة (Loading, Success, Failure)
//               if (state is UsersLoading)
//                 const Center(
//                   child: CircularProgressIndicator(color: Color(0xFF0D9488)),
//                 )
//               else if (state is UsersFailure)
//                 Center(
//                   child: Text(
//                     state.errMessage,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 )
//               else if (state is UsersSuccess)
//                 _buildUsersContent(
//                   state.userResponse.doctors + state.userResponse.patients,
//                 )
//               else
//                 const SizedBox.shrink(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ميثود بناء البحث
//   Widget _buildSearchBar(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 400),
//       child: TextField(
//         onChanged: (value) {
//           // بتبعت البحث للكيوبت وهو بيتصرف مع السيرفر
//           // context.read<UsersCubit>().fetchAllUsers(searchTerm: value);
//           _onSearchChanged(value, context);
//         },
//         decoration: InputDecoration(
//           hintText: "Search users by name or email...",
//           prefixIcon: const Icon(Icons.search),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//         ),
//       ),
//     );
//   }

//   // ميثود بناء الجدول بالبيانات الحقيقية
//   Widget _buildUsersContent(List<UserEntity> allUsers) {
//     return UserTableWidget(
//       users: allUsers,
//       selectedUsers: selectedUsers,
//       onSelectAll: (value) {
//         setState(() {
//           selectedUsers = value! ? List.from(allUsers) : [];
//         });
//       },
//       onSelectUser: (user, isSelected) {
//         setState(() {
//           isSelected! ? selectedUsers.add(user) : selectedUsers.remove(user);
//         });
//       },
//     );
//   }
// }

// lib/features/users/presentation/pages/user_management_page.dart

// lib/features/users/presentation/pages/user_management_page.dart

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // List<UserEntity> selectedUsers = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchAllUsers();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final cubit = context.read<UsersCubit>();

  //   return BlocConsumer<UsersCubit, UsersState>(
  //     listener: (context, state) {
  //       if (state is UserActionSuccess) {
  //         {
  //           _showSnackBar(context, state.message, Colors.green);
  //         }
  //       }
  //       if (state is UserActionFailure) {
  //         _showSnackBar(context, state.errMessage, Colors.red);
  //       }
  //     },
  //     builder: (context, state) {
  //       return Padding(
  //         padding: const EdgeInsets.all(32),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             UserManagementHeader(onExport: () => log("Exporting...")),
  //             const SizedBox(height: 32),

  //             // 1. استخدام البحث المنفصل
  //             UserSearchBar(onSearch: (val) => _debounceSearch(val, cubit)),
  //             const SizedBox(height: 24),

  //             if (state is UsersLoading)
  //               const Expanded(
  //                 child: Center(
  //                   child: CircularProgressIndicator(color: Color(0xFF0D9488)),
  //                 ),
  //               )
  //             else if (state is UsersSuccess)
  //               Expanded(child: _buildTabs(state.userResponse, cubit))
  //             else
  //               const SizedBox.shrink(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
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
        // 💡 شيلنا الـ SingleChildScrollView من هنا عشان الـ Expanded يشتغل
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
                // 💡 الـ Expanded ده هو اللي هيخلي التابات تاخد باقي طول الصفحة
                Expanded(child: _buildTabs(state.userResponse, cubit))
              else
                const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  // ميثود الـ Tabs بقت أصغر بكتير
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

  // Widget _buildListView(List<UserEntity> users, bool isDoc, UsersCubit cubit) {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: SingleChildScrollView(
  //           child: UserTableWidget(
  //             users: users,
  //             selectedUsers: selectedUsers,
  //             onSelectAll: (v) => {},
  //             onSelectUser: (u, v) => {},
  //           ),
  //         ),
  //       ),
  //       UserPaginationBar(
  //         currentPage: isDoc ? cubit.doctorsPage : cubit.patientsPage,
  //         onPrevious: () => _changePage(isDoc, -1, cubit),
  //         onNext: () => _changePage(isDoc, 1, cubit),
  //       ),
  //     ],
  //   );
  // }
  // Widget _buildListView(List<UserEntity> users, bool isDoc, UsersCubit cubit) {
  //   return Column(
  //     children: [
  //       // 💡 الـ Expanded هنا بيخلي الجدول يملأ المساحة المتاحة في التاب
  //       Expanded(
  //         child: UserTableWidget(
  //           users: users,
  //           selectedUsers: selectedUsers,
  //           onSelectAll: (v) {},
  //           onSelectUser: (u, v) {},
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       UserPaginationBar(
  //         currentPage: isDoc ? cubit.doctorsPage : cubit.patientsPage,
  //         onPrevious: () => _changePage(isDoc, -1, cubit),
  //         onNext: () => _changePage(isDoc, 1, cubit),
  //       ),
  //     ],
  //   );
  // }
  // في ملف UserManagementPage.dart

  // في ملف UserManagementPage.dart

  Widget _buildListView(
    PaginatedData paginatedData,
    bool isDoc,
    UsersCubit cubit,
  ) {
    return Column(
      children: [
        Expanded(
          child: UserTableWidget(
            users: paginatedData.data, // الداتا اللي جوه الصندوق
            // selectedUsers: selectedUsers,
            // onSelectAll: (v) {},
            onSelectUser: (u, v) {},
          ),
        ),
        const SizedBox(height: 16),
        UserPaginationBar(
          currentPage: paginatedData.page, // رقم الصفحة من السيرفر
          onPrevious: paginatedData.page > 1
              ? () => _changePage(isDoc, -1, cubit)
              : null, // لو أول صفحة الزرار يطفي
          onNext: paginatedData.hasNextPage
              ? () => _changePage(isDoc, 1, cubit)
              : null, // لو مفيش صفحة تانية الزرار يطفي
        ),
      ],
    );
  }

  // --- Helpers ---
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
