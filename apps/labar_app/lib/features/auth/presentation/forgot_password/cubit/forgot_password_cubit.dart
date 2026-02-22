import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/inputs/index.dart';
import 'package:labar_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:labar_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  ForgotPasswordCubit(
    this._forgotPasswordUseCase,
    this._verifyOtpUseCase,
  ) : super(const ForgotPasswordState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: ForgotPasswordStatus.initial,
      isValid: Formz.validate([email]),
    ));
  }

  Future<void> requestPasswordReset() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordUseCase(state.email.value);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ForgotPasswordStatus.emailSent)),
    );
  }

  Future<void> verifyOtp(String email, String token) async {
    emit(state.copyWith(status: ForgotPasswordStatus.verifyingOtp));

    final result = await _verifyOtpUseCase(VerifyOtpParams(
      email: email,
      token: token,
      type: OtpType.recovery,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ForgotPasswordStatus.success)),
    );
  }

  void clearError() {
    emit(state.copyWith(
      status: ForgotPasswordStatus.initial,
      errorMessage: null,
    ));
  }
}
