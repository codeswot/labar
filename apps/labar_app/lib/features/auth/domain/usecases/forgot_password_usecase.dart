import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/error/app_error.dart';
import 'package:labar_app/core/usecase/usecase.dart';
import 'package:labar_app/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class ForgotPasswordUseCase implements UseCase<void, String> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<AppError, void>> call(String email) async {
    return _repository.forgotPassword(email);
  }
}
