import 'dart:async';
import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_support_stats_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/get_tickets_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_priority_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/use_cases/update_ticket_status_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final GetTicketsUseCase getTicketsUseCase;
  final GetSupportStatsUseCase getStatsUseCase;
  final UpdateTicketStatusUseCase updateStatusUseCase;
  final UpdateTicketPriorityUseCase updatePriorityUseCase;
  final SignalRService _signalRService;

  SupportCubit({
    required this.getTicketsUseCase,
    required this.getStatsUseCase,
    required this.updateStatusUseCase,
    required this.updatePriorityUseCase,
    required SignalRService signalRService,
  }) : _signalRService = signalRService,
       super(SupportInitial()) {
    _listenToGlobalEvents();
  }

  int _currentPage = 1;
  int _pageSize = 10;
  String _currentStatus = "All";
  String _currentPriority = "All";
  String _currentCategory = "All";
  String? _currentSearch;
  String? _fromDate;
  String? _toDate;
  String? _sortBy;
  bool _descending = true;
  int? _targetUserId;
  Timer? _searchTimer;

  void _listenToGlobalEvents() {
    _signalRService.on("TicketUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final data = arguments[0] as Map<String, dynamic>;
          final String tId = data['ticketId'].toString();
          final String translatedStatus = _mapStatusIntToString(data['status']);
          final String translatedPriority = _mapPriorityIntToString(
            data['priority'],
          );

          _handleInMemoryUpdate(
            id: tId,
            newStatus: translatedStatus,
            newPriority: translatedPriority,
          );
        } catch (e) {
          print("❌ SignalR Parse Error: $e");
        }
      }
    });

    _signalRService.on(
      "TicketCreated",
      (_) => fetchSupportData(isRefresh: false),
    );
  }

  Future<void> fetchSupportData({
    int? page,
    String? status,
    String? priority,
    String? category,
    String? searchTerm,
    String? fromDate,
    String? toDate,
    bool isRefresh = true,
  }) async {
    if (page != null) _currentPage = page;
    if (status != null) _currentStatus = status;
    if (priority != null) _currentPriority = priority;
    if (category != null) _currentCategory = category;
    if (searchTerm != null)
      _currentSearch = searchTerm.isEmpty ? null : searchTerm;
    if (fromDate != null) _fromDate = fromDate;
    if (toDate != null) _toDate = toDate;

    if (isRefresh) emit(SupportLoading());

    final results = await Future.wait([
      getStatsUseCase(),
      getTicketsUseCase(
        page: _currentPage,
        pageSize: _pageSize,
        status: (_currentStatus == "All") ? null : _currentStatus,
        priority: (_currentPriority == "All") ? null : _currentPriority,
        category: (_currentCategory == "All") ? null : _currentCategory,
        searchTerm: _currentSearch,
        fromDate: _fromDate,
        toDate: _toDate,
        sortBy: _sortBy,
        descending: _descending,
        userId: _targetUserId,
      ),
    ]);

    final statsResult = results[0] as Either<Failure, SupportStatsEntity>;
    final ticketsResult =
        results[1] as Either<Failure, SupportTicketsPaginatedEntity>;

    statsResult.fold((f) => emit(SupportFailure(f.errmessage)), (stats) {
      ticketsResult.fold((f) => emit(SupportFailure(f.errmessage)), (
        paginatedData,
      ) {
        emit(
          SupportSuccess(
            tickets: paginatedData.tickets,
            stats: stats,
            currentPage: _currentPage,
            hasNextPage: paginatedData.hasNextPage,
            totalItems: paginatedData.totalCount,
            currentStatus: _currentStatus,
            currentPriority: _currentPriority,
            currentCategory: _currentCategory,
            currentDateRange: (_fromDate != null && _toDate != null)
                ? DateTimeRange(
                    start: DateTime.parse(_fromDate!),
                    end: DateTime.parse(_toDate!),
                  )
                : null,
          ),
        );
      });
    });
  }

  void _handleInMemoryUpdate({
    required String id,
    required String newStatus,
    required String newPriority,
  }) {
    if (state is SupportSuccess) {
      final currentState = state as SupportSuccess;
      final updatedList = currentState.tickets.map((t) {
        if (t.id.toString() == id) {
          return t.copyWith(status: newStatus, priority: newPriority);
        }
        return t;
      }).toList();

      if (currentState.currentStatus != "All") {
        updatedList.removeWhere(
          (t) =>
              t.id.toString() == id && t.status != currentState.currentStatus,
        );
      }

      emit(currentState.copyWith(tickets: updatedList));
    }
  }

  void resetAllFilters() {
    _currentStatus = "All";
    _currentPriority = "All";
    _currentCategory = "All";
    _currentSearch = null;
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchSupportData(isRefresh: true);
  }

  String _mapStatusIntToString(dynamic s) =>
      ["Open", "InProgress", "Resolved", "Closed"][int.parse(s.toString())];
  String _mapPriorityIntToString(dynamic p) =>
      ["Low", "Normal", "High", "Urgent"][int.parse(p.toString())];

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }

  void searchTickets(String query) {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 600), () {
      _currentSearch = query.isEmpty ? null : query;

      _currentPage = 1;

      print("🔍 Searching for: $_currentSearch");

      fetchSupportData(isRefresh: false);
    });
  }
}
