// lib/features/support_tickets/domain/entities/support_ticket_entity.dart
class SupportTicketEntity {
  final String id;
  final int userId;
  final String userName;
  final String userEmail;
  final String title;
  final String description;
  final String category;
  final String status;
  final String priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;
  final String? closedByAdminName;
  final int messageCount;

  SupportTicketEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    this.closedByAdminName,
    required this.messageCount,
  });

  SupportTicketEntity copyWith({
    String? id,
    int? userId,
    String? userName,
    String? userEmail,
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    String? closedByAdminName,
    int? messageCount,
  }) {
    return SupportTicketEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      closedByAdminName:
          closedByAdminName ?? this.closedByAdminName, // ممكن تكون null
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
