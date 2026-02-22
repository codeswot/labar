import 'dart:async';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/utils/app_logger.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/submitted_application_entity.dart';
import 'package:labar_app/features/home/domain/repositories/application_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: ApplicationRepository)
class ApplicationRepositoryImpl implements ApplicationRepository {
  final SupabaseClient _supabaseClient;
  String get uid => _supabaseClient.auth.currentUser?.id ?? '';
  ApplicationRepositoryImpl(this._supabaseClient);

  @override
  Stream<ApplicationEntity?> getApplicationStream() {
    if (uid.isEmpty) return Stream.value(null);
    return _supabaseClient
        .from('applications')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .asyncMap((data) async {
          if (data.isEmpty) return null;
          return _mapToEntity(data.first);
        });
  }

  @override
  Future<ApplicationEntity?> getApplication() async {
    if (uid.isEmpty) return null;
    final data = await _supabaseClient
        .from('applications')
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;
    return _mapToEntity(data);
  }

  Future<ApplicationEntity> _mapToEntity(Map<String, dynamic> data) async {
    final submitted = SubmittedApplicationEntity.fromJson(data);

    String? passportUrl;
    if (submitted.passportPath != null && submitted.passportPath!.isNotEmpty) {
      try {
        passportUrl = await _supabaseClient.storage
            .from('uploads')
            .createSignedUrl(submitted.passportPath!, 3600);
      } catch (e) {
        AppLogger.error('Failed to create signed URL for passport', e);
      }
    }

    String? signatureUrl;
    if (submitted.signaturePath != null &&
        submitted.signaturePath!.isNotEmpty) {
      try {
        signatureUrl = await _supabaseClient.storage
            .from('uploads')
            .createSignedUrl(submitted.signaturePath!, 3600);
      } catch (e) {
        AppLogger.error('Failed to create signed URL for signature', e);
      }
    }

    String? proofOfPaymentUrl;
    if (submitted.proofOfPaymentPath != null &&
        submitted.proofOfPaymentPath!.isNotEmpty) {
      try {
        proofOfPaymentUrl = await _supabaseClient.storage
            .from('uploads')
            .createSignedUrl(submitted.proofOfPaymentPath!, 3600);
      } catch (e) {
        AppLogger.error('Failed to create signed URL for proof of payment', e);
      }
    }

    return submitted.toApplicationEntity(
      passportUrl: passportUrl,
      signatureUrl: signatureUrl,
      proofOfPaymentUrl: proofOfPaymentUrl,
    );
  }

  @override
  Future<void> saveApplication(ApplicationEntity application) async {
    final submittedEntity =
        SubmittedApplicationEntity.fromApplicationEntity(application);

    await _supabaseClient.from('applications').upsert(submittedEntity.toJson());
  }

  @override
  Future<void> submitApplication(ApplicationEntity application) async {
    final submittedEntity =
        SubmittedApplicationEntity.fromApplicationEntity(application);

    await _supabaseClient.from('applications').upsert(submittedEntity.toJson());
  }

  @override
  Future<String> uploadFile(String path, String name) async {
    final file = File(path);
    final uniqueName = '$uid/$name';

    await _supabaseClient.storage.from('uploads').upload(
          uniqueName,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return uniqueName;
  }
}
