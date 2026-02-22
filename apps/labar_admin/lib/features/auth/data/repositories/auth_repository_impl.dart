import 'package:injectable/injectable.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';
import 'package:labar_admin/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity?> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<void> resendOtp({required String email}) {
    return _remoteDataSource.resendOtp(email: email);
  }

  @override
  Future<UserEntity?> verifyOtp({
    required String email,
    required String token,
  }) {
    return _remoteDataSource.verifyOtp(email: email, token: token);
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged =>
      _remoteDataSource.onAuthStateChanged;
}
