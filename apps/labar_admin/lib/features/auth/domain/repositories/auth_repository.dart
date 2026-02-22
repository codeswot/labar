import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resendOtp({required String email});

  Future<UserEntity?> verifyOtp({
    required String email,
    required String token,
  });

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get onAuthStateChanged;
}
