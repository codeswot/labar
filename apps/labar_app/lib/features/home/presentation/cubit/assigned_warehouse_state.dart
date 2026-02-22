import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/farmer_designation_entity.dart';

part 'assigned_warehouse_state.freezed.dart';

@freezed
class AssignedWarehouseState with _$AssignedWarehouseState {
  const factory AssignedWarehouseState.initial() = _Initial;
  const factory AssignedWarehouseState.loading() = _Loading;
  const factory AssignedWarehouseState.loaded(
      FarmerDesignationEntity? designation) = _Loaded;
  const factory AssignedWarehouseState.error(String message) = _Error;
}
