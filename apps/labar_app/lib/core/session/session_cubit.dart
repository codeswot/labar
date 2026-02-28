import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

import 'session_state.dart';

@lazySingleton
class SessionCubit extends Cubit<SessionState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;

  SessionCubit(this._authRepository) : super(const SessionState.unknown()) {
    _init();
  }

  void _init() {
    _authStateSubscription = _authRepository.onAuthStateChanged.listen((user) {
      if (user != null) {
        emit(SessionState.authenticated(user));
      } else {
        emit(const SessionState.unauthenticated());
      }
    });
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } finally {
      await HydratedBloc.storage.clear();
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
