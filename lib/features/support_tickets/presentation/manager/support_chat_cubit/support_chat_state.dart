part of 'support_chat_cubit.dart';

sealed class SupportChatState extends Equatable {
  const SupportChatState();

  @override
  List<Object?> get props => [];
}

final class SupportChatInitial extends SupportChatState {}

final class SupportChatLoading extends SupportChatState {}

final class SupportChatSuccess extends SupportChatState {
  final List<TicketMessageEntity> messages;
  final String status; // 🚀 إضافة الحالة
  final String priority; // 🚀 إضافة الأولوية
  const SupportChatSuccess({
    required this.messages,
    required this.status,
    required this.priority,
  });

  @override
  List<Object?> get props => [messages, status, priority];
}

final class SupportChatFailure extends SupportChatState {
  final String errMessage;
  const SupportChatFailure(this.errMessage);
}

// حالات إرسال رد جديد
final class SupportReplyLoading extends SupportChatState {}

final class SupportReplySuccess extends SupportChatState {
  final TicketMessageEntity newMessage;
  const SupportReplySuccess(this.newMessage);
}
