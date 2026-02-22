import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/error/app_error.dart';
import 'package:labar_app/core/usecase/usecase.dart';
import 'package:labar_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class ResendOtpUseCase implements UseCase<void, ResendOtpParams> {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  @override
  Future<Either<AppError, void>> call(ResendOtpParams params) async {
    return _repository.resendOtp(
      email: params.email,
      type: params.type,
    );
  }
}

class ResendOtpParams extends Equatable {
  final String email;
  final OtpType type;

  const ResendOtpParams({
    required this.email,
    required this.type,
  });

  @override
  List<Object> get props => [email, type];
}
