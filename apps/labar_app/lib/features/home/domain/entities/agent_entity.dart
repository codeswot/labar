import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agent_entity.g.dart';

@JsonSerializable()
class AgentEntity extends Equatable {
  final String id;
  final String? email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  const AgentEntity({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory AgentEntity.fromJson(Map<String, dynamic> json) =>
      _$AgentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AgentEntityToJson(this);

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl];
}
