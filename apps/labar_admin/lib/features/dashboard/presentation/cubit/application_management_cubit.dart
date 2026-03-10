import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import '../../data/repositories/admin_repository_impl.dart';

part 'application_management_cubit.freezed.dart';

@freezed
class ApplicationManagementState with _$ApplicationManagementState {
  const factory ApplicationManagementState({
    @Default([]) List<Map<String, dynamic>> applications,
    @Default([]) List<Map<String, dynamic>> warehouses,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    Map<String, dynamic>? selectedDesignation,
    @Default([]) List<Map<String, dynamic>> selectedResources,
    @Default([]) List<String> availableStates,
    @Default([]) List<String> availableLgas,
    @Default(true) bool hasMore,
    @Default(0) int page,
  }) = _ApplicationManagementState;
}

@injectable
class ApplicationManagementCubit extends Cubit<ApplicationManagementState> {
  final AdminRepository _adminRepository;
  final SupabaseClient _supabaseClient;
  final SessionCubit _sessionCubit;
  StreamSubscription? _applicationsSubscription;
  StreamSubscription? _warehousesSubscription;

  ApplicationManagementCubit(
    this._adminRepository,
    this._supabaseClient,
    this._sessionCubit,
  ) : super(const ApplicationManagementState());

  Future<void> fetchApplications({bool refresh = false}) async {
    if (state.isLoading || (state.isLoadingMore && !refresh)) return;

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(state.copyWith(
        error: 'Session expired. Please log in again.',
        isLoading: false,
      ));
      return;
    }

    if (refresh) {
      emit(state.copyWith(isLoading: true, page: 0, applications: [], hasMore: true));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    try {
      if (refresh) await loadStates();
      
      const int pageSize = 50;
      final int offset = state.page * pageSize;

      final List<dynamic> data = await _supabaseClient
          .from('applications')
          .select('*, creator:profiles!created_by(first_name, last_name, user_roles(role))')
          .order('created_at', ascending: false)
          .range(offset, offset + pageSize - 1);

      final applications = List<Map<String, dynamic>>.from(data);
      
      emit(state.copyWith(
        applications: refresh ? applications : [...state.applications, ...applications],
        isLoading: false,
        isLoadingMore: false,
        page: state.page + 1,
        hasMore: applications.length == pageSize,
      ));

      // Warehouses can still be a stream or fetched once
      if (refresh && _warehousesSubscription == null) {
        final user = _sessionCubit.state.user;
        final isManager = user?.role == 'warehouse_manager';
        final managerWarehouseId = isManager ? user?.warehouseId : null;

        _warehousesSubscription = _adminRepository
            .warehousesStream(warehouseId: managerWarehouseId)
            .listen((data) {
          emit(state.copyWith(warehouses: data));
        });
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, isLoadingMore: false, error: e.toString()));
    }
  }

  void watchApplications() => fetchApplications(refresh: true);

  Future<void> fetchApplicationDetails(String applicationId) async {
    emit(state.copyWith(
      selectedDesignation: null,
      selectedResources: [],
    ));

    try {
      final appIndex = state.applications.indexWhere((a) => a['id'] == applicationId);
      if (appIndex != -1) {
        final app = Map<String, dynamic>.from(state.applications[appIndex]);
        
        // Lazy sign URLs only for this app
        final paths = {
          'passport_path': 'passport_url',
          'signature_path': 'signature_url',
          'proof_of_payment_path': 'proof_of_payment_url',
          'id_card_path': 'id_card_url',
        };

        for (var entry in paths.entries) {
          if (app[entry.key] != null) {
            try {
              app[entry.value] = await _supabaseClient.storage
                  .from('uploads')
                  .createSignedUrl(app[entry.key], 3600);
            } catch (_) {}
          }
        }

        final updatedApps = List<Map<String, dynamic>>.from(state.applications);
        updatedApps[appIndex] = app;
        emit(state.copyWith(applications: updatedApps));
      }

      final designation =
          await _adminRepository.getFarmerDesignation(applicationId);
      final resources =
          await _adminRepository.getAllocatedResources(applicationId);

      emit(state.copyWith(
        selectedDesignation: designation,
        selectedResources: resources,
      ));
    } catch (e) {
      debugPrint('Error fetching details: $e');
    }
  }

  Future<void> assignWarehouse({
    required String applicationId,
    required String warehouseId,
    String? note,
  }) async {
    try {
      await _adminRepository.assignWarehouse(
        applicationId: applicationId,
        warehouseId: warehouseId,
        note: note,
      );
      // Refresh details to show the new assignment
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await _adminRepository.updateApplicationStatus(id, status);
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
    try {
      await _adminRepository.createApplication(
        email: email,
        metadata: metadata,
        applicationData: applicationData,
        passportBase64: passportBase64,
        signatureBase64: signatureBase64,
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteApplication(String id) async {
    try {
      await _adminRepository.deleteApplication(id);
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
    try {
      await _adminRepository.allocateResource(
        applicationId: applicationId,
        item: item,
        quantity: quantity,
        collectionAddress: collectionAddress,
      );
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
    try {
      await _adminRepository.removeAllocatedResource(resourceId);
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
    try {
      await _adminRepository.markAllocatedResourceAsCollected(resourceId);
      await fetchApplicationDetails(applicationId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> unassignWarehouse(String applicationId) async {
    try {
      await _adminRepository.unassignWarehouse(applicationId);
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
      debugPrint('Error loading states: $e');
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
    _warehousesSubscription?.cancel();
    return super.close();
  }
}
