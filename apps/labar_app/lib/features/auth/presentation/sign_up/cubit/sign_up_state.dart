import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:labar_app/core/inputs/index.dart';

class SignUpState extends Equatable {
  final FormzSubmissionStatus status;
  final TextInput firstName;
  final TextInput lastName;
  final Email email;
  final Phone phone;
  final bool usePhone;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String? errorMessage;
  final bool isValid;

  const SignUpState({
    this.status = FormzSubmissionStatus.initial,
    this.firstName = const TextInput.pure(),
    this.lastName = const TextInput.pure(),
    this.email = const Email.pure(),
    this.phone = const Phone.pure(),
    this.usePhone = false,
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.errorMessage,
    this.isValid = false,
  });

  SignUpState copyWith({
    FormzSubmissionStatus? status,
    TextInput? firstName,
    TextInput? lastName,
    Email? email,
    Phone? phone,
    bool? usePhone,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? errorMessage,
    bool? isValid,
  }) {
    return SignUpState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      usePhone: usePhone ?? this.usePhone,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
        status,
        firstName,
        lastName,
        email,
        phone,
        usePhone,
        password,
        confirmedPassword,
        errorMessage,
        isValid
      ];
}
