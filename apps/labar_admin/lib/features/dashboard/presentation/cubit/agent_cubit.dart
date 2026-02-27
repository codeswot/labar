import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/agent_repository_impl.dart';

part 'agent_cubit.freezed.dart';

@freezed
class AgentState with _$AgentState {
  const factory AgentState({
    @Default([]) List<Map<String, dynamic>> applications,
    @Default(false) bool isLoading,
    String? error,
  }) = _AgentState;
}

@injectable
class AgentCubit extends Cubit<AgentState> {
  final AgentRepository _agentRepository;
  final SupabaseClient _supabaseClient;
  StreamSubscription? _applicationsSubscription;

  AgentCubit(this._agentRepository, this._supabaseClient)
      : super(const AgentState());

  void watchApplications() {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(state.copyWith(
        error: 'Session expired or invalid. Please log in again.',
        isLoading: false,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    _applicationsSubscription?.cancel();
    _applicationsSubscription = _supabaseClient
        .from('applications')
        .stream(primaryKey: ['id'])
        .eq('created_by', userId)
        .order('created_at', ascending: false)
        .listen((data) {
          emit(state.copyWith(
            applications: List<Map<String, dynamic>>.from(data),
            isLoading: false,
          ));
        }, onError: (e) {
          emit(state.copyWith(isLoading: false, error: e.toString()));
        });
  }

  @Deprecated('Use watchApplications for real-time updates')
  Future<void> fetchApplications() async => watchApplications();

  Future<void> deleteApplication(String id) async {
    try {
      await _agentRepository.deleteApplication(id);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateApplication(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _agentRepository.updateApplication(id, data);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _agentRepository.createApplication(
        email: email,
        metadata: metadata,
        applicationData: applicationData,
        passportBase64: passportBase64,
        signatureBase64: signatureBase64,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> uploadAssets({
    required String applicationId,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _agentRepository.uploadAssets(
        applicationId: applicationId,
        passportBase64: passportBase64,
        signatureBase64: signatureBase64,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _applicationsSubscription?.cancel();
    return super.close();
  }
}
