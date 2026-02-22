import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'allocated_resource_entity.dart';
import 'warehouse_entity.dart';

part 'farmer_designation_entity.g.dart';

@JsonSerializable()
class FarmerDesignationEntity extends Equatable {
  final String id;
  final String application;
  final String warehouse;
  final String? note;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  // Joined data
  @JsonKey(includeToJson: false, includeFromJson: false)
  final WarehouseEntity? warehouseDetails;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<AllocatedResourceEntity> allocatedResources;

  const FarmerDesignationEntity({
    required this.id,
    required this.application,
    required this.warehouse,
    this.note,
    this.createdAt,
    this.warehouseDetails,
    this.allocatedResources = const [],
  });

  factory FarmerDesignationEntity.fromJson(Map<String, dynamic> json) =>
      _$FarmerDesignationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerDesignationEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        application,
        warehouse,
        note,
        createdAt,
        warehouseDetails,
        allocatedResources,
      ];
}
