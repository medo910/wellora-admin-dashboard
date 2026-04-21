class RecentTicketEntity {
  final String id;
  final String userName;
  final String title;
  final String status;
  final String priority;
  final DateTime createdAt;

  RecentTicketEntity({
    required this.id,
    required this.userName,
    required this.title,
    required this.status,
    required this.priority,
    required this.createdAt,
  });
}
