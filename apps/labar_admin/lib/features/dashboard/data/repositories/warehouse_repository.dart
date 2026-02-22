import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class WarehouseRepository {
  final SupabaseClient _supabaseClient;
  WarehouseRepository(this._supabaseClient);

  Future<List<Map<String, dynamic>>> getWarehouses() async {
    final response = await _supabaseClient.from('warehouses').select();
    return List<Map<String, dynamic>>.from(response);
  }
}
