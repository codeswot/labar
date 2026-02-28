import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:labar_admin/core/utils/app_logger.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>> getUsers();
  Future<void> createUser({
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

  // Inventory & Waybills
  Future<List<Map<String, dynamic>>> getInventory();
  Future<void> addOrUpdateInventory(String warehouseId, String itemName,
      num quantity, String unit, num? pricePerItem);
  Future<List<Map<String, dynamic>>> getWaybills();
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

  // Streams for real-time
  Stream<List<Map<String, dynamic>>> get inventoryStream;
  Stream<List<Map<String, dynamic>>> get waybillsStream;
  Stream<List<Map<String, dynamic>>> get warehousesStream;
}

@LazySingleton(as: AdminRepository)
class AdminRepositoryImpl implements AdminRepository {
  final SupabaseClient _supabaseClient;

  AdminRepositoryImpl(this._supabaseClient);

  @override
  Future<List<UserEntity>> getUsers() async {
    final response = await _supabaseClient.from('admin_user_view').select();

    return (response as List).map((data) {
      return UserEntity(
        id: data['id'],
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        avatarUrl: data['avatar_url'],
        userMetadata: data['raw_user_meta_data'],
        createdAt: DateTime.parse(data['created_at']),
        role: data['role'],
        active: data['active'],
      );
    }).toList();
  }

  @override
  Future<void> createUser({
    required String email,
    required String password,
    required String role,
    String? firstName,
    String? lastName,
    Map<String, dynamic>? metadata,
  }) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
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
        .select('*, inventory(*)')
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
  Future<List<Map<String, dynamic>>> getInventory() async {
    final response = await _supabaseClient
        .from('inventory')
        .select('*, warehouses!inner(name, state, address)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> addOrUpdateInventory(String warehouseId, String itemName,
      num quantity, String unit, num? pricePerItem) async {
    final current = await _supabaseClient
        .from('inventory')
        .select()
        .eq('warehouse_id', warehouseId)
        .eq('item_name', itemName)
        .maybeSingle();

    if (current != null) {
      final newQ = (current['quantity'] as num) + quantity;
      await _supabaseClient.from('inventory').update({
        'quantity': newQ,
        if (pricePerItem != null) 'price_per_item': pricePerItem,
      }).eq('id', current['id']);
    } else {
      await _supabaseClient.from('inventory').insert({
        'warehouse_id': warehouseId,
        'item_name': itemName,
        'quantity': quantity,
        'unit': unit,
        'price_per_item': pricePerItem,
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWaybills() async {
    final response = await _supabaseClient
        .from('waybills')
        .select('*, warehouses!inner(name, state)')
        .order('created_at', ascending: false);
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
    final response = await _supabaseClient.from('warehouses').select();
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
        .select('*, applications(*)')
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
        .select('*, inventory!inner(*), applications(*)')
        .eq('inventory.warehouse_id', warehouseId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Stream<List<Map<String, dynamic>>> get inventoryStream => _supabaseClient
      .from('inventory')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .asyncMap((event) async {
        // We need the joins, stream doesn't support them directly easily
        // but we can fetch the latest list when stream emits
        return await getInventory();
      });

  @override
  Stream<List<Map<String, dynamic>>> get waybillsStream => _supabaseClient
      .from('waybills')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .asyncMap((event) async {
        return await getWaybills();
      });

  @override
  Stream<List<Map<String, dynamic>>> get warehousesStream => _supabaseClient
          .from('warehouses')
          .stream(primaryKey: ['id']).asyncMap((event) async {
        return await getWarehouses();
      });
}
