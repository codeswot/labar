import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/inputs/index.dart';
import 'package:labar_app/features/auth/domain/usecases/sign_in_usecase.dart';

import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;

  SignInCubit(this._signInUseCase) : super(const SignInState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: SignInStatus.initial,
      isValid: !state.usePhone && Formz.validate([email, state.password]),
    ));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: SignInStatus.initial,
      isValid: state.usePhone && Formz.validate([phone, state.password]),
    ));
  }

  void toggleAuthMode() {
    final newUsePhone = !state.usePhone;
    emit(state.copyWith(
      usePhone: newUsePhone,
      status: SignInStatus.initial,
      isValid: newUsePhone
          ? Formz.validate([state.phone, state.password])
          : Formz.validate([state.email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: SignInStatus.initial,
      isValid: state.usePhone
          ? Formz.validate([state.phone, password])
          : Formz.validate([state.email, password]),
    ));
  }

  Future<void> signIn() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: SignInStatus.inProgress));

    final result = await _signInUseCase(SignInParams(
      email: state.usePhone ? null : state.email.value,
      phone: state.usePhone ? state.phone.value : null,
      password: state.password.value,
    ));

    result.fold(
      (failure) {
        if (failure.message.contains('Email not confirmed') ||
            failure.message.contains('Email not verified')) {
          emit(state.copyWith(status: SignInStatus.emailNotVerified));
        } else {
          emit(state.copyWith(
            status: SignInStatus.failure,
            errorMessage: failure.message,
          ));
        }
      },
      (user) => emit(state.copyWith(status: SignInStatus.success)),
    );
  }

  void clearError() {
    emit(state.copyWith(
      status: SignInStatus.initial,
      errorMessage: null,
    ));
  }
}
