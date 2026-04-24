// lib/features/support_tickets/domain/entities/ticket_message_entity.dart
class TicketMessageEntity {
  final String messageId;
  final String ticketId;
  final int? senderId;
  final String senderName;
  final String content;
  final bool isFromAdmin;
  final DateTime createdAt;

  TicketMessageEntity({
    required this.messageId,
    required this.ticketId,
    this.senderId,
    required this.senderName,
    required this.content,
    required this.isFromAdmin,
    required this.createdAt,
  });
}
