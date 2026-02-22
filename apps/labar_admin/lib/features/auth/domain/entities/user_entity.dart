import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    Map<String, dynamic>? userMetadata,
    required DateTime createdAt,
    String? role,
    bool? active,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
