import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/admin_repository_impl.dart';
import 'package:labar_admin/core/session/session_cubit.dart';

part 'user_management_cubit.freezed.dart';

@freezed
class UserManagementState with _$UserManagementState {
  const factory UserManagementState({
    @Default([]) List<UserEntity> users,
    @Default(false) bool isLoading,
    @Default(false) bool isActionLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int page,
    @Default([]) List<Map<String, dynamic>> warehouses,
    String? error,
  }) = _UserManagementState;
}

@injectable
class UserManagementCubit extends Cubit<UserManagementState> {
  final AdminRepository _adminRepository;
  final SessionCubit _sessionCubit;
  StreamSubscription? _userSubscription;
  RealtimeChannel? _realtimeChannel;

  UserManagementCubit(this._adminRepository, this._sessionCubit)
      : super(const UserManagementState()) {
    _initStream();
  }

  void _initStream() {
    _userSubscription?.cancel();
    // Keep the initial list fetch and backup stream
    _userSubscription = _adminRepository.usersStream.listen((users) {
      if (!state.isLoading && state.users.isEmpty) {
        emit(state.copyWith(users: users));
      }
    });

    // Surgical realtime updates
    _realtimeChannel?.unsubscribe();
    final client = (_adminRepository as AdminRepositoryImpl).supabaseClient;
    
    _realtimeChannel = client.channel('public:surgical_users');
    
    _realtimeChannel!.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'profiles',
      callback: (payload) async {
        final userId = payload.newRecord['id'] ?? payload.oldRecord['id'];
        if (userId == null) return;

        if (payload.eventType == PostgresChangeEvent.delete) {
          final updatedUsers = List<UserEntity>.from(state.users)
            ..removeWhere((u) => u.id == userId);
          emit(state.copyWith(users: updatedUsers));
        } else {
          // Fetch full joined data for this specific user
          final updatedUser = await _adminRepository.getUserById(userId);
          if (updatedUser != null) {
            final updatedUsers = List<UserEntity>.from(state.users);
            final index = updatedUsers.indexWhere((u) => u.id == userId);
            
            if (index != -1) {
              updatedUsers[index] = updatedUser;
            } else {
              // Add to top if it's new
              updatedUsers.insert(0, updatedUser);
            }
            emit(state.copyWith(users: updatedUsers));
          }
        }
      },
    ).onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'user_roles',
      callback: (payload) async {
        final userId = payload.newRecord['id'] ?? payload.oldRecord['id'];
        if (userId == null) return;
        
        final updatedUser = await _adminRepository.getUserById(userId);
        if (updatedUser != null) {
          final updatedUsers = List<UserEntity>.from(state.users);
          final index = updatedUsers.indexWhere((u) => u.id == userId);
          if (index != -1) {
            updatedUsers[index] = updatedUser;
            emit(state.copyWith(users: updatedUsers));
          }
        }
      },
    ).subscribe();
  }

  Future<void> fetchUsers({bool refresh = false}) async {
    if ((state.isLoading || state.isLoadingMore) && !refresh) return;

    if (refresh) {
      // Don't clear users on refresh to avoid UI flickering
      emit(state.copyWith(
          isLoading: state.users.isEmpty, page: 0, hasMore: true, error: null));
    } else {
      emit(state.copyWith(isLoadingMore: true, error: null));
    }

    try {
      if (state.warehouses.isEmpty) {
        final user = _sessionCubit.state.user;
        final isManager = user?.role == 'warehouse_manager';
        final managerWarehouseId = isManager ? user?.warehouseId : null;

        final warehouses =
            await _adminRepository.getWarehouses(warehouseId: managerWarehouseId);
        emit(state.copyWith(warehouses: warehouses));
      }

      const int pageSize = 50;
      final int offset = state.page * pageSize;

      final users = await _adminRepository.getUsers(
        limit: pageSize,
        offset: offset,
      );

      emit(state.copyWith(
        users: refresh ? users : [...state.users, ...users],
        isLoading: false,
        isLoadingMore: false,
        page: state.page + 1,
        hasMore: users.length == pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, isLoadingMore: false, error: e.toString()));
    }
  }

  Future<String?> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    Map<String, dynamic>? metadata,
  }) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      final userId = await _adminRepository.createUser(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
        metadata: metadata,
      );
      // No need to manually refresh, the stream will catch it. 
      // But we set loading false.
      emit(state.copyWith(isActionLoading: false));
      return userId;
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      await _adminRepository.deleteUser(userId);
      emit(state.copyWith(isActionLoading: false));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
    }
  }

  Future<void> toggleUserStatus(String userId, bool active) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      await _adminRepository.toggleUserStatus(userId: userId, active: active);
      emit(state.copyWith(isActionLoading: false));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
    }
  }

  Future<void> updateRole(String userId, String role) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      await _adminRepository.updateUserRole(userId, role);
      // If role changed FROM warehouse_manager, unassign
      if (role != 'warehouse_manager') {
        await _adminRepository.unassignWarehouseManager(userId);
      }
      emit(state.copyWith(isActionLoading: false));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
    }
  }

  Future<void> assignWarehouseManager(String userId, String warehouseId) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      await _adminRepository.assignWarehouseManager(userId, warehouseId);
      emit(state.copyWith(isActionLoading: false));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
    }
  }

  Future<void> unassignWarehouseManager(String userId) async {
    emit(state.copyWith(isActionLoading: true, error: null));
    try {
      await _adminRepository.unassignWarehouseManager(userId);
      emit(state.copyWith(isActionLoading: false));
    } catch (e) {
      emit(state.copyWith(isActionLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _realtimeChannel?.unsubscribe();
    return super.close();
  }
}
