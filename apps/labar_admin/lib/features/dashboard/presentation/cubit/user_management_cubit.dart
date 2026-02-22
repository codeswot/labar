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
    String? error,
  }) = _UserManagementState;
}

@injectable
class UserManagementCubit extends Cubit<UserManagementState> {
  final AdminRepository _adminRepository;

  UserManagementCubit(this._adminRepository)
      : super(const UserManagementState());

  Future<void> fetchUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final users = await _adminRepository.getUsers();
      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
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
