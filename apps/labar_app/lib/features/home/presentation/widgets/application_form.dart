import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_state.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/bank_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/contact_info_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/farm_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/kyc_details_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/biometrics_cubit.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_state.dart';

import 'sections/personal_information_section.dart';
import 'sections/contact_information_section.dart';
import 'sections/kyc_section.dart';
import 'sections/bank_details_section.dart';
import 'sections/farm_details_section.dart';
import 'sections/biometrics_section.dart';
import 'sections/warehouse_selection_section.dart';
import 'sections/agent_selection_section.dart';

import 'package:labar_app/core/di/injection.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<ApplicationFormCubit>(context);
    _pageController = PageController(initialPage: cubit.state.currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = context.read<ApplicationFormCubit>();
            final app = cubit.state.initialApplication;
            return getIt<PersonalInfoCubit>()
              ..init(
                currentUserId: cubit.state.userId,
                firstName: app?.firstName,
                lastName: app?.lastName,
                otherNames: app?.otherNames,
                gender: app?.gender,
                stateOfOrigin: app?.state,
                lga: app?.lga,
                dateOfBirth: app?.dateOfBirth,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = context.read<ApplicationFormCubit>();
            final app = cubit.state.initialApplication;
            return getIt<ContactInfoCubit>()
              ..init(
                currentUserId: cubit.state.userId,
                phoneNumber: app?.phoneNumber,
                nextOfKinName: app?.nextOfKinName,
                nextOfKinPhone: app?.nextOfKinPhone,
                nextOfKinRelationship: app?.nextOfKinRelationship,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = context.read<ApplicationFormCubit>();
            final app = cubit.state.initialApplication;
            return getIt<KycDetailsCubit>()
              ..init(
                currentUserId: cubit.state.userId,
                kycType: app?.kycType,
                kycNumber: app?.kycNumber,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = context.read<ApplicationFormCubit>();
            final app = cubit.state.initialApplication;
            return getIt<FarmDetailsCubit>()
              ..init(
                currentUserId: cubit.state.userId,
                farmSize: app?.farmSize,
                farmLocation: app?.farmLocation,
                cropType: app?.cropType,
                latitude: app?.latitude,
                longitude: app?.longitude,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = context.read<ApplicationFormCubit>();
            final app = cubit.state.initialApplication;
            return getIt<BankDetailsCubit>()
              ..init(
                currentUserId: cubit.state.userId,
                bankName: app?.bankName,
                accountNumber: app?.accountNumber,
                accountName: app?.accountName,
              );
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<BiometricsCubit>()
              ..init(
                  currentUserId:
                      context.read<ApplicationFormCubit>().state.userId);
          },
        ),
      ],
      child: BlocConsumer<ApplicationFormCubit, ApplicationFormState>(
        listenWhen: (previous, current) =>
            previous.currentStep != current.currentStep ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == ApplicationFormStatus.success) {
            // Clear all hydrated cubits involved in the form
            context.read<PersonalInfoCubit>().clear();
            context.read<ContactInfoCubit>().clear();
            context.read<KycDetailsCubit>().clear();
            context.read<FarmDetailsCubit>().clear();
            context.read<BankDetailsCubit>().clear();
            context.read<BiometricsCubit>().reset();
            context.read<ApplicationFormCubit>().clear();

            try {
              context.read<HomeCubit>().setView(HomeView.submitted);
            } catch (_) {
              // HomeCubit not available, we are likely on a standalone route
            }
            context.router.maybePop();
          }

          if (_pageController.hasClients &&
              state.status != ApplicationFormStatus.submitting) {
            _pageController.animateToPage(
              state.currentStep,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (state.currentStep + 1) / 8,
                        color: context.moonColors?.piccolo,
                        backgroundColor: context.moonColors?.beerus,
                        minHeight: 8,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        WarehouseSelectionSection(),
                        PersonalInformationSection(),
                        ContactInformationSection(),
                        KYCSection(),
                        FarmDetailsSection(),
                        BankDetailsSection(),
                        AgentSelectionSection(),
                        BiometricsSection(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(bottom: 32),
                    child: Row(
                      children: [
                        if (state.currentStep > 0)
                          Expanded(
                            child: AppButton.outlined(
                              label: const Text('Previous'),
                              onTap: () {
                                BlocProvider.of<ApplicationFormCubit>(context)
                                    .previousStep();
                              },
                            ),
                          ),
                        if (state.currentStep > 0) const SizedBox(width: 16),
                        Expanded(
                          child: _ValidationButton(
                            currentStep: state.currentStep,
                            onNext: () =>
                                BlocProvider.of<ApplicationFormCubit>(context)
                                    .nextStep(),
                            onSubmit: () =>
                                _showAttestationBottomSheet(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (state.status == ApplicationFormStatus.submitting)
                _LoadingOverlay(message: state.loadingMessage),
            ],
          );
        },
      ),
    );
  }

  void _showAttestationBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AttestationBottomSheet(
        onConfirm: (attestationAccepted) {
          Navigator.pop(context);
          _submitForm(parentContext, attestationAccepted);
        },
      ),
    );
  }

  void _submitForm(BuildContext context, bool attestationAccepted) {
    final personalInfo = BlocProvider.of<PersonalInfoCubit>(context).state;
    final contactInfo = BlocProvider.of<ContactInfoCubit>(context).state;
    final kycDetails = BlocProvider.of<KycDetailsCubit>(context).state;
    final farmDetails = BlocProvider.of<FarmDetailsCubit>(context).state;
    final bankDetails = BlocProvider.of<BankDetailsCubit>(context).state;
    final biometrics = BlocProvider.of<BiometricsCubit>(context).state;

    BlocProvider.of<ApplicationFormCubit>(context).submit(
      personalInfo: personalInfo,
      contactInfo: contactInfo,
      kycDetails: kycDetails,
      farmDetails: farmDetails,
      bankDetails: bankDetails,
      attestationAccepted: true,
      biometrics: biometrics,
    );
  }
}

class _AttestationBottomSheet extends StatefulWidget {
  final ValueChanged<bool> onConfirm;

  const _AttestationBottomSheet({required this.onConfirm});

  @override
  State<_AttestationBottomSheet> createState() =>
      _AttestationBottomSheetState();
}

class _AttestationBottomSheetState extends State<_AttestationBottomSheet> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.moonColors?.gohan,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.attestation,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.moonColors?.goku,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: context.moonColors?.beerus ?? Colors.grey),
                ),
                child: Text(
                  context.l10n.attestationStatement,
                  style: context.moonTypography?.body.text14,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.termsAndConditions,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.moonColors?.goku,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: context.moonColors?.beerus ?? Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    context.l10n.termsAndConditionsContent,
                    style: context.moonTypography?.body.text12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: MoonMenuItem(
                  onTap: () {
                    setState(() {
                      _accepted = !_accepted;
                    });
                  },
                  label: Expanded(
                    child: Text(
                      context.l10n.iAgreeToTermsAndAttestation,
                      style: context.moonTypography?.body.text14,
                    ),
                  ),
                  leading: Checkbox(
                    value: _accepted,
                    onChanged: (val) {
                      setState(() {
                        _accepted = val ?? false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton.filled(
                  label: Text(context.l10n.confirmSubmit),
                  onTap: _accepted ? () => widget.onConfirm(_accepted) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValidationButton extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const _ValidationButton({
    required this.currentStep,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        bool isValid = false;
        switch (currentStep) {
          case 0:
            isValid = context.select(
                (ApplicationFormCubit c) => c.state.selectedWarehouse != null);
            break;
          case 1:
            isValid = context.select((PersonalInfoCubit c) => c.state.isValid);
            break;
          case 2:
            isValid = context.select((ContactInfoCubit c) => c.state.isValid);
            break;
          case 3:
            isValid = context.select((KycDetailsCubit c) => c.state.isValid);
            break;
          case 4:
            isValid = context.select((FarmDetailsCubit c) => c.state.isValid);
            break;
          case 5:
            isValid = context.select((BankDetailsCubit c) => c.state.isValid);
            break;
          case 6:
            isValid = context.select(
                (ApplicationFormCubit c) => c.state.selectedAgent != null);
            break;
          case 7:
            isValid = context.select((BiometricsCubit c) => c.state.isValid);
            break;
        }

        return AppButton.filled(
          label:
              Text(currentStep == 7 ? context.l10n.submit : context.l10n.next),
          onTap: isValid ? (currentStep == 7 ? onSubmit : onNext) : null,
        );
      },
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final String? message;

  const _LoadingOverlay({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.moonColors?.goten.withValues(alpha: 0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MoonCircularLoader(color: context.moonColors?.piccolo),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message == 'SIGNATURE_PASSPORT'
                    ? context.l10n.signingPassport
                    : message == 'SUBMITTING_APPLICATION'
                        ? context.l10n.submittingApplication
                        : message ?? context.l10n.loading,
                style: TextStyle(
                  color: context.moonColors?.piccolo,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
