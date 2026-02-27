import 'package:labar_app/features/home/domain/entities/farmer_designation_entity.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';

abstract class WarehouseRepository {
  /// Stream of the warehouse designation for a specific application.
  Stream<FarmerDesignationEntity?> watchWarehouseDesignation(
      String applicationId);

  /// Get all available warehouses.
  Future<List<WarehouseEntity>> getWarehouses();
}
