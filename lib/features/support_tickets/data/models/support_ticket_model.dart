// lib/features/support_tickets/data/models/support_ticket_model.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  SupportTicketModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.title,
    required super.description,
    required super.category,
    required super.status,
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
    super.closedAt,
    super.closedByAdminName,
    required super.messageCount,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'] ?? "N/A",
      userEmail: json['userEmail'] ?? "N/A",
      title: json['title'] ?? "No Title",
      description: json['description'] ?? "",
      category: json['category'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'])
          : null,
      closedByAdminName: json['closedByAdminName'],
      messageCount: json['messageCount'] ?? 0,
    );
  }
}
