import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/inputs/index.dart';
import 'package:labar_app/features/auth/domain/usecases/sign_up_usecase.dart';

import 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpCubit(this._signUpUseCase) : super(const SignUpState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
      isValid: !state.usePhone &&
          Formz.validate([email, state.password, state.confirmedPassword]),
    ));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: FormzSubmissionStatus.initial,
      isValid: state.usePhone &&
          Formz.validate([phone, state.password, state.confirmedPassword]),
    ));
  }

  void toggleAuthMode() {
    final newUsePhone = !state.usePhone;
    emit(state.copyWith(
      usePhone: newUsePhone,
      status: FormzSubmissionStatus.initial,
      isValid: newUsePhone
          ? Formz.validate(
              [state.phone, state.password, state.confirmedPassword])
          : Formz.validate(
              [state.email, state.password, state.confirmedPassword]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: FormzSubmissionStatus.initial,
      isValid: state.usePhone
          ? Formz.validate([state.phone, password, confirmedPassword])
          : Formz.validate([state.email, password, confirmedPassword]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: FormzSubmissionStatus.initial,
      isValid: state.usePhone
          ? Formz.validate([state.phone, state.password, confirmedPassword])
          : Formz.validate([state.email, state.password, confirmedPassword]),
    ));
  }

  Future<void> signUp() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    String? formattedPhone = state.phone.value;
    if (state.usePhone && formattedPhone.startsWith('0')) {
      formattedPhone = '+234${formattedPhone.substring(1)}';
    }

    final result = await _signUpUseCase(SignUpParams(
      email: state.usePhone ? null : state.email.value,
      phone: state.usePhone ? formattedPhone : null,
      password: state.password.value,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
    );
  }

  void clearError() {
    emit(state.copyWith(
      status: FormzSubmissionStatus.initial,
      errorMessage: null,
    ));
  }
}
