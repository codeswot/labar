import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? userMetadata;
  final String? createdAt;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.userMetadata,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, phone, userMetadata, createdAt];
}
