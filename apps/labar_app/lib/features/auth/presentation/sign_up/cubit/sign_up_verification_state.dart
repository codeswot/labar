import 'package:equatable/equatable.dart';

enum SignUpVerificationStatus { initial, verifying, success, failure }

class SignUpVerificationState extends Equatable {
  final SignUpVerificationStatus status;
  final String? errorMessage;
  final int resendCountdown;

  const SignUpVerificationState({
    this.status = SignUpVerificationStatus.initial,
    this.errorMessage,
    this.resendCountdown = 30,
  });

  SignUpVerificationState copyWith({
    SignUpVerificationStatus? status,
    String? errorMessage,
    int? resendCountdown,
  }) {
    return SignUpVerificationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendCountdown: resendCountdown ?? this.resendCountdown,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, resendCountdown];
}
