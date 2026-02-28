import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'warehouse_entity.g.dart';

@JsonSerializable()
class WarehouseEntity extends Equatable {
  final String id;
  final String name;
  final String? location;
  final String? contactNumber;
  final String? state;
  final String? address;
  final DateTime? createdAt;

  const WarehouseEntity({
    required this.id,
    required this.name,
    this.location,
    this.contactNumber,
    this.state,
    this.address,
    this.createdAt,
  });

  factory WarehouseEntity.fromJson(Map<String, dynamic> json) =>
      _$WarehouseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseEntityToJson(this);

  @override
  List<Object?> get props =>
      [id, name, location, contactNumber, state, address, createdAt];
}
