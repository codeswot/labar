import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../features/auth/domain/entities/user_entity.dart';

part 'session_state.freezed.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    @Default(SessionStatus.unknown) SessionStatus status,
    UserEntity? user,
  }) = _SessionState;
}
