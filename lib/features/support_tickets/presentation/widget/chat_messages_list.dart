// widgets/chat_messages_list.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_chat_cubit/support_chat_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportChatCubit, SupportChatState>(
      builder: (context, state) {
        if (state is SupportChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SupportChatFailure) {
          return Center(child: Text(state.errMessage));
        }

        if (state is SupportChatSuccess) {
          final messages = state.messages;

          if (messages.isEmpty) {
            return const Center(
              child: Text("No messages yet. Start the conversation!"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(message: messages[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
