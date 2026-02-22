import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/error/app_error.dart';
import 'package:labar_app/core/usecase/usecase.dart';
import 'package:labar_app/features/auth/domain/entities/user_entity.dart';
import 'package:labar_app/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class SignUpUseCase implements UseCase<UserEntity?, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<AppError, UserEntity?>> call(SignUpParams params) async {
    return _repository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
      data: params.data,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final Map<String, dynamic>? data;

  const SignUpParams({
    required this.email,
    required this.password,
    this.data,
  });

  @override
  List<Object?> get props => [email, password, data];
}
