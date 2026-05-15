// presentation/pages/support_chat_page.dart
import 'package:admin_dashboard_graduation_project/core/di/injection_container.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_chat_cubit/support_chat_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/chat_bottom_bar.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/chat_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportChatPage extends StatelessWidget {
  final SupportTicketEntity ticket;

  const SupportChatPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SupportChatCubit>()
        ..initChat(ticket)
        ..fetchMessages(ticket.id),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: BlocBuilder<SupportChatCubit, SupportChatState>(
                builder: (context, state) {
                  String currentStatus = ticket.status;
                  String currentPriority = ticket.priority;

                  if (state is SupportChatSuccess) {
                    currentStatus = state.status;
                    currentPriority = state.priority;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "TKT-${ticket.id.toString().substring(0, 8)} • $currentStatus • $currentPriority • ${ticket.category}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
              actions: [_buildChatMenu(context)],
            ),
            body: Column(
              children: [
                const Expanded(child: ChatMessagesList()),
                ChatBottomBar(ticketId: ticket.id),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        _handleMenuAction(context, value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          child: Text(
            "Ticket Status",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        _buildMenuItem(
          value: "Open",
          label: "Re-open Ticket",
          icon: Icons.refresh,
          color: Colors.orange,
        ),
        _buildMenuItem(
          value: "InProgress",
          label: "Mark In Progress",
          icon: Icons.pending_actions,
          color: Colors.blue,
        ),
        _buildMenuItem(
          value: "Resolved",
          label: "Mark Resolved",
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        _buildMenuItem(
          value: "Closed",
          label: "Close Forever",
          icon: Icons.lock_outline,
          color: Colors.grey,
        ),

        const PopupMenuDivider(),

        const PopupMenuItem(
          enabled: false,
          child: Text(
            "Set Priority",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        _buildMenuItem(
          value: "Urgent",
          label: "Urgent",
          icon: Icons.flash_on,
          color: Colors.red,
        ),
        _buildMenuItem(
          value: "High",
          label: "High",
          icon: Icons.arrow_upward,
          color: Colors.orange,
        ),
        _buildMenuItem(
          value: "Normal",
          label: "Normal",
          icon: Icons.remove,
          color: Colors.blue,
        ),
        _buildMenuItem(
          value: "Low",
          label: "Low",
          icon: Icons.arrow_downward,
          color: Colors.grey,
        ),

        const PopupMenuDivider(),

        _buildMenuItem(
          value: "UserInfo",
          label: "User Profile",
          icon: Icons.person_outline,
          color: Colors.black87,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    final chatCubit = context.read<SupportChatCubit>();

    if (value == "UserInfo") {
      _showUserProfileDialog(context);
    } else if (["Open", "InProgress", "Resolved", "Closed"].contains(value)) {
      chatCubit.updateTicketInfo(ticket.id, status: value);
    } else {
      chatCubit.updateTicketInfo(ticket.id, priority: value);
    }
  }

  void _showUserProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("User Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal.shade50,
              child: Text(
                ticket.userName[0],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D9488),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, "Name", ticket.userName),
            _buildInfoRow(Icons.email, "Email", ticket.userEmail),
            _buildInfoRow(
              Icons.confirmation_number,
              "User ID",
              "#${ticket.userId}",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
