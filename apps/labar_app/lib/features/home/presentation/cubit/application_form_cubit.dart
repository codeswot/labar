import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/utils/app_logger.dart';
import 'package:labar_app/features/home/domain/entities/agent_entity.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';
import 'package:labar_app/features/home/domain/repositories/application_repository.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_state.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/bank_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/contact_info_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/farm_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/kyc_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/biometrics_cubit.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

@lazySingleton
class ApplicationFormCubit extends HydratedCubit<ApplicationFormState> {
  final ApplicationRepository _applicationRepository;

  ApplicationFormCubit(
    this._applicationRepository,
  ) : super(const ApplicationFormState());

  void init(String userId) {
    if (state.userId != userId) {
      emit(state.copyWith(userId: userId));
    }
  }

  void loadApplication(ApplicationEntity application) {
    emit(state.copyWith(
      initialApplication: application,
      status: ApplicationFormStatus.initial,
      currentStep: 0,
    ));
  }

  void resetForm() {
    emit(state.copyWith(
      initialApplication: null,
      status: ApplicationFormStatus.initial,
      currentStep: 0,
      selectedWarehouse: null,
      selectedAgent: null,
    ));
  }

  void selectWarehouse(WarehouseEntity warehouse) {
    emit(state.copyWith(selectedWarehouse: warehouse));
  }

  void selectAgent(AgentEntity agent) {
    emit(state.copyWith(selectedAgent: agent));
  }

  void nextStep() {
    if (state.currentStep < 7) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void jumpToStep(int step) {
    emit(state.copyWith(
      currentStep: step,
    ));
  }

  Future<void> submit({
    required PersonalInfoState personalInfo,
    required ContactInfoState contactInfo,
    required FarmDetailsState farmDetails,
    required BankDetailsState bankDetails,
    required KycDetailsState kycDetails,
    required bool attestationAccepted,
    required BiometricsState biometrics,
  }) async {
    emit(state.copyWith(
      status: ApplicationFormStatus.submitting,
      loadingMessage: 'SIGNATURE_PASSPORT',
      errorMessage: null,
    ));

    try {
      String? passportPath;
      String? idCardPath;
      String? signaturePath;

      if (biometrics.passportPath != null &&
          biometrics.passportPath!.isNotEmpty) {
        final passportFile = File(biometrics.passportPath!);
        if (await passportFile.exists()) {
          passportPath = await _applicationRepository.uploadFile(
            biometrics.passportPath!,
            'passport_${state.userId}.jpg',
          );
        }
      }

      if (biometrics.idCardPath != null && biometrics.idCardPath!.isNotEmpty) {
        final idCardFile = File(biometrics.idCardPath!);
        if (await idCardFile.exists()) {
          idCardPath = await _applicationRepository.uploadFile(
            biometrics.idCardPath!,
            'id_card_${state.userId}.jpg',
          );
        }
      }

      // Upload Signature
      if (biometrics.signatureBytes != null &&
          biometrics.signatureBytes!.isNotEmpty) {
        final tempDir = await getTemporaryDirectory();
        final signatureFile =
            File('${tempDir.path}/signature_${state.userId}.png');
        await signatureFile.writeAsBytes(biometrics.signatureBytes!);

        signaturePath = await _applicationRepository.uploadFile(
          signatureFile.path,
          'signature_${state.userId}.png',
        );
      }

      emit(state.copyWith(loadingMessage: 'SUBMITTING_APPLICATION'));

      final application = ApplicationEntity(
        id: state.initialApplication?.id ?? '',
        userId: state.userId,
        warehouseId: state.selectedWarehouse?.id,
        agentId: state.selectedAgent?.id,
        // Personal
        firstName: personalInfo.firstName.value,
        lastName: personalInfo.lastName.value,
        otherNames: personalInfo.otherNames.value,
        gender: personalInfo.gender.value,
        state: personalInfo.stateOfOrigin.value,
        lga: personalInfo.lga.value,
        town: personalInfo.town.value,
        dateOfBirth: personalInfo.dateOfBirth,
        passportPath: passportPath,
        idCardPath: idCardPath,
        // Contact
        phoneNumber: contactInfo.phoneNumber.value,
        nextOfKinName: contactInfo.nextOfKinName.value,
        nextOfKinPhone: contactInfo.nextOfKinPhone.value,
        nextOfKinRelationship: contactInfo.nextOfKinRelationship.value,
        // Farm
        farmSize: farmDetails.farmSize.value,
        farmLocation: farmDetails.farmLocation.value,
        cropType: farmDetails.cropType.value,
        latitude: farmDetails.latitude,
        longitude: farmDetails.longitude,
        farmPolygon: farmDetails.farmPolygon.isNotEmpty
            ? farmDetails.farmPolygon.cast<Map<String, dynamic>>()
            : null,
        // Bank
        bankName: bankDetails.bankName.value,
        accountNumber: bankDetails.accountNumber.value,
        accountName: bankDetails.accountName.value,
        // KYC
        kycType: kycDetails.kycType,
        kycNumber: kycDetails.kycNumber.value,
        // Signature
        signaturePath: signaturePath, // Use uploaded path
        status: ApplicationStatus.initial,
      );

      await _applicationRepository.submitApplication(application);

      emit(state.copyWith(status: ApplicationFormStatus.success));
    } catch (e) {
      AppLogger.error('Submit error: $e');
      emit(state.copyWith(
        status: ApplicationFormStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  ApplicationFormState? fromJson(Map<String, dynamic> json) {
    try {
      return ApplicationFormState.fromJson(json);
    } catch (e) {
      AppLogger.error('Error hydrating ApplicationFormCubit: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ApplicationFormState state) => state.toJson();
}
