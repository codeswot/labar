import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../data/repositories/warehouse_repository.dart';

part 'application_management_cubit.freezed.dart';

@freezed
class ApplicationManagementState with _$ApplicationManagementState {
  const factory ApplicationManagementState({
    @Default([]) List<Map<String, dynamic>> applications,
    @Default([]) List<Map<String, dynamic>> warehouses,
    @Default(false) bool isLoading,
    String? error,
    Map<String, dynamic>? selectedDesignation,
    @Default([]) List<Map<String, dynamic>> selectedResources,
    @Default([]) List<String> availableStates,
    @Default([]) List<String> availableLgas,
  }) = _ApplicationManagementState;
}

@injectable
class ApplicationManagementCubit extends Cubit<ApplicationManagementState> {
  final AdminRepository _adminRepository;
  final WarehouseRepository _warehouseRepository;
  final SupabaseClient _supabaseClient;
  StreamSubscription? _applicationsSubscription;

  ApplicationManagementCubit(
    this._adminRepository,
    this._warehouseRepository,
    this._supabaseClient,
  ) : super(const ApplicationManagementState());

  void watchApplications() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(state.copyWith(
        error: 'Session expired or invalid. Please log in again.',
        isLoading: false,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      await loadStates();
      final warehouses = await _warehouseRepository.getWarehouses();
      emit(state.copyWith(warehouses: warehouses));

      _applicationsSubscription?.cancel();
      _applicationsSubscription = _supabaseClient
          .from('applications')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .listen((data) async {
            final applications = List<Map<String, dynamic>>.from(data);

            await Future.wait(applications.map((app) async {
              if (app['passport_path'] != null) {
                try {
                  final url = await _supabaseClient.storage
                      .from('uploads')
                      .createSignedUrl(app['passport_path'], 3600);
                  app['passport_url'] = url;
                } catch (_) {}
              }
              if (app['signature_path'] != null) {
                try {
                  final url = await _supabaseClient.storage
                      .from('uploads')
                      .createSignedUrl(app['signature_path'], 3600);
                  app['signature_url'] = url;
                } catch (_) {}
              }
              if (app['proof_of_payment_path'] != null) {
                try {
                  final url = await _supabaseClient.storage
                      .from('uploads')
                      .createSignedUrl(app['proof_of_payment_path'], 3600);
                  app['proof_of_payment_url'] = url;
                } catch (_) {}
              }
              if (app['id_card_path'] != null) {
                try {
                  final url = await _supabaseClient.storage
                      .from('uploads')
                      .createSignedUrl(app['id_card_path'], 3600);
                  app['id_card_url'] = url;
                } catch (_) {}
              }
            }));

            emit(state.copyWith(
              applications: applications,
              isLoading: false,
            ));
          }, onError: (e) {
            emit(state.copyWith(isLoading: false, error: e.toString()));
          });
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchApplicationDetails(String applicationId) async {
    emit(state.copyWith(
      selectedDesignation: null,
      selectedResources: [],
    ));

    try {
      final designation =
          await _adminRepository.getFarmerDesignation(applicationId);
      final resources =
          await _adminRepository.getAllocatedResources(applicationId);

      emit(state.copyWith(
        selectedDesignation: designation,
        selectedResources: resources,
      ));
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  Future<void> assignWarehouse({
    required String applicationId,
    required String warehouseId,
    String? note,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.assignWarehouse(
        applicationId: applicationId,
        warehouseId: warehouseId,
        note: note,
      );
      emit(state.copyWith(isLoading: false));
      // Refresh details to show the new assignment
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateStatus(String id, String status) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.updateApplicationStatus(id, status);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> createApplication({
    required String email,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> applicationData,
    String? passportBase64,
    String? signatureBase64,
  }) async {
    if (_supabaseClient.auth.currentUser == null) {
      emit(state.copyWith(
        error: 'Session expired. Please log in again.',
        isLoading: false,
      ));
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.createApplication(
        email: email,
        metadata: metadata,
        applicationData: applicationData,
        passportBase64: passportBase64,
        signatureBase64: signatureBase64,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteApplication(String id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.deleteApplication(id);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> allocateResource({
    required String applicationId,
    required String item,
    required num quantity,
    required String collectionAddress,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.allocateResource(
        applicationId: applicationId,
        item: item,
        quantity: quantity,
        collectionAddress: collectionAddress,
      );
      emit(state.copyWith(isLoading: false));
      // Refresh details to show the new allocation
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> removeAllocatedResource({
    required String resourceId,
    required String applicationId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.removeAllocatedResource(resourceId);
      emit(state.copyWith(isLoading: false));
      // Refresh details to reflect the removal
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> markAllocatedResourceAsCollected({
    required String resourceId,
    required String applicationId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.markAllocatedResourceAsCollected(resourceId);
      emit(state.copyWith(isLoading: false));
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> unassignWarehouse(String applicationId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _adminRepository.unassignWarehouse(applicationId);
      emit(state.copyWith(isLoading: false));
      // Refresh details to reflect the removal
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadStates() async {
    if (state.availableStates.isNotEmpty) return;
    try {
      final String response =
          await rootBundle.loadString('assets/locations/states.json');
      final List<dynamic> data = json.decode(response);
      emit(state.copyWith(availableStates: List<String>.from(data)));
    } catch (e) {
      print('Error loading states: $e');
    }
  }

  Future<void> loadLgas(String stateName) async {
    try {
      final String filename =
          stateName.toLowerCase().replaceAll(' ', '_').replaceAll('/', '_');
      final String response =
          await rootBundle.loadString('assets/locations/$filename.json');
      final List<dynamic> data = json.decode(response);
      emit(state.copyWith(
        availableLgas: List<String>.from(data),
      ));
    } catch (e) {
      print('Error loading LGAs for $stateName: $e');
      emit(state.copyWith(availableLgas: []));
    }
  }

  @override
  Future<void> close() {
    _applicationsSubscription?.cancel();
    return super.close();
  }
}
