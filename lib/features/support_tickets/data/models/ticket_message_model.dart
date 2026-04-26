import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/ticket_message_entity.dart';

class TicketMessageModel extends TicketMessageEntity {
  TicketMessageModel({
    required super.messageId,
    required super.ticketId,
    super.senderId,
    required super.senderName,
    required super.content,
    required super.isFromAdmin,
    required super.createdAt,
  });

  // factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
  //   return TicketMessageModel(
  //     messageId: json['messageId'] ?? json['id'], // بندعم الشكلين عشان التوحيد
  //     ticketId: json['ticketId'],
  //     senderName: json['senderName'] ?? json['sender'] ?? "System",
  //     content: json['content'] ?? json['message'], // بندعم content و message
  //     isFromAdmin: json['isFromAdmin'] ?? (json['sender'] == "Admin"),
  //     createdAt: DateTime.parse(json['createdAt'] ?? json['timestamp']),
  //   );
  // }
  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      return TicketMessageModel(
        messageId: (json['messageId'] ?? json['id'] ?? "")
            .toString(), // تحويل لـ String دائماً
        ticketId: (json['ticketId'] ?? "").toString(),
        senderName: json['senderName'] ?? json['sender'] ?? "System",
        content: json['content'] ?? json['message'] ?? "",
        isFromAdmin: json['isFromAdmin'] ?? (json['sender'] == "Admin"),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'].toString())
            : DateTime.now(),
      );
    } catch (e) {
      print("❌ Error Parsing TicketMessageModel: $e");
      // رجع أوبجكت افتراضي عشان الأبلكيشن ميوقفش
      return TicketMessageModel(
        messageId: "",
        ticketId: "",
        senderName: "Error",
        content: "Error parsing message",
        isFromAdmin: false,
        createdAt: DateTime.now(),
      );
    }
  }
}
