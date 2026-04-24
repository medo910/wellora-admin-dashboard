import 'dart:async';
import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_support_stats_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_tickets_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_priority_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_status_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'support_state.dart';

// class SupportCubit extends Cubit<SupportState> {
//   final GetTicketsUseCase getTicketsUseCase;
//   final GetSupportStatsUseCase getStatsUseCase;
//   final UpdateTicketStatusUseCase updateStatusUseCase;
//   final UpdateTicketPriorityUseCase updatePriorityUseCase;
//   final SignalRService _signalRService;

//   SupportCubit({
//     required this.getTicketsUseCase,
//     required this.getStatsUseCase,
//     required this.updateStatusUseCase,
//     required this.updatePriorityUseCase,
//     required SignalRService signalRService,
//   }) : _signalRService = signalRService,
//        super(SupportInitial()) {
//     _listenToGlobalEvents();
//   }

//   Timer? _searchTimer;
//   SupportStatsEntity? lastStats;
//   int _currentPage = 1;
//   int _pageSize = 10;
//   String? _currentStatus;
//   String? _currentPriority;
//   String? _currentCategory;
//   String? _currentSearch;
//   String? _fromDate;
//   String? _toDate;
//   String? _sortBy;
//   bool _descending = true;
//   int? _targetUserId;

//   void searchTickets(String query) {
//     _searchTimer?.cancel(); // كنسل أي تايمر شغال
//     _searchTimer = Timer(const Duration(milliseconds: 600), () {
//       _currentSearch = query.isEmpty ? null : query;
//       _currentPage = 1; // ارجع لصفحة 1 لما نبحث
//       fetchSupportData(isRefresh: false); // ابدأ البحث
//     });
//   }

//   // void _listenToGlobalEvents() {
//   //   // 1. الاستماع لتحديث أي تيكت (تغيير حالة أو أولوية)
//   //   _signalRService.on("TicketUpdated", (arguments) {
//   //     // دليل الباك-إند بيقول نحدث الـ Badge/Status فوراً
//   //     // أحسن حل هنا إننا نطلب الإحصائيات والداتا تاني عشان نضمن الدقة
//   //     fetchSupportData(isRefresh: true);
//   //   });

//   //   // 2. الاستماع لو فيه تيكت جديدة اتعملت
//   //   _signalRService.on("TicketCreated", (arguments) {
//   //     // نحدث القائمة عشان تظهر التيكت الجديدة فوق
//   //     fetchSupportData(isRefresh: true);
//   //   });
//   // }
//   void _listenToGlobalEvents() {
//     _signalRService.on("TicketUpdated", (arguments) {
//       if (arguments != null && arguments.isNotEmpty) {
//         // 1. استلام البيانات الجديدة من SignalR
//         final updatedData = arguments[0] as Map<String, dynamic>;
//         final String ticketId = updatedData['id'];
//         final String newStatus = updatedData['status'];
//         final String newPriority = updatedData['priority'];

//         // 2. التحديث في الـ Local State (الذاكرة) بدون Loading
//         _updateTicketInList(ticketId, newStatus, newPriority);
//       }
//     });
//   }

//   void _updateTicketInList(String id, String status, String priority) {
//     // بنشيك لو إحنا حالياً في حالة Success وعندنا داتا
//     if (state is SupportSuccess) {
//       final currentState = state as SupportSuccess;

//       // بنعمل خريطة جديدة للقائمة ونحدث العنصر المطلوب فقط
//       final updatedTickets = currentState.tickets.map((ticket) {
//         if (ticket.id == id) {
//           // بنرجع نسخة جديدة من التيكت بالبيانات المحدثة
//           return ticket.copyWith(status: status, priority: priority);
//         }
//         return ticket;
//       }).toList();

//       // 3. بنبعت SuccessState فوراً بالقائمة الجديدة
//       // 🚀 لاحظ: مفيش Loading هنا، فـ الـ UI هيتحدث "سكتي"
//       emit(currentState.copyWith(tickets: updatedTickets));

//       // اختياري: لو عاوز تحدث الإحصائيات برضه لحظياً ممكن تنادي الـ statistics REST
//       // بس الدليل بيفضل إنك تعمل ده بذكاء أو لما ترجع للداشبورد
//     }
//   }

//   void filterByDateRange(DateTime start, DateTime end) {
//     fetchSupportData(
//       fromDate: start.toIso8601String(),
//       toDate: end.toIso8601String(),
//       page: 1,
//     );
//   }

//   Future<void> fetchSupportData({
//     int? page,
//     int? pageSize,
//     String? status,
//     String? priority,
//     String? category,
//     String? searchTerm,
//     String? fromDate,
//     String? toDate,
//     String? sortBy,
//     bool? descending,
//     int? userId,
//     bool isRefresh = true, // لو true بيظهر الـ Full Loading Spinner
//   }) async {
//     // 1. تحديث المخزن الداخلي بالقيم الجديدة (لو مبعوتة)
//     if (page != null) _currentPage = page;
//     if (pageSize != null) _pageSize = pageSize;
//     if (status != null) _currentStatus = (status == "All") ? null : status;
//     if (priority != null) {
//       _currentPriority = (priority == "All") ? null : priority;
//     }
//     if (category != null) {
//       _currentCategory = (category == "All") ? null : category;
//     }
//     if (searchTerm != null) {
//       _currentSearch = (searchTerm.isEmpty) ? null : searchTerm;
//     }
//     if (fromDate != null) _fromDate = fromDate;
//     if (toDate != null) _toDate = toDate;
//     if (sortBy != null) _sortBy = sortBy;
//     if (descending != null) _descending = descending;
//     if (userId != null) _targetUserId = userId;

//     // 2. إظهار حالة التحميل
//     if (isRefresh) emit(SupportLoading());

//     final results = await Future.wait([
//       getStatsUseCase(),
//       getTicketsUseCase(
//         page: _currentPage,
//         pageSize: _pageSize,
//         status: _currentStatus,
//         priority: _currentPriority,
//         category: _currentCategory,
//         searchTerm: _currentSearch,
//         fromDate: _fromDate,
//         toDate: _toDate,
//         sortBy: _sortBy,
//         descending: _descending,
//         userId: _targetUserId,
//       ),
//     ]);

//     final statsResult = results[0] as Either<Failure, SupportStatsEntity>;
//     final ticketsResult =
//         results[1] as Either<Failure, SupportTicketsPaginatedEntity>;

//     statsResult.fold((failure) => emit(SupportFailure(failure.errmessage)), (
//       stats,
//     ) {
//       lastStats = stats;
//       ticketsResult.fold(
//         (failure) => emit(SupportFailure(failure.errmessage)),
//         (paginatedData) {
//           emit(
//             SupportSuccess(
//               tickets: paginatedData.tickets,
//               stats: stats,
//               currentPage: _currentPage,
//               hasNextPage: paginatedData.hasNextPage,
//               totalItems: paginatedData.totalCount,
//               currentStatus: _currentStatus,
//               currentPriority: _currentPriority,
//               currentCategory: _currentCategory, // لو محتاج تعرضه في الـ UI
//               currentDateRange: (_fromDate != null && _toDate != null)
//                   ? DateTimeRange(
//                       start: DateTime.parse(_fromDate!),
//                       end: DateTime.parse(_toDate!),
//                     )
//                   : null,
//             ),
//           );
//         },
//       );
//     });
//   }

//   // 💡 تغيير الحالة (قفل التيكت أو فتحها)
//   Future<void> changeStatus(String ticketId, String status) async {
//     emit(SupportActionLoading());
//     final result = await updateStatusUseCase(ticketId, status);
//     result.fold((failure) => emit(SupportActionFailure(failure.errmessage)), (
//       msg,
//     ) {
//       emit(SupportActionSuccess(msg));
//       fetchSupportData(isRefresh: false); // تحديث بدون Spinner كامل
//     });
//   }

//   // 💡 ميثود لتغيير الـ Priority من الـ UI
//   Future<void> updatePriority(String ticketId, String newPriority) async {
//     emit(SupportActionLoading());
//     final result = await updatePriorityUseCase(ticketId, newPriority);
//     result.fold((failure) => emit(SupportActionFailure(failure.errmessage)), (
//       successMsg,
//     ) {
//       emit(SupportActionSuccess(successMsg));
//       fetchSupportData(isRefresh: false); // تحديث القائمة
//     });
//   }

//   @override
//   Future<void> close() {
//     _searchTimer?.cancel(); // تنظيف التايمر لما الكيوبت يقفل
//     return super.close();
//   }

//   void resetAllFilters() {
//     // 1. تصفير كل المخازن الداخلية
//     _currentStatus = null;
//     _currentPriority = null;
//     _currentCategory = null;
//     _currentSearch = null;
//     _fromDate = null;
//     _toDate = null;
//     _currentPage = 1;

//     // 2. طلب الداتا من جديد وهي "فارغة"
//     fetchSupportData(isRefresh: true);
//   }
// }

// class SupportCubit extends Cubit<SupportState> {
//   final GetTicketsUseCase getTicketsUseCase;
//   final GetSupportStatsUseCase getStatsUseCase;
//   final UpdateTicketStatusUseCase updateStatusUseCase;
//   final UpdateTicketPriorityUseCase updatePriorityUseCase;
//   final SignalRService _signalRService;

//   SupportCubit({
//     required this.getTicketsUseCase,
//     required this.getStatsUseCase,
//     required this.updateStatusUseCase,
//     required this.updatePriorityUseCase,
//     required SignalRService signalRService,
//   }) : _signalRService = signalRService,
//        super(SupportInitial()) {
//     print("🏗️ SupportCubit: Created and initializing listeners...");
//     _listenToGlobalEvents();
//   }

//   Timer? _searchTimer;
//   int _currentPage = 1;
//   // قيم افتراضية بدل late عشان نمنع الكراش
//   String _currentStatus = "All", _currentPriority = "All";
//   String _currentCategory = "All";
//   String? _currentSearch;

//   // 📡 الاستماع للأحداث اللحظية
//   void _listenToGlobalEvents() {
//     _signalRService.on("TicketUpdated", (arguments) {
//       if (arguments != null && arguments.isNotEmpty) {
//         try {
//           final data = arguments[0] as Map<String, dynamic>;

//           // 1. 🚀 تصحيح الكي: السيرفر بيبعت ticketId
//           final String tId = data['ticketId'].toString();

//           // 2. 🚀 تصحيح النوع: تحويل الأرقام لكلمات (Mapping)
//           // دي الحالات المشهورة في الباك-إند (تأكد من ترتيبها مع زميلك)
//           final String translatedStatus = _mapStatusIntToString(data['status']);
//           final String translatedPriority = _mapPriorityIntToString(
//             data['priority'],
//           );

//           print("📥 Data Translated: ID=$tId, Status=$translatedStatus");

//           _handleInMemoryUpdate(
//             id: tId,
//             newStatus: translatedStatus,
//             newPriority: translatedPriority,
//           );
//         } catch (e) {
//           print("❌ Error parsing TicketUpdated data: $e");
//         }
//       }
//     });
//   }

//   String _mapStatusIntToString(dynamic status) {
//     switch (status.toString()) {
//       case '0':
//         return 'Open';
//       case '1':
//         return 'InProgress';
//       case '2':
//         return 'Resolved';
//       case '3':
//         return 'Closed';
//       default:
//         return 'Open';
//     }
//   }

//   // 🌐 مترجم الأولوية (Priority Mapper)
//   String _mapPriorityIntToString(dynamic priority) {
//     switch (priority.toString()) {
//       case '0':
//         return 'Low';
//       case '1':
//         return 'Normal';
//       case '2':
//         return 'High';
//       case '3':
//         return 'Urgent';
//       default:
//         return 'Low';
//     }
//   }

//   // 🛠️ تحديث الذاكرة المحلية (In-Memory)
//   void _handleInMemoryUpdate({
//     required String id,
//     required String newStatus,
//     required String newPriority,
//   }) {
//     if (state is SupportSuccess) {
//       final currentState = state as SupportSuccess;
//       print("🧠 Updating Ticket $id in Local Memory...");

//       // تحديث العنصر في القائمة
//       final updatedList = currentState.tickets.map((t) {
//         if (t.id.toString() == id) {
//           print(
//             "🎯 Found match for Ticket $id. Status changed: ${t.status} -> $newStatus",
//           );
//           return t.copyWith(status: newStatus, priority: newPriority);
//         }
//         return t;
//       }).toList();

//       // منطق الفلترة (لو الأدمن فاتح تاب معين)
//       if (currentState.currentStatus != null &&
//           currentState.currentStatus != "All") {
//         print(
//           "🧹 Filtering: Checking if ticket $id still belongs to tab ${currentState.currentStatus}",
//         );
//         updatedList.removeWhere(
//           (t) =>
//               t.id.toString() == id && t.status != currentState.currentStatus,
//         );
//       }

//       print(
//         "📤 Emitting SuccessState with updated list. Length: ${updatedList.length}",
//       );
//       emit(currentState.copyWith(tickets: updatedList));
//     } else {
//       print(
//         "⚠️ Local update skipped: State is not SupportSuccess (current: ${state.runtimeType})",
//       );
//     }
//   }

//   void searchTickets(String query) {
//     _searchTimer?.cancel(); // كنسل أي تايمر شغال
//     _searchTimer = Timer(const Duration(milliseconds: 600), () {
//       _currentSearch = query.isEmpty ? null : query;
//       _currentPage = 1; // ارجع لصفحة 1 لما نبحث
//       fetchSupportData(isRefresh: false); // ابدأ البحث
//     });
//   }

//   // 📥 جلب الداتا (REST)
//   Future<void> fetchSupportData({
//     bool isRefresh = true,
//     String? status,
//     String? priority,
//     String? category,
//     String? fromDate,
//     String? toDate,
//     String? search,
//     int? page,
//   }) async {
//     print(
//       "📥 Fetching Support Data (REST). Refresh: $isRefresh, Status: $status",
//     );
//     if (isRefresh) emit(SupportLoading());

//     // تحديث المتغيرات الداخلية
//     if (status != null) _currentStatus = status;
//     if (category != null) _currentCategory = category;
//     if (search != null) _currentSearch = search;
//     if (page != null) _currentPage = page;

//     final results = await Future.wait([
//       getStatsUseCase(),
//       getTicketsUseCase(
//         page: _currentPage,
//         status: (_currentStatus == "All") ? null : _currentStatus,
//         priority: (_currentPriority == "All") ? null : _currentPriority,
//         category: (_currentCategory == "All") ? null : _currentCategory,
//         fromDate: fromDate,
//         toDate: toDate,
//         searchTerm: _currentSearch,
//       ),
//     ]);

//     final statsResult = results[0] as Either<Failure, SupportStatsEntity>;
//     final ticketsResult =
//         results[1] as Either<Failure, SupportTicketsPaginatedEntity>;

//     statsResult.fold(
//       (f) {
//         print("❌ Stats Fetch Failed: ${f.errmessage}");
//         emit(SupportFailure(f.errmessage));
//       },
//       (stats) {
//         ticketsResult.fold(
//           (f) {
//             print("❌ Tickets Fetch Failed: ${f.errmessage}");
//             emit(SupportFailure(f.errmessage));
//           },
//           (paginated) {
//             print("✅ REST Data loaded. Tickets: ${paginated.tickets.length}");
//             emit(
//               SupportSuccess(
//                 tickets: paginated.tickets,
//                 stats: stats,
//                 currentPage: _currentPage,
//                 hasNextPage: paginated.hasNextPage,
//                 totalItems: paginated.totalCount,
//                 currentStatus: (_currentStatus == "All")
//                     ? null
//                     : _currentStatus,
//                 currentPriority: (_currentPriority == "All")
//                     ? null
//                     : _currentPriority,
//                 currentCategory: (_currentCategory == "All")
//                     ? null
//                     : _currentCategory,
//                 currentSearch: _currentSearch,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ميثود إضافية لتغيير الحالة (PATCH)
//   Future<void> changeStatus(String ticketId, String status) async {
//     print("🚀 Action: Changing status of $ticketId to $status");
//     emit(SupportActionLoading());
//     final result = await updateStatusUseCase(ticketId, status);
//     result.fold((f) => emit(SupportActionFailure(f.errmessage)), (msg) {
//       print(
//         "✅ Status updated on server. Local update will follow via SignalR.",
//       );
//       emit(SupportActionSuccess(msg));
//       // ملحوظة: مش محتاج تنادي fetchSupportData هنا لأن الـ SignalR هيقوم بالواجب
//     });
//   }

//   void resetAllFilters() {
//     print("🧹 Resetting all filters...");
//     _currentStatus = "All";
//     _currentPage = 1;
//     _currentPriority = "All";
//     _currentCategory = "All";
//     _currentSearch = null;
//     fetchSupportData(isRefresh: true);
//   }
// }

// features/support_tickets/presentation/manager/support_chat_cubit/support_cubit.dart

class SupportCubit extends Cubit<SupportState> {
  final GetTicketsUseCase getTicketsUseCase;
  final GetSupportStatsUseCase getStatsUseCase;
  final UpdateTicketStatusUseCase updateStatusUseCase;
  final UpdateTicketPriorityUseCase updatePriorityUseCase;
  final SignalRService _signalRService;

  SupportCubit({
    required this.getTicketsUseCase,
    required this.getStatsUseCase,
    required this.updateStatusUseCase,
    required this.updatePriorityUseCase,
    required SignalRService signalRService,
  }) : _signalRService = signalRService,
       super(SupportInitial()) {
    _listenToGlobalEvents();
  }

  // 1. 🚀 المتغيرات الداخلية بقيم ابتدائية واضحة (عشان الـ Filter Sheet تقرأها)
  int _currentPage = 1;
  int _pageSize = 10;
  String _currentStatus = "All";
  String _currentPriority = "All";
  String _currentCategory = "All";
  String? _currentSearch;
  String? _fromDate;
  String? _toDate;
  String? _sortBy;
  bool _descending = true;
  int? _targetUserId;
  Timer? _searchTimer;

  // 📡 Listeners (نفس الكود بتاعك شغال صح)
  void _listenToGlobalEvents() {
    _signalRService.on("TicketUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final data = arguments[0] as Map<String, dynamic>;
          final String tId = data['ticketId'].toString();
          final String translatedStatus = _mapStatusIntToString(data['status']);
          final String translatedPriority = _mapPriorityIntToString(
            data['priority'],
          );

          _handleInMemoryUpdate(
            id: tId,
            newStatus: translatedStatus,
            newPriority: translatedPriority,
          );
        } catch (e) {
          print("❌ SignalR Parse Error: $e");
        }
      }
    });

    _signalRService.on(
      "TicketCreated",
      (_) => fetchSupportData(isRefresh: false),
    );
  }

  // 📥 الميثود الموحدة للجلب (REST)
  Future<void> fetchSupportData({
    int? page,
    String? status,
    String? priority,
    String? category,
    String? searchTerm,
    String? fromDate,
    String? toDate,
    bool isRefresh = true,
  }) async {
    // 2. 🚀 تحديث المخزن الداخلي دايماً
    if (page != null) _currentPage = page;
    if (status != null) _currentStatus = status;
    if (priority != null) _currentPriority = priority;
    if (category != null) _currentCategory = category;
    if (searchTerm != null)
      _currentSearch = searchTerm.isEmpty ? null : searchTerm;
    if (fromDate != null) _fromDate = fromDate;
    if (toDate != null) _toDate = toDate;

    if (isRefresh) emit(SupportLoading());

    // 3. 🚀 تحويل "All" لـ null فقط عند مناداة الـ API (عشان الباك-إند)
    final results = await Future.wait([
      getStatsUseCase(),
      getTicketsUseCase(
        page: _currentPage,
        pageSize: _pageSize,
        status: (_currentStatus == "All") ? null : _currentStatus,
        priority: (_currentPriority == "All") ? null : _currentPriority,
        category: (_currentCategory == "All") ? null : _currentCategory,
        searchTerm: _currentSearch,
        fromDate: _fromDate,
        toDate: _toDate,
        sortBy: _sortBy,
        descending: _descending,
        userId: _targetUserId,
      ),
    ]);

    final statsResult = results[0] as Either<Failure, SupportStatsEntity>;
    final ticketsResult =
        results[1] as Either<Failure, SupportTicketsPaginatedEntity>;

    statsResult.fold((f) => emit(SupportFailure(f.errmessage)), (stats) {
      ticketsResult.fold((f) => emit(SupportFailure(f.errmessage)), (
        paginatedData,
      ) {
        // 4. 🚀 نبعت القيم "الأصلية" (زي All) للـ UI عشان الفيلتر ميتصفّرش
        emit(
          SupportSuccess(
            tickets: paginatedData.tickets,
            stats: stats,
            currentPage: _currentPage,
            hasNextPage: paginatedData.hasNextPage,
            totalItems: paginatedData.totalCount,
            currentStatus: _currentStatus, // هيروح للـ UI كـ "All"
            currentPriority: _currentPriority,
            currentCategory: _currentCategory,
            currentDateRange: (_fromDate != null && _toDate != null)
                ? DateTimeRange(
                    start: DateTime.parse(_fromDate!),
                    end: DateTime.parse(_toDate!),
                  )
                : null,
          ),
        );
      });
    });
  }

  // 🛠️ باقي الميثودات (In-Memory Update & Mappers)
  void _handleInMemoryUpdate({
    required String id,
    required String newStatus,
    required String newPriority,
  }) {
    if (state is SupportSuccess) {
      final currentState = state as SupportSuccess;
      final updatedList = currentState.tickets.map((t) {
        if (t.id.toString() == id) {
          return t.copyWith(status: newStatus, priority: newPriority);
        }
        return t;
      }).toList();

      // فلترة فورية لو الأدمن واقف في تاب معين
      if (currentState.currentStatus != "All") {
        updatedList.removeWhere(
          (t) =>
              t.id.toString() == id && t.status != currentState.currentStatus,
        );
      }

      emit(currentState.copyWith(tickets: updatedList));
    }
  }

  void resetAllFilters() {
    _currentStatus = "All";
    _currentPriority = "All";
    _currentCategory = "All";
    _currentSearch = null;
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchSupportData(isRefresh: true);
  }

  String _mapStatusIntToString(dynamic s) =>
      ["Open", "InProgress", "Resolved", "Closed"][int.parse(s.toString())];
  String _mapPriorityIntToString(dynamic p) =>
      ["Low", "Normal", "High", "Urgent"][int.parse(p.toString())];

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }

  void searchTickets(String query) {
    // 1. كنسل أي تايمر قديم عشان لو المستخدم بيكتب بسرعة ما نبعتش ريكويستات كتير (Debouncing)
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 600), () {
      // 2. تحديث قيمة البحث الحالية
      _currentSearch = query.isEmpty ? null : query;

      // 3. دايماً ارجع لصفحة 1 لما تبدأ بحث جديد
      _currentPage = 1;

      print("🔍 Searching for: $_currentSearch");

      // 4. نداء ميثود الـ Fetch مع تعطيل الـ Loading Spinner عشان اليوزر ما يتضايقش وهو بيكتب
      fetchSupportData(isRefresh: false);
    });
  }
}
