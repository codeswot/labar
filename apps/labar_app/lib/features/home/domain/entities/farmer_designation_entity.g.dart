// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_designation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmerDesignationEntity _$FarmerDesignationEntityFromJson(
        Map<String, dynamic> json) =>
    FarmerDesignationEntity(
      id: json['id'] as String,
      application: json['application'] as String,
      warehouse: json['warehouse'] as String,
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FarmerDesignationEntityToJson(
        FarmerDesignationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application': instance.application,
      'warehouse': instance.warehouse,
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
    };
