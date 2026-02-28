import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<AppError, UserEntity>> call(SignInParams params) async {
    if (params.phone != null) {
      return _repository.signInWithPhonePassword(
        phone: params.phone!,
        password: params.password,
      );
    }
    return _repository.signInWithEmailPassword(
      email: params.email ?? '',
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String? email;
  final String? phone;
  final String password;

  const SignInParams({this.email, this.phone, required this.password});

  @override
  List<Object?> get props => [email, phone, password];
}
