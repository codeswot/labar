import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/app_error.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppError, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, UserEntity?>> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        data: data,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, UserEntity>> signInWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signInWithPhonePassword(
        phone: phone,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, UserEntity?>> signUpWithPhonePassword({
    required String phone,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithPhonePassword(
        phone: phone,
        password: password,
        data: data,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> verifyOtp({
    required String token,
    required OtpType type,
    required String email,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(
        token: token,
        type: type,
        email: email,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, void>> resendOtp({
    required String email,
    required OtpType type,
  }) async {
    try {
      await _remoteDataSource.resendOtp(
        email: email,
        type: type,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthError(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Future<Either<AppError, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(GenericError(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged =>
      _remoteDataSource.onAuthStateChanged;
}
