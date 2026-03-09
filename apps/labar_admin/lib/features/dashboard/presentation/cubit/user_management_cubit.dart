import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/repositories/admin_repository_impl.dart';

part 'user_management_cubit.freezed.dart';

@freezed
class UserManagementState with _$UserManagementState {
  const factory UserManagementState({
    @Default([]) List<UserEntity> users,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int page,
    String? error,
  }) = _UserManagementState;
}

@injectable
class UserManagementCubit extends Cubit<UserManagementState> {
  final AdminRepository _adminRepository;

  UserManagementCubit(this._adminRepository)
      : super(const UserManagementState());

  Future<void> fetchUsers({bool refresh = false}) async {
    if (state.isLoading || (state.isLoadingMore && !refresh)) return;

    if (refresh) {
      emit(state.copyWith(isLoading: true, page: 0, users: [], hasMore: true, error: null));
    } else {
      emit(state.copyWith(isLoadingMore: true, error: null));
    }

    try {
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
      emit(state.copyWith(isLoading: false, isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    Map<String, dynamic>? metadata,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.createUser(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
        metadata: metadata,
      );
      await fetchUsers();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.deleteUser(userId);
      await fetchUsers();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> toggleUserStatus(String userId, bool active) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.toggleUserStatus(userId: userId, active: active);
      await fetchUsers();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateRole(String userId, String role) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.updateUserRole(userId, role);
      await fetchUsers();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
