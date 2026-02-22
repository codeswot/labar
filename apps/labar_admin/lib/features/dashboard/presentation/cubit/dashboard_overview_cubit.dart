import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'dashboard_overview_cubit.freezed.dart';

@freezed
class DashboardOverviewState with _$DashboardOverviewState {
  const factory DashboardOverviewState({
    @Default(0) int totalApplications,
    @Default(0) int activeAgents,
    @Default(0) int pendingReviews,
    @Default([]) List<Map<String, dynamic>> recentActivity,
    @Default(false) bool isLoading,
    String? error,
  }) = _DashboardOverviewState;
}

@injectable
class DashboardOverviewCubit extends Cubit<DashboardOverviewState> {
  final SupabaseClient _supabaseClient;
  StreamSubscription? _appsSubscription;
  StreamSubscription? _usersSubscription;

  DashboardOverviewCubit(this._supabaseClient)
      : super(const DashboardOverviewState());

  void init() {
    if (_supabaseClient.auth.currentUser == null) {
      emit(state.copyWith(
        error: 'Session expired. Please log in again.',
        isLoading: false,
      ));
      return;
    }
    _appsSubscription?.cancel();
    _usersSubscription?.cancel();
    emit(state.copyWith(isLoading: true, error: null));
    _watchStats();
    _fetchRecentActivity();
  }

  void _watchStats() {
    // Watch applications
    _appsSubscription = _supabaseClient
        .from('applications')
        .stream(primaryKey: ['id']).listen((data) {
      final total = data.length;
      final pending = data
          .where((app) =>
              app['status'] == 'in_review' || app['status'] == 'initial')
          .length;
      emit(state.copyWith(
        totalApplications: total,
        pendingReviews: pending,
        isLoading: false,
        error: null,
      ));
    }, onError: (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    });

    // Watch active agents
    _usersSubscription = _supabaseClient
        .from('user_roles')
        .stream(primaryKey: ['id']).listen((data) {
      final activeAgents = data
          .where((user) => user['role'] == 'agent' && (user['active'] ?? true))
          .length;
      emit(state.copyWith(activeAgents: activeAgents, error: null));
    });
  }

  Future<void> _fetchRecentActivity() async {
    try {
      // Fetch latest 5 applications as recent activity
      final response = await _supabaseClient
          .from('applications')
          .select('*')
          .order('created_at', ascending: false)
          .limit(5);

      emit(state.copyWith(
          recentActivity: List<Map<String, dynamic>>.from(response)));
    } catch (e) {
      // Silent error for activity
    }
  }

  @override
  Future<void> close() {
    _appsSubscription?.cancel();
    _usersSubscription?.cancel();
    return super.close();
  }
}
