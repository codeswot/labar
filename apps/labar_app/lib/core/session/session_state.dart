import 'package:equatable/equatable.dart';
import 'package:labar_app/features/auth/domain/entities/user_entity.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState extends Equatable {
  final SessionStatus status;
  final UserEntity? user;

  const SessionState._({
    this.status = SessionStatus.unknown,
    this.user,
  });

  const SessionState.unknown() : this._();

  const SessionState.authenticated(UserEntity user)
      : this._(status: SessionStatus.authenticated, user: user);

  const SessionState.unauthenticated()
      : this._(status: SessionStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
