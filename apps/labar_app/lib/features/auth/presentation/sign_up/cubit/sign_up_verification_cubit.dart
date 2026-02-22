import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:labar_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_up_verification_state.dart';

@injectable
class SignUpVerificationCubit extends Cubit<SignUpVerificationState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  Timer? _timer;

  SignUpVerificationCubit(this._verifyOtpUseCase, this._resendOtpUseCase)
      : super(const SignUpVerificationState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(resendCountdown: 30));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown > 0) {
        emit(state.copyWith(resendCountdown: state.resendCountdown - 1));
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(state.copyWith(status: SignUpVerificationStatus.verifying));

    final result = await _verifyOtpUseCase(VerifyOtpParams(
      email: email,
      token: otp,
      type: OtpType.signup,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: SignUpVerificationStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: SignUpVerificationStatus.success)),
    );
  }

  Future<void> resendOtp(String email) async {
    _startTimer();
    await _resendOtpUseCase(ResendOtpParams(
      email: email,
      type: OtpType.signup,
    ));
  }

  void clearError() {
    emit(state.copyWith(
      status: SignUpVerificationStatus.initial,
      errorMessage: null,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
