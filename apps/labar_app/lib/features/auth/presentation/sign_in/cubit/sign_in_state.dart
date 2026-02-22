import 'package:equatable/equatable.dart';

import 'package:labar_app/core/inputs/index.dart';

enum SignInStatus {
  initial,
  inProgress,
  success,
  failure,
  emailNotVerified,
}

class SignInState extends Equatable {
  final SignInStatus status;
  final Email email;
  final Password password;
  final String? errorMessage;
  final bool isValid;

  const SignInState({
    this.status = SignInStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  SignInState copyWith({
    SignInStatus? status,
    Email? email,
    Password? password,
    String? errorMessage,
    bool? isValid,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [status, email, password, errorMessage, isValid];
}
