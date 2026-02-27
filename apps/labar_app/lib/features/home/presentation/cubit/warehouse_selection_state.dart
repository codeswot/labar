import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';

part 'warehouse_selection_state.freezed.dart';

@freezed
class WarehouseSelectionState with _$WarehouseSelectionState {
  const factory WarehouseSelectionState({
    @Default([]) List<WarehouseEntity> warehouses,
    @Default([]) List<WarehouseEntity> filteredWarehouses,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String searchQuery,
  }) = _WarehouseSelectionState;
}
