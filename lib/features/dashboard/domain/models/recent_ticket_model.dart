import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_ticket_entity.dart';

class RecentTicketModel extends RecentTicketEntity {
  RecentTicketModel({
    required super.id,
    required super.userName,
    required super.title,
    required super.status,
    required super.priority,
    required super.createdAt,
  });

  factory RecentTicketModel.fromJson(Map<String, dynamic> json) {
    return RecentTicketModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'Open',
      priority: json['priority'] ?? 'Low',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
