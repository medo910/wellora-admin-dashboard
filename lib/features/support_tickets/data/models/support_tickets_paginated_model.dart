// lib/features/support_tickets/data/models/support_tickets_paginated_model.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/data/models/support_ticket_model.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';

class SupportTicketsPaginatedModel extends SupportTicketsPaginatedEntity {
  SupportTicketsPaginatedModel({
    required super.tickets,
    required super.totalCount,
    required super.hasNextPage,
  });

  factory SupportTicketsPaginatedModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketsPaginatedModel(
      tickets: (json['tickets'] as List)
          .map((e) => SupportTicketModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
