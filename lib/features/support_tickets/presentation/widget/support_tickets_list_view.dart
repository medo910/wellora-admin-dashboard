// widgets/support_tickets_list_view.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_ticket_card.dart';
import 'package:flutter/material.dart';

class SupportTicketsListView extends StatelessWidget {
  final List<SupportTicketEntity> tickets;

  const SupportTicketsListView({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text("No tickets found", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        // هنا هننادي الـ Card اللي هنعمله الحتة الجاية
        return SupportTicketCard(ticket: tickets[index]);
      },
    );
  }
}
