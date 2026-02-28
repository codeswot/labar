import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';
import 'package:labar_app/features/home/domain/repositories/allocated_resource_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AllocatedResourceRepository)
class AllocatedResourceRepositoryImpl implements AllocatedResourceRepository {
  final SupabaseClient _supabaseClient;

  AllocatedResourceRepositoryImpl(this._supabaseClient);

  @override
  Stream<List<AllocatedResourceEntity>> watchAllocatedResources(
      String applicationId) {
    return _supabaseClient
        .from('allocated_resources')
        .stream(primaryKey: ['id'])
        .eq('application', applicationId)
        .order('created_at', ascending: false)
        .asyncMap((data) async {
          // Collect unique item UUIDs
          final itemIds = data
              .map((d) => d['item'])
              .where((item) => item != null)
              .cast<String>()
              .toSet()
              .toList();

          final List<Map<String, dynamic>> inventoryDocs = [];
          if (itemIds.isNotEmpty) {
            final res = await _supabaseClient
                .from('inventory')
                .select('*, warehouses(name, state), items(*)')
                .inFilter('id', itemIds);
            inventoryDocs.addAll(List<Map<String, dynamic>>.from(res));
          }

          final inventoryMap = {for (var v in inventoryDocs) v['id']: v};

          return data.map((itemRow) {
            final inv = inventoryMap[itemRow['item']];
            // Merge the item row with the related inventory dict
            final mergedRow = Map<String, dynamic>.from(itemRow);
            if (inv != null) {
              mergedRow['inventory_item'] = inv;
            }
            return AllocatedResourceEntity.fromJson(mergedRow);
          }).toList();
        });
  }
}
