import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allocated_resource_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AllocatedResourceEntity extends Equatable {
  final String id;
  final String application;
  final String? item; // Contains the UUID
  final num quantity;
  final String collectionAddress;
  final bool isCollected;
  final DateTime createdAt;
  final Map<String, dynamic>? inventoryItem;

  const AllocatedResourceEntity({
    required this.id,
    required this.application,
    this.item,
    this.quantity = 0,
    required this.collectionAddress,
    required this.isCollected,
    required this.createdAt,
    this.inventoryItem,
  });

  factory AllocatedResourceEntity.fromJson(Map<String, dynamic> json) =>
      _$AllocatedResourceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AllocatedResourceEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        application,
        item,
        quantity,
        collectionAddress,
        isCollected,
        createdAt,
        inventoryItem,
      ];
}
