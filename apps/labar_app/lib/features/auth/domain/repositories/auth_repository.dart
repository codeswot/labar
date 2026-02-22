import 'package:dartz/dartz.dart';
import 'package:labar_app/core/error/app_error.dart';
import 'package:labar_app/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Either<AppError, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<AppError, UserEntity?>> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<Either<AppError, void>> signOut();

  Future<Either<AppError, void>> forgotPassword(String email);

  Future<Either<AppError, void>> verifyOtp({
    required String token,
    required OtpType type,
    required String email,
  });

  Future<Either<AppError, void>> resendOtp({
    required String email,
    required OtpType type,
  });

  Future<Either<AppError, UserEntity?>> getCurrentUser();

  Stream<UserEntity?> get onAuthStateChanged;
}
