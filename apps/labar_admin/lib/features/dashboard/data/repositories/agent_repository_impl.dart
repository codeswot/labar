import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AgentRepository {
  Future<List<Map<String, dynamic>>> getCreatedApplications();
  Future<void> updateApplication(String id, Map<String, dynamic> data);
  Future<void> deleteApplication(String id);
  Future<void> uploadAssets({
    required String applicationId,
    String? passportBase64,
    String? signatureBase64,
  });
  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  });
}

@LazySingleton(as: AgentRepository)
class AgentRepositoryImpl implements AgentRepository {
  final SupabaseClient _supabaseClient;

  AgentRepositoryImpl(this._supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getCreatedApplications() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    final response = await _supabaseClient
        .from('applications')
        .select()
        .eq('created_by', userId as Object);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> updateApplication(String id, Map<String, dynamic> data) async {
    await _supabaseClient.from('applications').update(data).eq('id', id);
  }

  @override
  Future<void> deleteApplication(String id) async {
    await _supabaseClient.from('applications').delete().eq('id', id);
  }

  @override
  Future<void> uploadAssets({
    required String applicationId,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'upload_application_assets',
      'applicationId': applicationId,
      'passportBase64': passportBase64,
      'signatureBase64': signatureBase64,
    });
  }

  @override
  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    await _supabaseClient.functions.invoke('admin-service', body: {
      'action': 'agent_create_farmer_application',
      'email': email,
      'metadata': metadata,
      'applicationData': applicationData,
      'passportBase64': passportBase64,
      'signatureBase64': signatureBase64,
    });
  }
}
