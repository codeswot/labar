import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:labar_admin/core/utils/app_logger.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>> getUsers({int? limit, int? offset});
  Future<String?> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    Map<String, dynamic>? metadata,
  });
  Future<void> deleteUser(String userId);
  Future<void> toggleUserStatus({required String userId, required bool active});
  Future<void> assignWarehouse({
    required String applicationId,
    required String warehouseId,
    String? note,
  });
  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  });
  Future<void> deleteApplication(String id);
  Future<void> updateApplicationStatus(String id, String status);
  Future<void> updateUserRole(String userId, String role);
  Future<Map<String, dynamic>?> getFarmerDesignation(String applicationId);
  Future<List<Map<String, dynamic>>> getAllocatedResources(
      String applicationId);
  Future<void> allocateResource({
    required String applicationId,
    required String item,
    required num quantity,
    required String collectionAddress,
  });
  Future<void> removeAllocatedResource(String resourceId);
  Future<void> markAllocatedResourceAsCollected(String resourceId);
  Future<void> unassignWarehouse(String applicationId);

  // Item Management
  Future<List<Map<String, dynamic>>> getItems();
  Future<void> addItem({
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  });
  Future<void> updateItem({
    required String id,
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  });
  Future<void> deleteItem(String id);

  // Inventory & Waybills
  Future<List<Map<String, dynamic>>> getItemsByLocation(
      String location); // To filter items by location if needed
  Future<List<Map<String, dynamic>>> getInventory(
      {int? limit, int? offset, String? warehouseId});
  Future<void> addOrUpdateInventory({
    required String warehouseId,
    required String itemId,
    required String
        itemName, // Keep for backward compatibility or unique index requirement
    required num quantity,
  });
  Future<void> updateInventoryQuantity(String id, num quantity);
  Future<void> deleteInventory(String id);
  Future<List<Map<String, dynamic>>> getWaybills(
      {int? limit, int? offset, String? warehouseId});
  Future<Map<String, dynamic>> createWaybill(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getWarehouses();
  Future<void> addWarehouse({
    required String name,
    required String address,
    String? state,
  });
  Future<void> updateWarehouse({
    required String id,
    required String name,
    required String address,
    String? state,
  });
  Future<List<Map<String, dynamic>>> getInventoryAllocations(
      String inventoryId);
  Future<List<Map<String, dynamic>>> getWarehouseFarmers(String warehouseId);
  Future<List<Map<String, dynamic>>> getWarehouseAllocations(
      String warehouseId);

  Future<UserEntity?> getUserById(String userId);
  Future<Map<String, dynamic>?> getInventoryById(String id);
  Future<Map<String, dynamic>?> getWaybillById(String id);
  Future<void> assignWarehouseManager(String userId, String warehouseId);
  Future<void> unassignWarehouseManager(String userId);
  Future<List<Map<String, dynamic>>> getWarehouseManagers(String warehouseId);
  Future<List<UserEntity>> getPotentialManagers();

  // Streams for real-time
  Stream<List<UserEntity>> get usersStream;
  Stream<List<Map<String, dynamic>>> get itemsStream;
  Stream<List<Map<String, dynamic>>> inventoryStream({String? warehouseId});
  Stream<List<Map<String, dynamic>>> waybillsStream({String? warehouseId});
  Stream<List<Map<String, dynamic>>> get warehousesStream;
}

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  final SupabaseClient _supabaseClient;

  SupabaseClient get supabaseClient => _supabaseClient;

  AdminRepositoryImpl(this._supabaseClient);

  @override
  Future<List<UserEntity>> getUsers({int? limit, int? offset}) async {
    dynamic query = _supabaseClient
        .from('profiles')
        .select('*, user_roles(*), warehouse_managers(*, warehouses(*))');

    if (offset != null && limit != null) {
      query = query.range(offset, offset + limit - 1);
    } else if (limit != null) {
      query = query.limit(limit);
    }

    final response =
        await (query as dynamic).order('updated_at', ascending: false);

    return (response as List).map((data) {
      return _mapToUserEntity(data);
    }).toList();
  }

  UserEntity _mapToUserEntity(Map<String, dynamic> data) {
    final roleValue = data['user_roles'];
    final Map<String, dynamic>? roleData = (roleValue is List &&
            roleValue.isNotEmpty)
        ? roleValue.first as Map<String, dynamic>
        : (roleValue is Map ? roleValue as Map<String, dynamic> : null);

    final wmValue = data['warehouse_managers'];
    final Map<String, dynamic>? wmInfo = (wmValue is List && wmValue.isNotEmpty)
        ? wmValue.first as Map<String, dynamic>
        : (wmValue is Map ? wmValue as Map<String, dynamic> : null);
    final warehouseData = wmInfo?['warehouses'];
    final Map<String, dynamic>? warehouse = (warehouseData is Map)
        ? warehouseData as Map<String, dynamic>
        : (warehouseData is List && warehouseData.isNotEmpty)
            ? warehouseData.first as Map<String, dynamic>
            : null;

    return UserEntity(
      id: data['id'],
      email: data['email'],
      phone: data['phone'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      avatarUrl: data['avatar_url'],
      role: roleData?['role']?.toString(),
      active: roleData?['active'] as bool? ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      warehouseId: wmInfo?['warehouse_id']?.toString(),
      warehouseName: warehouse?['name']?.toString(),
    );
  }

  @override
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select('*, user_roles(*), warehouse_managers(*, warehouses(*))')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return _mapToUserEntity(response);
    } catch (e) {
      return null;
    }
  }

  @override
  @override
  Future<String?> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'create_user',
      'email': email,
      'password': password,
      'role': role,
      'metadata': {
        ...?metadata,
        'first_name': firstName,
        'last_name': lastName,
      },
    });

    if (response.data != null && response.data['user'] != null) {
      return response.data['user']['id'];
    }
    return null;
  }

  @override
  Future<void> toggleUserStatus(
      {required String userId, required bool active}) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'toggle_user_status',
      'userId': userId,
      'active': active,
    });
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'delete_user',
      'userId': userId,
    });
  }

  @override
  Future<void> assignWarehouse({
    required String applicationId,
    required String warehouseId,
    String? note,
  }) async {
    await _supabaseClient.from('farmer_designation').upsert(
      {
        'application': applicationId,
        'warehouse': warehouseId,
        'note': note,
      },
      onConflict: 'application',
    );
  }

  @override
  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    AppLogger.info('--- Create Application Request ---');
    AppLogger.info('Email: $email');
    AppLogger.debug('Data: ${jsonEncode(applicationData)}');
    try {
      final response =
          await _supabaseClient.functions.invoke('admin-service', body: {
        'action': 'agent_create_farmer_application',
        'email': email,
        'metadata': metadata,
        'applicationData': applicationData,
        'passportBase64': passportBase64,
        'signatureBase64': signatureBase64,
      });
      AppLogger.info('--- Create Application Success ---');
      AppLogger.info('Response status: ${response.status}');
      AppLogger.debug('Response data: ${response.data}');
    } catch (e, stack) {
      AppLogger.error('--- Create Application Error ---', e, stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteApplication(String id) async {
    await _supabaseClient.from('applications').delete().eq('id', id);
  }

  @override
  Future<void> updateApplicationStatus(String id, String status) async {
    await _supabaseClient
        .from('applications')
        .update({'status': status}).eq('id', id);
  }

  @override
  Future<void> updateUserRole(String userId, String role) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'update_role',
      'userId': userId,
      'role': role,
    });
  }

  @override
  Future<Map<String, dynamic>?> getFarmerDesignation(
      String applicationId) async {
    final response = await _supabaseClient
        .from('farmer_designation')
        .select('*, warehouses(*)')
        .eq('application', applicationId)
        .maybeSingle();
    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getAllocatedResources(
      String applicationId) async {
    final response = await _supabaseClient
        .from('allocated_resources')
        .select('*, inventory(*, items(*))')
        .eq('application', applicationId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> allocateResource({
    required String applicationId,
    required String item,
    required num quantity,
    required String collectionAddress,
  }) async {
    // Allocation record is inserted, DB trigger will deduct quantity from inventory
    await _supabaseClient.from('allocated_resources').insert({
      'application': applicationId,
      'item': item,
      'quantity': quantity,
      'collection_address': collectionAddress,
    });
  }

  @override
  Future<void> removeAllocatedResource(String resourceId) async {
    // Delete allocation record, DB trigger will add quantity back to inventory
    await _supabaseClient
        .from('allocated_resources')
        .delete()
        .eq('id', resourceId);
  }

  @override
  Future<void> markAllocatedResourceAsCollected(String resourceId) async {
    await _supabaseClient
        .from('allocated_resources')
        .update({'is_collected': true}).eq('id', resourceId);
  }

  @override
  Future<void> unassignWarehouse(String applicationId) async {
    await _supabaseClient
        .from('farmer_designation')
        .delete()
        .eq('application', applicationId);
  }

  @override
  Future<List<Map<String, dynamic>>> getItems() async {
    final response = await _supabaseClient
        .from('items')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> addItem({
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  }) async {
    await _supabaseClient.from('items').insert({
      'name': name,
      'unit': unit,
      'price': price,
      'location': location,
      'description': description,
    });
  }

  @override
  Future<void> updateItem({
    required String id,
    required String name,
    required String unit,
    required num price,
    required String location,
    String? description,
  }) async {
    await _supabaseClient.from('items').update({
      'name': name,
      'unit': unit,
      'price': price,
      'location': location,
      'description': description,
    }).eq('id', id);
  }

  @override
  Future<void> deleteItem(String id) async {
    await _supabaseClient.from('items').delete().eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> getItemsByLocation(String location) async {
    final response = await _supabaseClient
        .from('items')
        .select()
        .eq('location', location)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getInventory(
      {int? limit, int? offset, String? warehouseId}) async {
    dynamic query = _supabaseClient
        .from('inventory')
        .select('*, warehouses!inner(name, state, address), items!inner(*)');

    if (warehouseId != null) {
      query = query.eq('warehouse_id', warehouseId);
    }

    if (limit != null) {
      final end = (offset ?? 0) + limit - 1;
      query = (query as PostgrestFilterBuilder).range(offset ?? 0, end);
    }

    final response =
        await (query as dynamic).order('updated_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> getInventoryById(String id) async {
    try {
      final response = await _supabaseClient
          .from('inventory')
          .select('*, warehouses!inner(name, state, address), items!inner(*)')
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getWaybillById(String id) async {
    try {
      final response = await _supabaseClient
          .from('waybills')
          .select('*, warehouse:warehouses!inner(name)')
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> assignWarehouseManager(String userId, String warehouseId) async {
    await _supabaseClient.from('warehouse_managers').upsert({
      'user_id': userId,
      'warehouse_id': warehouseId,
    }, onConflict: 'user_id');
  }

  @override
  Future<void> unassignWarehouseManager(String userId) async {
    await _supabaseClient
        .from('warehouse_managers')
        .delete()
        .eq('user_id', userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouseManagers(
      String warehouseId) async {
    final response = await _supabaseClient
        .from('warehouse_managers')
        .select('*, profiles(*)')
        .eq('warehouse_id', warehouseId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<UserEntity>> getPotentialManagers() async {
    final response = await _supabaseClient
        .from('profiles')
        .select('*, user_roles!inner(*)')
        .eq('user_roles.role', 'warehouse_manager');

    final List<UserEntity> users = [];
    for (var item in response) {
      // Check if already assigned? 
      // Actually we can keep it simple and filter in UI or just show all.
      // But let's map it.
      users.add(_mapToUserEntity(item));
    }
    return users;
  }

  @override
  Future<void> addOrUpdateInventory({
    required String warehouseId,
    required String itemId,
    required String itemName,
    required num quantity,
  }) async {
    final current = await _supabaseClient
        .from('inventory')
        .select()
        .eq('warehouse_id', warehouseId)
        .eq('item_id', itemId)
        .maybeSingle();

    if (current != null) {
      final newQ = (current['quantity'] as num) + quantity;
      await _supabaseClient.from('inventory').update({
        'quantity': newQ,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', current['id']);
    } else {
      await _supabaseClient.from('inventory').insert({
        'warehouse_id': warehouseId,
        'item_id': itemId,
        'item_name': itemName,
        'quantity': quantity,
      });
    }
  }

  @override
  Future<void> updateInventoryQuantity(String id, num quantity) async {
    await _supabaseClient.from('inventory').update({
      'quantity': quantity,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  @override
  Future<void> deleteInventory(String id) async {
    await _supabaseClient.from('inventory').delete().eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> getWaybills(
      {int? limit, int? offset, String? warehouseId}) async {
    dynamic query = _supabaseClient
        .from('waybills')
        .select('*, warehouse:warehouses!inner(name)');

    if (warehouseId != null) {
      query = query.eq('warehouse_id', warehouseId);
    }

    if (limit != null) {
      final end = (offset ?? 0) + limit - 1;
      query = (query as PostgrestFilterBuilder).range(offset ?? 0, end);
    }

    final response =
        await (query as dynamic).order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>> createWaybill(Map<String, dynamic> data) async {
    // Waybill record is inserted, DB trigger will deduct quantity from inventory
    final response = await _supabaseClient
        .from('waybills')
        .insert(data)
        .select('*, warehouses!inner(name)')
        .single();

    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouses() async {
    final response = await _supabaseClient
        .from('warehouses')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> addWarehouse({
    required String name,
    required String address,
    String? state,
  }) async {
    await _supabaseClient.from('warehouses').insert({
      'name': name,
      'address': address,
      'state': state,
    });
  }

  @override
  Future<void> updateWarehouse({
    required String id,
    required String name,
    required String address,
    String? state,
  }) async {
    await _supabaseClient.from('warehouses').update({
      'name': name,
      'address': address,
      'state': state,
    }).eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> getInventoryAllocations(
      String inventoryId) async {
    final response = await _supabaseClient
        .from('allocated_resources')
        .select('*, applications(*), inventory(*, items(*))')
        .eq('item', inventoryId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouseFarmers(
      String warehouseId) async {
    final response = await _supabaseClient
        .from('farmer_designation')
        .select('*, applications(*)')
        .eq('warehouse', warehouseId);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouseAllocations(
      String warehouseId) async {
    // Join via inventory link
    final response = await _supabaseClient
        .from('allocated_resources')
        .select('*, inventory!inner(*, items(*)), applications(*)')
        .eq('inventory.warehouse_id', warehouseId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Stream<List<UserEntity>> get usersStream => _supabaseClient
      .from('profiles')
      .stream(primaryKey: ['id'])
      .order('updated_at', ascending: false)
      .asyncMap((event) async {
        return await getUsers();
      });

  @override
  Stream<List<Map<String, dynamic>>> get itemsStream => _supabaseClient
      .from('items')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .asyncMap((event) async {
        return await getItems();
      });

  @override
  Stream<List<Map<String, dynamic>>> inventoryStream({String? warehouseId}) =>
      _supabaseClient
          .from('inventory')
          .stream(primaryKey: ['id'])
          .order('updated_at', ascending: false)
          .asyncMap((event) async {
        return await getInventory(warehouseId: warehouseId);
      });

  @override
  Stream<List<Map<String, dynamic>>> waybillsStream({String? warehouseId}) =>
      _supabaseClient
          .from('waybills')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .asyncMap((event) async {
        return await getWaybills(warehouseId: warehouseId);
      });

  @override
  Stream<List<Map<String, dynamic>>> get warehousesStream => _supabaseClient
          .from('warehouses')
          .stream(primaryKey: ['id']).asyncMap((event) async {
        return await getWarehouses();
      });
}
