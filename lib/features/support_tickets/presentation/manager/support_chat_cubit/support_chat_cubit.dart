import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/data/models/ticket_message_model.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/ticket_message_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_ticket_messages_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/respond_to_ticket_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_priority_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_status_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'support_chat_state.dart';

class SupportChatCubit extends Cubit<SupportChatState> {
  final GetTicketMessagesUseCase getMessagesUseCase;
  final RespondToTicketUseCase respondUseCase;
  final UpdateTicketStatusUseCase updateStatusUseCase;
  final UpdateTicketPriorityUseCase updatePriorityUseCase;
  final SignalRService _signalRService;

  SupportChatCubit({
    required this.getMessagesUseCase,
    required this.respondUseCase,
    required this.updateStatusUseCase,
    required this.updatePriorityUseCase,
    required SignalRService signalRService,
  }) : _signalRService = signalRService,
       super(SupportChatInitial());

  List<TicketMessageEntity> _messages = [];
  late String _currentStatus;
  late String _currentPriority;

  void initChat(SupportTicketEntity ticket) {
    _currentStatus = ticket.status;
    _currentPriority = ticket.priority;
  }

  Future<void> fetchMessages(String ticketId) async {
    emit(SupportChatLoading());
    final result = await getMessagesUseCase(ticketId);

    result.fold((failure) => emit(SupportChatFailure(failure.errmessage)), (
      messages,
    ) {
      _messages = messages.toList();
      _emitSuccess();
      _startRealtimeListening(ticketId);
    });
  }

  void _startRealtimeListening(String ticketId) async {
    _signalRService.off("ReceiveMessage");

    int retry = 0;
    while (!_signalRService.isConnected && retry < 5) {
      await Future.delayed(const Duration(milliseconds: 1000));
      retry++;
    }

    if (_signalRService.isConnected) {
      debugPrint("✅ SignalR: Joining Group $ticketId");
      await _signalRService.invoke("JoinTicket", args: [ticketId]);

      _signalRService.on("ReceiveMessage", (arguments) {
        if (isClosed) return;

        if (arguments != null && arguments.isNotEmpty) {
          try {
            final newMessage = TicketMessageModel.fromJson(
              arguments[0] as Map<String, dynamic>,
            );

            if (!_messages.any((m) => m.messageId == newMessage.messageId)) {
              _messages.add(newMessage);
              _emitSuccess();
            }
          } catch (e) {
            debugPrint("❌ SignalR Error: $e");
          }
        }
      });
    }
  }

  Future<void> sendReply(String ticketId, String content) async {
    final result = await respondUseCase(ticketId, content);
    result.fold((failure) => emit(SupportChatFailure(failure.errmessage)), (
      newMessage,
    ) {
      if (!_messages.any((m) => m.messageId == newMessage.messageId)) {
        _messages.add(newMessage);
        _emitSuccess();
      }
    });
  }

  Future<void> updateTicketInfo(
    String ticketId, {
    String? status,
    String? priority,
  }) async {
    if (status != null) {
      final result = await updateStatusUseCase(ticketId, status);
      result.fold((f) => emit(SupportChatFailure(f.errmessage)), (msg) {
        _currentStatus = status;
        _emitSuccess();
      });
    }

    if (priority != null) {
      final result = await updatePriorityUseCase(ticketId, priority);
      result.fold((f) => emit(SupportChatFailure(f.errmessage)), (msg) {
        _currentPriority = priority;
        _emitSuccess();
      });
    }
  }

  void _emitSuccess() {
    if (!isClosed) {
      emit(
        SupportChatSuccess(
          messages: List.from(_messages),
          status: _currentStatus,
          priority: _currentPriority,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _signalRService.off("ReceiveMessage");
    return super.close();
  }
}
