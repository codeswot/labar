import 'package:equatable/equatable.dart';
import 'package:labar_app/core/inputs/index.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  emailSent,
  verifyingOtp,
  success,
  failure
}

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final Email email;
  final String? errorMessage;
  final bool isValid;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.email = const Email.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    Email? email,
    String? errorMessage,
    bool? isValid,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, email, errorMessage, isValid];
}
