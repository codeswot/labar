import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserEntity?> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<UserEntity> signInWithPhonePassword({
    required String phone,
    required String password,
  });

  Future<UserEntity?> signUpWithPhonePassword({
    required String phone,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<void> signOut();

  Future<void> forgotPassword(String email);

  Future<void> verifyOtp({
    required String token,
    required OtpType type,
    required String email,
  });

  Future<void> resendOtp({
    required String email,
    required OtpType type,
  });

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get onAuthStateChanged;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Sign in failed: User is null');
    }

    return await _mapUser(response.user!);
  }

  @override
  Future<UserEntity?> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
    if (response.user != null) {
      // Create profile
      await _supabaseClient.from('profiles').upsert({
        'id': response.user!.id,
        'email': email,
        'first_name': data?['first_name'],
        'last_name': data?['last_name'],
      });
      // Create role
      await _supabaseClient.from('user_roles').upsert({
        'id': response.user!.id,
        'role': data?['role'] ?? 'farmer',
        'active': true,
      });
      return await _mapUser(response.user!);
    }
    return null;
  }

  @override
  Future<UserEntity> signInWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      phone: phone,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Sign in failed: User is null');
    }

    return await _mapUser(response.user!);
  }

  @override
  Future<UserEntity?> signUpWithPhonePassword({
    required String phone,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    final response = await _supabaseClient.auth.signUp(
      phone: phone,
      password: password,
      data: data,
    );
    if (response.user != null) {
      // Create profile
      await _supabaseClient.from('profiles').upsert({
        'id': response.user!.id,
        'phone': phone,
        'first_name': data?['first_name'],
        'last_name': data?['last_name'],
      });
      // Create role
      await _supabaseClient.from('user_roles').upsert({
        'id': response.user!.id,
        'role': data?['role'] ?? 'farmer',
        'active': true,
      });
      return await _mapUser(response.user!);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> verifyOtp({
    required String token,
    required OtpType type,
    required String email,
  }) async {
    await _supabaseClient.auth.verifyOTP(
      token: token,
      type: type,
      email: email,
    );
  }

  @override
  Future<void> resendOtp({
    required String email,
    required OtpType type,
  }) async {
    await _supabaseClient.auth.resend(
      type: type,
      email: email,
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabaseClient.auth.currentUser;
    if (user != null) {
      return await _mapUser(user);
    }
    return null;
  }

  @override
  Stream<UserEntity?> get onAuthStateChanged {
    return _supabaseClient.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user != null) {
        return await _mapUser(user);
      }
      return null;
    });
  }

  Future<UserEntity> _mapUser(User user) async {
    // Fetch role
    final roleData = await _supabaseClient
        .from('user_roles')
        .select('role, active')
        .eq('id', user.id)
        .maybeSingle();

    // Fetch profile
    final profileData = await _supabaseClient
        .from('profiles')
        .select('first_name, last_name, avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    return UserEntity(
      id: user.id,
      email: user.email,
      phone: user.phone,
      firstName: profileData?['first_name'],
      lastName: profileData?['last_name'],
      avatarUrl: profileData?['avatar_url'],
      role: roleData?['role']?.toString(),
      active: roleData?['active'] as bool?,
      userMetadata: user.userMetadata,
      createdAt: user.createdAt,
    );
  }
}
