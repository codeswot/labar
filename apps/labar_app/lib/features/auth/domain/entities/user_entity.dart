import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? role;
  final bool? active;
  final Map<String, dynamic>? userMetadata;
  final String? createdAt;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.role,
    this.active,
    this.userMetadata,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        avatarUrl,
        role,
        active,
        userMetadata,
        createdAt
      ];
}
