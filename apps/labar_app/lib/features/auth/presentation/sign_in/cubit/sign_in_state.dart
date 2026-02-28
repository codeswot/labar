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
  final Phone phone;
  final bool usePhone;
  final Password password;
  final String? errorMessage;
  final bool isValid;

  const SignInState({
    this.status = SignInStatus.initial,
    this.email = const Email.pure(),
    this.phone = const Phone.pure(),
    this.usePhone = false,
    this.password = const Password.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  SignInState copyWith({
    SignInStatus? status,
    Email? email,
    Phone? phone,
    bool? usePhone,
    Password? password,
    String? errorMessage,
    bool? isValid,
  }) {
    return SignInState(
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      usePhone: usePhone ?? this.usePhone,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props =>
      [status, email, phone, usePhone, password, errorMessage, isValid];
}
