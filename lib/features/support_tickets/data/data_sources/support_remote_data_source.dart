// // lib/features/support_tickets/data/data_sources/support_remote_data_source.dart
// import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
// import 'package:admin_dashboard_graduation_project/features/support_tickets/data/models/support_ticket_model.dart';
// import 'package:admin_dashboard_graduation_project/features/support_tickets/data/models/ticket_message_model.dart';

// class SupportRemoteDataSource {
//   final ApiService apiService;
//   SupportRemoteDataSource(this.apiService);

//   Future<List<SupportTicketModel>> getTickets(
//     Map<String, dynamic> query,
//   ) async {
//     final response = await apiService.get(
//       endpoint: "/api/admin/tickets",
//       queryParameters: query,
//     );
//     return (response['tickets'] as List)
//         .map((e) => SupportTicketModel.fromJson(e))
//         .toList();
//   }

//   Future<List<TicketMessageModel>> getTicketMessages(String ticketId) async {
//     final response = await apiService.get(
//       endpoint: "/api/tickets/$ticketId/messages",
//     );
//     return (response['messages'] as List)
//         .map((e) => TicketMessageModel.fromJson(e))
//         .toList();
//   }

//   // 💡 لاحظ استخدام الـ PATCH للـ Status زي ما اتفقنا
//   Future<void> updateStatus(String ticketId, String status) async {
//     await apiService.patch(
//       endpoint: "/api/tickets/$ticketId",
//       data: {"status": status},
//     );
//   }

//   Future<TicketMessageModel> respond(String ticketId, String message) async {
//     final response = await apiService.post(
//       endpoint: "/api/admin/tickets/respond",
//       body: {"ticketId": ticketId, "message": message},
//     );
//     return TicketMessageModel.fromJson(response);
//   }
// }

// lib/features/support_tickets/data/data_sources/support_remote_data_source.dart

import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/data/models/support_tickets_paginated_model.dart';

import '../models/support_stats_model.dart';
import '../models/ticket_message_model.dart';

abstract class SupportRemoteDataSource {
  // Future<List<SupportTicketModel>> getTickets({
  //   int? page,
  //   String? status,
  //   String? priority,
  //   String? category,
  // });
  Future<SupportTicketsPaginatedModel> getTickets({
    int? page,
    int? pageSize,
    String? status,
    String? priority,
    String? category,
    int? userId,
    String? searchTerm,
    String? fromDate,
    String? toDate,
    String? sortBy,
    bool descending = true,
  });
  Future<List<TicketMessageModel>> getTicketMessages(String ticketId);
  Future<TicketMessageModel> respondToTicket(String ticketId, String message);
  Future<void> updateTicketStatus(String ticketId, String status);
  Future<void> updateTicketPriority(String ticketId, String priority);
  Future<SupportStatsModel> getTicketsStatistics();
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final ApiService apiService;
  SupportRemoteDataSourceImpl(this.apiService);

  // @override
  // Future<List<SupportTicketModel>> getTickets({
  //   int? page,
  //   String? status,
  //   String? priority,
  //   String? category,
  // }) async {
  //   final response = await apiService.get(
  //     endpoint: "/api/admin/tickets",
  //     queryParameters: {
  //       'page': page ?? 1,
  //       'pageSize': 10,
  //       if (status != null) 'status': status,
  //       if (priority != null) 'priority': priority,
  //       if (category != null) 'category': category,
  //       'descending': true,
  //     },
  //   );
  //   return (response['tickets'] as List)
  //       .map((e) => SupportTicketModel.fromJson(e))
  //       .toList();
  // }

  @override
  Future<SupportTicketsPaginatedModel> getTickets({
    int? page,
    int? pageSize,
    String? status,
    String? priority,
    String? category,
    int? userId,
    String? searchTerm,
    String? fromDate,
    String? toDate,
    String? sortBy,
    bool descending = true,
  }) async {
    final response = await apiService.get(
      endpoint: "admin/tickets",
      queryParameters: {
        'page': page ?? 1,
        'pageSize': pageSize ?? 10,
        'descending': descending,
        if (status != null) 'status': status,
        if (priority != null) 'priority': priority,
        if (category != null) 'category': category,
        if (userId != null) 'userId': userId,
        if (searchTerm != null) 'searchTerm': searchTerm,
        if (fromDate != null) 'fromDate': fromDate,
        if (toDate != null) 'toDate': toDate,
        if (sortBy != null) 'sortBy': sortBy,
      },
    );

    // بنبعت الـ response كله للموديل وهو يفرطه
    return SupportTicketsPaginatedModel.fromJson(response);
  }

  @override
  Future<List<TicketMessageModel>> getTicketMessages(String ticketId) async {
    // 💡 لاحظ المسار الجديد اللي الباك عمله
    final response = await apiService.get(
      endpoint: "tickets/$ticketId/messages",
    );
    return (response['messages'] as List)
        .map((e) => TicketMessageModel.fromJson(e))
        .toList();
  }

  @override
  Future<TicketMessageModel> respondToTicket(
    String ticketId,
    String message,
  ) async {
    final response = await apiService.post(
      endpoint: "admin/tickets/respond",
      body: {"ticketId": ticketId, "message": message},
    );
    return TicketMessageModel.fromJson(response);
  }

  @override
  Future<void> updateTicketStatus(String ticketId, String status) async {
    // 💡 استخدام PATCH بناءً على التعديل الأخير
    await apiService.patch(
      endpoint: "tickets/$ticketId",
      data: {"status": status},
    );
  }

  @override
  Future<void> updateTicketPriority(String ticketId, String priority) async {
    // 💡 دي لسه PUT زي ما هي
    await apiService.put(
      endpoint: "admin/tickets/priority",
      data: {"ticketId": ticketId, "priority": priority},
    );
  }

  @override
  Future<SupportStatsModel> getTicketsStatistics() async {
    final response = await apiService.get(endpoint: "admin/tickets/statistics");
    return SupportStatsModel.fromJson(response);
  }
}
