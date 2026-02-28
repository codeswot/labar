// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseEntity _$WarehouseEntityFromJson(Map<String, dynamic> json) =>
    WarehouseEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      contactNumber: json['contactNumber'] as String?,
      state: json['state'] as String?,
      address: json['address'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WarehouseEntityToJson(WarehouseEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'contactNumber': instance.contactNumber,
      'state': instance.state,
      'address': instance.address,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
