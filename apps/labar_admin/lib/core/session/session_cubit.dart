import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';
import 'package:labar_admin/features/auth/domain/repositories/auth_repository.dart';
import 'session_state.dart';

@lazySingleton
class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  SessionCubit(this._authRepository)
      : super(const SessionState(status: SessionStatus.unknown)) {
    _init();
  }

  Future<void> _init() async {
    final currentUser = await _authRepository.getCurrentUser();
    if (currentUser != null) {
      emit(
          SessionState(status: SessionStatus.authenticated, user: currentUser));
    } else {
      emit(const SessionState(status: SessionStatus.unauthenticated));
    }

    _authStateSubscription = _authRepository.onAuthStateChanged.listen((user) {
      if (user != null) {
        emit(SessionState(status: SessionStatus.authenticated, user: user));
      } else {
        emit(const SessionState(status: SessionStatus.unauthenticated));
      }
    });
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
