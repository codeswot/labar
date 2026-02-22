// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocated_resource_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllocatedResourceEntity _$AllocatedResourceEntityFromJson(
        Map<String, dynamic> json) =>
    AllocatedResourceEntity(
      id: json['id'] as String,
      application: json['application'] as String,
      item: json['item'] as String?,
      quantity: json['quantity'] as num? ?? 0,
      collectionAddress: json['collection_address'] as String,
      isCollected: json['is_collected'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      inventoryItem: json['inventory_item'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AllocatedResourceEntityToJson(
        AllocatedResourceEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application': instance.application,
      'item': instance.item,
      'quantity': instance.quantity,
      'collection_address': instance.collectionAddress,
      'is_collected': instance.isCollected,
      'created_at': instance.createdAt.toIso8601String(),
      'inventory_item': instance.inventoryItem,
    };
