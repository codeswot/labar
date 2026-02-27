// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentEntity _$AgentEntityFromJson(Map<String, dynamic> json) => AgentEntity(
      id: json['id'] as String,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$AgentEntityToJson(AgentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
    };
