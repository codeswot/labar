import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';
import 'package:labar_app/features/home/domain/entities/farmer_designation_entity.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';
import 'package:labar_app/features/home/domain/repositories/warehouse_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: WarehouseRepository)
class WarehouseRepositoryImpl implements WarehouseRepository {
  final SupabaseClient _supabaseClient;

  WarehouseRepositoryImpl(this._supabaseClient);

  @override
  Stream<FarmerDesignationEntity?> watchWarehouseDesignation(
      String applicationId) {
    return _supabaseClient
        .from('farmer_designation')
        .stream(primaryKey: ['id'])
        .eq('application', applicationId)
        .asyncMap((data) async {
          if (data.isEmpty) return null;

          final designationData = data.first;
          final warehouseId = designationData['warehouse'] as String;

          // Fetch warehouse details
          final warehouseData = await _supabaseClient
              .from('warehouses')
              .select()
              .eq('id', warehouseId)
              .maybeSingle();

          // Fetch allocated resources
          final resourcesData = await _supabaseClient
              .from('allocated_resources')
              .select()
              .eq('application', applicationId);

          final resources = (resourcesData as List)
              .map((r) => AllocatedResourceEntity.fromJson(r))
              .toList();

          final designation = FarmerDesignationEntity.fromJson(designationData);

          if (warehouseData == null) {
            return designation.copyWith(allocatedResources: resources);
          }

          final warehouse = WarehouseEntity.fromJson(warehouseData);
          return designation.copyWith(
            warehouseDetails: warehouse,
            allocatedResources: resources,
          );
        });
  }

  @override
  Future<List<WarehouseEntity>> getWarehouses() async {
    final response = await _supabaseClient
        .from('warehouses')
        .select()
        .order('name', ascending: true);

    return (response as List)
        .map((json) => WarehouseEntity.fromJson(json))
        .toList();
  }
}

extension on FarmerDesignationEntity {
  FarmerDesignationEntity copyWith({
    WarehouseEntity? warehouseDetails,
    List<AllocatedResourceEntity>? allocatedResources,
  }) {
    return FarmerDesignationEntity(
      id: id,
      application: application,
      warehouse: warehouse,
      note: note,
      createdAt: createdAt,
      warehouseDetails: warehouseDetails ?? this.warehouseDetails,
      allocatedResources: allocatedResources ?? this.allocatedResources,
    );
  }
}
