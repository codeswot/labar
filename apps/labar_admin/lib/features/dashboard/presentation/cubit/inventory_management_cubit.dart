import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_admin/core/utils/app_logger.dart';
import 'package:labar_admin/features/dashboard/data/repositories/admin_repository_impl.dart';
import '../../../auth/domain/entities/user_entity.dart';

part 'inventory_management_cubit.freezed.dart';

@freezed
class InventoryManagementState with _$InventoryManagementState {
  const factory InventoryManagementState({
    @Default(false) bool isLoading,
    @Default([]) List<Map<String, dynamic>> inventory,
    @Default([]) List<Map<String, dynamic>> waybills,
    @Default([]) List<Map<String, dynamic>> warehouses,
    @Default([]) List<Map<String, dynamic>> items,
    @Default([]) List<Map<String, dynamic>> selectedInventoryAllocations,
    @Default([]) List<Map<String, dynamic>> selectedWarehouseAllocations,
    @Default([]) List<Map<String, dynamic>> selectedWarehouseFarmers,
    @Default([]) List<UserEntity> managers,
    String? error,
  }) = _InventoryManagementState;
}

@injectable
class InventoryManagementCubit extends Cubit<InventoryManagementState> {
  final AdminRepository _repository;
  StreamSubscription? _inventorySubscription;
  StreamSubscription? _waybillSubscription;
  StreamSubscription? _warehouseSubscription;

  InventoryManagementCubit(this._repository)
      : super(const InventoryManagementState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Initial fetch if needed, but stream will emit too
      final inventory = await _repository.getInventory();
      final waybills = await _repository.getWaybills();
      final warehouses = await _repository.getWarehouses();
      final items = await _repository.getItems();

      final users = await _repository.getUsers();
      final managers =
          users.where((u) => u.role == 'warehouse_manager').toList();

      emit(state.copyWith(
        isLoading: false,
        inventory: inventory,
        waybills: waybills,
        warehouses: warehouses,
        items: items,
        managers: managers,
      ));

      // Subscribe for real-time updates
      _inventorySubscription?.cancel();
      _inventorySubscription = _repository.inventoryStream.listen((inventory) {
        emit(state.copyWith(inventory: inventory));
      });

      _waybillSubscription?.cancel();
      _waybillSubscription = _repository.waybillsStream.listen((waybills) {
        emit(state.copyWith(waybills: waybills));
      });

      _warehouseSubscription?.cancel();
      _warehouseSubscription =
          _repository.warehousesStream.listen((warehouses) {
        emit(state.copyWith(warehouses: warehouses));
      });
    } catch (e, stack) {
      AppLogger.error('Failed to init inventory', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _inventorySubscription?.cancel();
    _waybillSubscription?.cancel();
    _warehouseSubscription?.cancel();
    return super.close();
  }

  Future<void> addWarehouse({
    required String name,
    required String address,
    String? state,
    String? managerId,
  }) async {
    try {
      await _repository.addWarehouse(
        name: name,
        address: address,
        state: state,
        managerId: managerId,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to add warehouse', e, stack);
      if (!isClosed) emit(this.state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateWarehouse({
    required String id,
    required String name,
    required String address,
    String? state,
    String? managerId,
  }) async {
    try {
      await _repository.updateWarehouse(
        id: id,
        name: name,
        address: address,
        state: state,
        managerId: managerId,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to update warehouse', e, stack);
      if (!isClosed) emit(this.state.copyWith(error: e.toString()));
    }
  }

  Future<void> addInventory({
    required String warehouseId,
    required String itemId,
    required String itemName,
    required num quantity,
  }) async {
    try {
      await _repository.addOrUpdateInventory(
        warehouseId: warehouseId,
        itemId: itemId,
        itemName: itemName,
        quantity: quantity,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to add inventory', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateInventoryQuantity(String id, num quantity) async {
    try {
      await _repository.updateInventoryQuantity(id, quantity);
    } catch (e, stack) {
      AppLogger.error('Failed to update inventory quantity', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteInventory(String id) async {
    try {
      await _repository.deleteInventory(id);
    } catch (e, stack) {
      AppLogger.error('Failed to delete inventory', e, stack);
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> generateWaybill({
    required String warehouseId,
    required String destination,
    required String driverName,
    required String driverPhone,
    required String vehicleNumber,
    required String itemName,
    required num quantity,
    required String unit,
    required String createdBy,
  }) async {
    try {
      final data = {
        'warehouse_id': warehouseId,
        'destination': destination,
        'driver_name': driverName,
        'driver_phone': driverPhone,
        'vehicle_number': vehicleNumber,
        'item_name': itemName,
        'quantity': quantity,
        'unit': unit,
        'created_by': createdBy,
      };

      final waybill = await _repository.createWaybill(data);
      return waybill;
    } catch (e, stack) {
      AppLogger.error('Failed to generate waybill', e, stack);
      emit(state.copyWith(error: e.toString()));
      return null;
    }
  }

  Future<void> fetchInventoryDetails(String inventoryId) async {
    emit(state.copyWith(
        isLoading: true, error: null, selectedInventoryAllocations: []));
    try {
      final allocations =
          await _repository.getInventoryAllocations(inventoryId);
      emit(state.copyWith(
        isLoading: false,
        selectedInventoryAllocations: allocations,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch inventory details', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchWarehouseDetails(String warehouseId) async {
    emit(state.copyWith(
        isLoading: true,
        error: null,
        selectedWarehouseFarmers: [],
        selectedWarehouseAllocations: []));
    try {
      final farmers = await _repository.getWarehouseFarmers(warehouseId);
      final allocations =
          await _repository.getWarehouseAllocations(warehouseId);
      emit(state.copyWith(
        isLoading: false,
        selectedWarehouseFarmers: farmers,
        selectedWarehouseAllocations: allocations,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch warehouse details', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
