import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_admin/core/utils/app_logger.dart';
import 'package:labar_admin/features/dashboard/data/repositories/admin_repository_impl.dart';

part 'inventory_management_cubit.freezed.dart';

@freezed
class InventoryManagementState with _$InventoryManagementState {
  const factory InventoryManagementState({
    @Default(false) bool isLoading,
    @Default(false) bool isInventoryLoadingMore,
    @Default(true) bool hasMoreInventory,
    @Default(1) int inventoryPage,
    @Default(false) bool isWaybillsLoadingMore,
    @Default(true) bool hasMoreWaybills,
    @Default(1) int waybillsPage,
    @Default([]) List<Map<String, dynamic>> inventory,
    @Default([]) List<Map<String, dynamic>> waybills,
    @Default([]) List<Map<String, dynamic>> warehouses,
    @Default([]) List<Map<String, dynamic>> items,
    @Default([]) List<Map<String, dynamic>> selectedInventoryAllocations,
    @Default([]) List<Map<String, dynamic>> selectedWarehouseAllocations,
    @Default([]) List<Map<String, dynamic>> selectedWarehouseFarmers,
    @Default([]) List<Map<String, dynamic>> selectedWarehouseManagers,
    @Default([]) List<UserEntity> potentialManagers,
    String? error,
  }) = _InventoryManagementState;
}

@injectable
class InventoryManagementCubit extends Cubit<InventoryManagementState> {
  final AdminRepository _repository;
  final SessionCubit _sessionCubit;
  StreamSubscription? _inventorySubscription;
  StreamSubscription? _waybillSubscription;
  StreamSubscription? _warehouseSubscription;
  RealtimeChannel? _realtimeChannel;

  InventoryManagementCubit(this._repository, this._sessionCubit)
      : super(const InventoryManagementState());

  static const int pageSize = 50;

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = _sessionCubit.state.user;
      final isManager = user?.role == 'warehouse_manager';
      final managerWarehouseId = isManager ? user?.warehouseId : null;

      final warehouses =
          await _repository.getWarehouses(warehouseId: managerWarehouseId);
      final items = await _repository.getItems();

      emit(state.copyWith(
        warehouses: warehouses,
        items: items,
      ));

      await fetchInventory(refresh: true);
      await fetchWaybills(refresh: true);

      // Subscribe to streams for real-time updates
      _warehouseSubscription?.cancel();
      _warehouseSubscription = _repository
          .warehousesStream(warehouseId: managerWarehouseId)
          .listen((warehouses) {
        if (state.warehouses.isEmpty) {
          emit(state.copyWith(warehouses: warehouses));
        }
      });

      _inventorySubscription?.cancel();
      _inventorySubscription = _repository
          .inventoryStream(warehouseId: managerWarehouseId)
          .listen((inventory) {
        // Only update if not currently loading/paging to avoid sync issues
        if (!state.isLoading && state.inventory.isEmpty) {
          emit(state.copyWith(inventory: inventory));
        }
      });

      _waybillSubscription?.cancel();
      _waybillSubscription = _repository
          .waybillsStream(warehouseId: managerWarehouseId)
          .listen((waybills) {
        if (!state.isLoading && state.waybills.isEmpty) {
          emit(state.copyWith(waybills: waybills));
        }
      });

      // Surgical realtime updates
      _realtimeChannel?.unsubscribe();
      final client = (_repository as AdminRepositoryImpl).supabaseClient;
      _realtimeChannel = client.channel('public:surgical_inventory');

      _realtimeChannel!
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'inventory',
            callback: (payload) async {
              final id = payload.newRecord['id'] ?? payload.oldRecord['id'];
              if (id == null) return;

              // Filter by warehouse if manager
              if (managerWarehouseId != null) {
                final recordWarehouseId =
                    payload.newRecord['warehouse_id']?.toString();
                if (recordWarehouseId != null &&
                    recordWarehouseId != managerWarehouseId) {
                  // If it's an update and was previously in our list, remove it
                  if (payload.eventType == PostgresChangeEvent.update) {
                    final updated =
                        List<Map<String, dynamic>>.from(state.inventory)
                          ..removeWhere((i) => i['id'] == id);
                    emit(state.copyWith(inventory: updated));
                  }
                  return;
                }
              }

              if (payload.eventType == PostgresChangeEvent.delete) {
                final updated = List<Map<String, dynamic>>.from(state.inventory)
                  ..removeWhere((i) => i['id'] == id);
                emit(state.copyWith(inventory: updated));
              } else {
                final updatedItem = await _repository.getInventoryById(id);
                if (updatedItem != null) {
                  final updatedList =
                      List<Map<String, dynamic>>.from(state.inventory);
                  final index = updatedList.indexWhere((i) => i['id'] == id);
                  if (index != -1) {
                    updatedList[index] = updatedItem;
                  } else {
                    updatedList.insert(0, updatedItem);
                  }
                  emit(state.copyWith(inventory: updatedList));
                }
              }
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'waybills',
            callback: (payload) async {
              final id = payload.newRecord['id'] ?? payload.oldRecord['id'];
              if (id == null) return;

              // Filter by warehouse if manager
              if (managerWarehouseId != null) {
                final recordWarehouseId =
                    payload.newRecord['warehouse_id']?.toString();
                if (recordWarehouseId != null &&
                    recordWarehouseId != managerWarehouseId) {
                  if (payload.eventType == PostgresChangeEvent.update) {
                    final updated =
                        List<Map<String, dynamic>>.from(state.waybills)
                          ..removeWhere((w) => w['id'] == id);
                    emit(state.copyWith(waybills: updated));
                  }
                  return;
                }
              }

              if (payload.eventType == PostgresChangeEvent.delete) {
                final updated = List<Map<String, dynamic>>.from(state.waybills)
                  ..removeWhere((w) => w['id'] == id);
                emit(state.copyWith(waybills: updated));
              } else {
                final updatedItem = await _repository.getWaybillById(id);
                if (updatedItem != null) {
                  final updatedList =
                      List<Map<String, dynamic>>.from(state.waybills);
                  final index = updatedList.indexWhere((w) => w['id'] == id);
                  if (index != -1) {
                    updatedList[index] = updatedItem;
                  } else {
                    updatedList.insert(0, updatedItem);
                  }
                  emit(state.copyWith(waybills: updatedList));
                }
              }
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'warehouses',
            callback: (payload) async {
              final user = _sessionCubit.state.user;
              final isManager = user?.role == 'warehouse_manager';
              final managerWarehouseId = isManager ? user?.warehouseId : null;
              // Warehouses are small, cool to refresh all or just fetch initial list
              final warehouses =
                  await _repository.getWarehouses(warehouseId: managerWarehouseId);
              emit(state.copyWith(warehouses: warehouses));
            },
          )
          .subscribe();

      emit(state.copyWith(isLoading: false));
    } catch (e, stack) {
      AppLogger.error('Failed to init inventory', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchInventory({bool refresh = false}) async {
    if (!refresh && (state.isInventoryLoadingMore || !state.hasMoreInventory))
      return;

    if (refresh) {
      emit(state.copyWith(
        isLoading: true,
        inventoryPage: 1,
        hasMoreInventory: true,
        inventory: [],
      ));
    } else {
      emit(state.copyWith(isInventoryLoadingMore: true));
    }

    try {
      final user = _sessionCubit.state.user;
      final isManager = user?.role == 'warehouse_manager';
      final warehouseId = isManager ? user?.warehouseId : null;

      final page = refresh ? 1 : state.inventoryPage;
      final offset = (page - 1) * pageSize;

      final newInventory = await _repository.getInventory(
        limit: pageSize,
        offset: offset,
        warehouseId: warehouseId,
      );

      final List<Map<String, dynamic>> updatedInventory =
          refresh ? newInventory : [...state.inventory, ...newInventory];

      emit(state.copyWith(
        isLoading: false,
        isInventoryLoadingMore: false,
        inventory: updatedInventory,
        inventoryPage: page + 1,
        hasMoreInventory: newInventory.length == pageSize,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch inventory', e, stack);
      emit(state.copyWith(
        isLoading: false,
        isInventoryLoadingMore: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> fetchWaybills({bool refresh = false}) async {
    if (!refresh && (state.isWaybillsLoadingMore || !state.hasMoreWaybills))
      return;

    if (refresh) {
      emit(state.copyWith(
        isLoading: true,
        waybillsPage: 1,
        hasMoreWaybills: true,
        waybills: [],
      ));
    } else {
      emit(state.copyWith(isWaybillsLoadingMore: true));
    }

    try {
      final user = _sessionCubit.state.user;
      final isManager = user?.role == 'warehouse_manager';
      final warehouseId = isManager ? user?.warehouseId : null;

      final page = refresh ? 1 : state.waybillsPage;
      final offset = (page - 1) * pageSize;

      final newWaybills = await _repository.getWaybills(
        limit: pageSize,
        offset: offset,
        warehouseId: warehouseId,
      );

      final List<Map<String, dynamic>> updatedWaybills =
          refresh ? newWaybills : [...state.waybills, ...newWaybills];

      emit(state.copyWith(
        isLoading: false,
        isWaybillsLoadingMore: false,
        waybills: updatedWaybills,
        waybillsPage: page + 1,
        hasMoreWaybills: newWaybills.length == pageSize,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch waybills', e, stack);
      emit(state.copyWith(
        isLoading: false,
        isWaybillsLoadingMore: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> addWarehouse({
    required String name,
    required String address,
    String? state,
  }) async {
    try {
      await _repository.addWarehouse(
        name: name,
        address: address,
        state: state,
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
  }) async {
    try {
      await _repository.updateWarehouse(
        id: id,
        name: name,
        address: address,
        state: state,
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
        selectedWarehouseAllocations: [],
        selectedWarehouseManagers: []));
    try {
      final farmers = await _repository.getWarehouseFarmers(warehouseId);
      final allocations =
          await _repository.getWarehouseAllocations(warehouseId);
      final managers = await _repository.getWarehouseManagers(warehouseId);

      emit(state.copyWith(
        isLoading: false,
        selectedWarehouseFarmers: farmers,
        selectedWarehouseAllocations: allocations,
        selectedWarehouseManagers: managers,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch warehouse details', e, stack);
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchPotentialManagers() async {
    try {
      final managers = await _repository.getPotentialManagers();
      emit(state.copyWith(potentialManagers: managers));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch potential managers', e, stack);
    }
  }

  Future<void> assignManager(String userId, String warehouseId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.assignWarehouseManager(userId, warehouseId);
      // Refresh details
      await fetchWarehouseDetails(warehouseId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> unassignManager(String userId, String warehouseId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.unassignWarehouseManager(userId);
      // Refresh details
      await fetchWarehouseDetails(warehouseId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _inventorySubscription?.cancel();
    _waybillSubscription?.cancel();
    _warehouseSubscription?.cancel();
    _realtimeChannel?.unsubscribe();
    return super.close();
  }
}
