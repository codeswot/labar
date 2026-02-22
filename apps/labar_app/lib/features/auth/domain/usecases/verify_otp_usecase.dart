import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase implements UseCase<void, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<AppError, void>> call(VerifyOtpParams params) async {
    return _repository.verifyOtp(
      email: params.email,
      token: params.token,
      type: params.type,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String email;
  final String token;
  final OtpType type;

  const VerifyOtpParams({
    required this.email,
    required this.token,
    required this.type,
  });

  @override
  List<Object> get props => [email, token, type];
}
