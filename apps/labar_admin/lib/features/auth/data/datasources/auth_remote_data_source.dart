import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
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

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserEntity?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) return null;

    return await _mapUser(response.user!);
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<void> resendOtp({required String email}) async {
    await _supabaseClient.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  @override
  Future<UserEntity?> verifyOtp({
    required String email,
    required String token,
  }) async {
    final response = await _supabaseClient.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );

    if (response.user == null) return null;
    return await _mapUser(response.user!);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;
    return await _mapUser(user);
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;
      return await _mapUser(user);
    });
  }

  Future<UserEntity> _mapUser(User user) async {
    // Fetch role from user_roles table
    final roleData = await _supabaseClient
        .from('user_roles')
        .select('role, active')
        .eq('id', user.id)
        .maybeSingle();

    return UserEntity(
      id: user.id,
      email: user.email,
      phone: user.phone,
      userMetadata: user.userMetadata,
      createdAt: DateTime.parse(user.createdAt),
      role: roleData?['role']?.toString(),
      active: roleData?['active'] as bool?,
    );
  }
}
