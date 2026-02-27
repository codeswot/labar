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
  Future<void> addOrUpdateInventory(
      String warehouseId, String itemName, num quantity, String unit);
  Future<List<Map<String, dynamic>>> getWaybills();
  Future<Map<String, dynamic>> createWaybill(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getWarehouses();
  Future<List<Map<String, dynamic>>> getInventoryAllocations(
      String inventoryId);
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
    await _supabaseClient.from('allocated_resources').insert({
      'application': applicationId,
      'item': item,
      'quantity': quantity,
      'collection_address': collectionAddress,
    });
  }

  @override
  Future<void> removeAllocatedResource(String resourceId) async {
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
        .select('*, warehouses!inner(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> addOrUpdateInventory(
      String warehouseId, String itemName, num quantity, String unit) async {
    final current = await _supabaseClient
        .from('inventory')
        .select()
        .eq('warehouse_id', warehouseId)
        .eq('item_name', itemName)
        .maybeSingle();

    if (current != null) {
      final newQ = (current['quantity'] as num) + quantity;
      await _supabaseClient
          .from('inventory')
          .update({'quantity': newQ}).eq('id', current['id']);
    } else {
      await _supabaseClient.from('inventory').insert({
        'warehouse_id': warehouseId,
        'item_name': itemName,
        'quantity': quantity,
        'unit': unit,
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWaybills() async {
    final response = await _supabaseClient
        .from('waybills')
        .select('*, warehouses!inner(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>> createWaybill(Map<String, dynamic> data) async {
    // Basic inventory deduction handling natively here.
    // In production, should use an RPC/Edge function for atomicity.
    final currentInv = await _supabaseClient
        .from('inventory')
        .select()
        .eq('warehouse_id', data['warehouse_id'])
        .eq('item_name', data['item_name'])
        .maybeSingle();

    if (currentInv == null) {
      throw Exception(
          'Item "${data['item_name']}" not found in selected warehouse inventory.');
    }

    final currentQ = currentInv['quantity'] as num;
    final toDeduct = data['quantity'] as num;
    if (currentQ < toDeduct) {
      throw Exception(
          'Insufficient inventory. Have $currentQ but tried to dispatch $toDeduct');
    }

    final newQ = currentQ - toDeduct;
    await _supabaseClient
        .from('inventory')
        .update({'quantity': newQ}).eq('id', currentInv['id']);

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
  Future<List<Map<String, dynamic>>> getInventoryAllocations(
      String inventoryId) async {
    final response = await _supabaseClient
        .from('allocated_resources')
        .select('*, applications(*)')
        .eq('item', inventoryId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
