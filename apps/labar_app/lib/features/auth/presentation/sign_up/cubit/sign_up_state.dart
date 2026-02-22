import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:labar_app/core/inputs/index.dart';

class SignUpState extends Equatable {
  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String? errorMessage;
  final bool isValid;

  const SignUpState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  SignUpState copyWith({
    FormzSubmissionStatus? status,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? errorMessage,
    bool? isValid,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props =>
      [status, email, password, confirmedPassword, errorMessage, isValid];
}
