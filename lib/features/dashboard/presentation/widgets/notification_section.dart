// lib/features/dashboard/presentation/widgets/notification_section.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/notification_cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_item.dart'; // import الـ Item اللي لسه عاملينه

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final count = context.read<NotificationCubit>().unreadCount;
        return PopupMenuButton<String>(
          offset: const Offset(0, 55),
          icon: _buildIcon(count),
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications ($count)",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (count > 0)
                    TextButton(
                      onPressed: () {
                        context.read<NotificationCubit>().markAllAsRead();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Mark all as read",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF008080),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            if (state is NotificationSuccess && state.notifications.isNotEmpty)
              ...state.notifications
                  .take(5)
                  .map(
                    (noti) => PopupMenuItem<String>(
                      value: noti.id,
                      onTap: () =>
                          context.read<NotificationCubit>().markAsRead(noti.id),
                      child: NotificationItem(notification: noti),
                    ),
                  )
                  .toList()
            else
              const PopupMenuItem<String>(
                enabled: false,
                child: Center(
                  child: Text(
                    "No new notifications",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildIcon(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.notifications_none_outlined,
          color: Color(0xFF64748B),
          size: 26,
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                "$count",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
