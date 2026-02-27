import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/agent_cubit.dart';
import 'package:ui_library/ui_library.dart';

class AgentDashboardView extends StatelessWidget {
  const AgentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AgentCubit>()..watchApplications(),
      child: const _AgentApplicationsList(),
    );
  }
}

class _AgentApplicationsList extends StatelessWidget {
  const _AgentApplicationsList();

  // ── Create ─────────────────────────────────────────────────────────────────
  void _showCreateApplicationDialog(BuildContext context) {
    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final otherNamesController = TextEditingController();
    final dobController = TextEditingController();
    final phoneController = TextEditingController();
    final farmLocationController = TextEditingController();
    final farmSizeController = TextEditingController();
    final cropTypeController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();
    final bankNameController = TextEditingController();
    final accountNumberController = TextEditingController();
    final accountNameController = TextEditingController();
    final nextOfKinNameController = TextEditingController();
    final nextOfKinPhoneController = TextEditingController();
    final nextOfKinRelationshipController = TextEditingController();
    final kycNumberController = TextEditingController();

    String? gender;
    String? kycType;
    String? passportBase64;
    String? signatureBase64;
    final picker = ImagePicker();

    _showApplicationFormDialog(
      context,
      title: 'Create Farmer Application',
      emailController: emailController,
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      otherNamesController: otherNamesController,
      dobController: dobController,
      phoneController: phoneController,
      farmLocationController: farmLocationController,
      farmSizeController: farmSizeController,
      cropTypeController: cropTypeController,
      latitudeController: latitudeController,
      longitudeController: longitudeController,
      bankNameController: bankNameController,
      accountNumberController: accountNumberController,
      accountNameController: accountNameController,
      nextOfKinNameController: nextOfKinNameController,
      nextOfKinPhoneController: nextOfKinPhoneController,
      nextOfKinRelationshipController: nextOfKinRelationshipController,
      kycNumberController: kycNumberController,
      gender: gender,
      kycType: kycType,
      passportBase64: passportBase64,
      signatureBase64: signatureBase64,
      showEmail: true,
      showDocuments: true,
      picker: picker,
      onSave: (ctx, updatedGender, updatedKycType, passport, signature) {
        ctx.read<AgentCubit>().createApplication(
              email: emailController.text.trim(),
              metadata: {
                'first_name': firstNameController.text.trim(),
                'last_name': lastNameController.text.trim(),
              },
              applicationData: _buildAppData(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                otherNamesController: otherNamesController,
                dobController: dobController,
                phoneController: phoneController,
                farmLocationController: farmLocationController,
                farmSizeController: farmSizeController,
                cropTypeController: cropTypeController,
                latitudeController: latitudeController,
                longitudeController: longitudeController,
                bankNameController: bankNameController,
                accountNumberController: accountNumberController,
                accountNameController: accountNameController,
                nextOfKinNameController: nextOfKinNameController,
                nextOfKinPhoneController: nextOfKinPhoneController,
                nextOfKinRelationshipController:
                    nextOfKinRelationshipController,
                kycNumberController: kycNumberController,
                gender: updatedGender,
                kycType: updatedKycType,
              ),
              passportBase64: passport,
              signatureBase64: signature,
            );
      },
      saveLabel: 'Create',
    );
  }

  // ── Edit ────────────────────────────────────────────────────────────────────
  void _showEditApplicationDialog(
      BuildContext context, Map<String, dynamic> app) {
    final firstNameController =
        TextEditingController(text: app['first_name'] ?? '');
    final lastNameController =
        TextEditingController(text: app['last_name'] ?? '');
    final otherNamesController =
        TextEditingController(text: app['other_names'] ?? '');
    final dobController =
        TextEditingController(text: app['date_of_birth'] ?? '');
    final phoneController =
        TextEditingController(text: app['phone_number'] ?? '');
    final farmLocationController =
        TextEditingController(text: app['farm_location'] ?? '');
    final farmSizeController =
        TextEditingController(text: app['farm_size']?.toString() ?? '');
    final cropTypeController =
        TextEditingController(text: app['crop_type'] ?? '');
    final latitudeController =
        TextEditingController(text: app['latitude']?.toString() ?? '');
    final longitudeController =
        TextEditingController(text: app['longitude']?.toString() ?? '');
    final bankNameController =
        TextEditingController(text: app['bank_name'] ?? '');
    final accountNumberController =
        TextEditingController(text: app['account_number'] ?? '');
    final accountNameController =
        TextEditingController(text: app['account_name'] ?? '');
    final nextOfKinNameController =
        TextEditingController(text: app['next_of_kin_name'] ?? '');
    final nextOfKinPhoneController =
        TextEditingController(text: app['next_of_kin_phone'] ?? '');
    final nextOfKinRelationshipController =
        TextEditingController(text: app['next_of_kin_relationship'] ?? '');
    final kycNumberController =
        TextEditingController(text: app['kyc_number'] ?? '');

    _showApplicationFormDialog(
      context,
      title: 'Edit — ${app['first_name']} ${app['last_name']}',
      emailController: TextEditingController(),
      firstNameController: firstNameController,
      lastNameController: lastNameController,
      otherNamesController: otherNamesController,
      dobController: dobController,
      phoneController: phoneController,
      farmLocationController: farmLocationController,
      farmSizeController: farmSizeController,
      cropTypeController: cropTypeController,
      latitudeController: latitudeController,
      longitudeController: longitudeController,
      bankNameController: bankNameController,
      accountNumberController: accountNumberController,
      accountNameController: accountNameController,
      nextOfKinNameController: nextOfKinNameController,
      nextOfKinPhoneController: nextOfKinPhoneController,
      nextOfKinRelationshipController: nextOfKinRelationshipController,
      kycNumberController: kycNumberController,
      gender: app['gender'],
      kycType: app['kyc_type'],
      passportBase64: null,
      signatureBase64: null,
      showEmail: false,
      showDocuments: false,
      picker: ImagePicker(),
      onSave: (ctx, updatedGender, updatedKycType, _, __) {
        ctx.read<AgentCubit>().updateApplication(
              app['id'],
              _buildAppData(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                otherNamesController: otherNamesController,
                dobController: dobController,
                phoneController: phoneController,
                farmLocationController: farmLocationController,
                farmSizeController: farmSizeController,
                cropTypeController: cropTypeController,
                latitudeController: latitudeController,
                longitudeController: longitudeController,
                bankNameController: bankNameController,
                accountNumberController: accountNumberController,
                accountNameController: accountNameController,
                nextOfKinNameController: nextOfKinNameController,
                nextOfKinPhoneController: nextOfKinPhoneController,
                nextOfKinRelationshipController:
                    nextOfKinRelationshipController,
                kycNumberController: kycNumberController,
                gender: updatedGender,
                kycType: updatedKycType,
              ),
            );
      },
      saveLabel: 'Save Changes',
    );
  }

  // ── Shared form builder ─────────────────────────────────────────────────────
  void _showApplicationFormDialog(
    BuildContext context, {
    required String title,
    required TextEditingController emailController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController otherNamesController,
    required TextEditingController dobController,
    required TextEditingController phoneController,
    required TextEditingController farmLocationController,
    required TextEditingController farmSizeController,
    required TextEditingController cropTypeController,
    required TextEditingController latitudeController,
    required TextEditingController longitudeController,
    required TextEditingController bankNameController,
    required TextEditingController accountNumberController,
    required TextEditingController accountNameController,
    required TextEditingController nextOfKinNameController,
    required TextEditingController nextOfKinPhoneController,
    required TextEditingController nextOfKinRelationshipController,
    required TextEditingController kycNumberController,
    required String? gender,
    required String? kycType,
    required String? passportBase64,
    required String? signatureBase64,
    required bool showEmail,
    required bool showDocuments,
    required ImagePicker picker,
    required void Function(BuildContext ctx, String? gender, String? kycType,
            String? passport, String? signature)
        onSave,
    required String saveLabel,
  }) {
    String? currentGender = gender;
    String? currentKycType = kycType;
    String? currentPassport = passportBase64;
    String? currentSignature = signatureBase64;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            Future<void> pickImage(bool isPassport) async {
              final picked =
                  await picker.pickImage(source: ImageSource.gallery);
              if (picked == null) return;
              final bytes = await File(picked.path).readAsBytes();
              final b64 =
                  'data:image/jpeg;base64,${base64Encode(Uint8List.fromList(bytes))}';
              setState(() {
                if (isPassport) {
                  currentPassport = b64;
                } else {
                  currentSignature = b64;
                }
              });
            }

            Widget sectionTitle(String t) => Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(t,
                      style: ctx.moonTypography?.heading.text14.copyWith(
                        color: ctx.moonColors?.piccolo,
                        fontWeight: FontWeight.bold,
                      )),
                );

            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showEmail) ...[
                        sectionTitle('Account'),
                        MoonFormTextInput(
                          controller: emailController,
                          hintText: 'Email Address *',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                      sectionTitle('Personal Information'),
                      Row(children: [
                        Expanded(
                            child: MoonFormTextInput(
                                controller: firstNameController,
                                hintText: 'First Name *')),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: lastNameController,
                                hintText: 'Last Name *')),
                      ]),
                      const SizedBox(height: 8),
                      MoonFormTextInput(
                          controller: otherNamesController,
                          hintText: 'Other Names'),
                      const SizedBox(height: 8),
                      MoonFormTextInput(
                          controller: dobController,
                          hintText: 'Date of Birth (YYYY-MM-DD)'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: currentGender,
                        hint: const Text('Gender'),
                        items: ['Male', 'Female', 'Other']
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => setState(() => currentGender = v),
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 8),
                      MoonFormTextInput(
                          controller: phoneController,
                          hintText: 'Phone Number *',
                          keyboardType: TextInputType.phone),
                      sectionTitle('Farm Details'),
                      MoonFormTextInput(
                          controller: farmLocationController,
                          hintText: 'Farm Location / Description'),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: MoonFormTextInput(
                                controller: farmSizeController,
                                hintText: 'Farm Size (ha)',
                                keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: cropTypeController,
                                hintText: 'Crop Type')),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: MoonFormTextInput(
                                controller: latitudeController,
                                hintText: 'Latitude',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: longitudeController,
                                hintText: 'Longitude',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true))),
                      ]),
                      sectionTitle('Bank Details'),
                      MoonFormTextInput(
                          controller: bankNameController,
                          hintText: 'Bank Name'),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: MoonFormTextInput(
                                controller: accountNumberController,
                                hintText: 'Account Number',
                                keyboardType: TextInputType.number)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: accountNameController,
                                hintText: 'Account Name')),
                      ]),
                      sectionTitle('Next of Kin'),
                      MoonFormTextInput(
                          controller: nextOfKinNameController,
                          hintText: 'Next of Kin Name'),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: MoonFormTextInput(
                                controller: nextOfKinPhoneController,
                                hintText: 'Next of Kin Phone',
                                keyboardType: TextInputType.phone)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: nextOfKinRelationshipController,
                                hintText: 'Relationship')),
                      ]),
                      sectionTitle('KYC'),
                      Row(children: [
                        Expanded(
                            child: DropdownButtonFormField<String>(
                          value: currentKycType,
                          hint: const Text('KYC Type'),
                          items: ['nin', 'bvn', 'passport', 'drivers_license']
                              .map((t) => DropdownMenuItem(
                                  value: t, child: Text(t.toUpperCase())))
                              .toList(),
                          onChanged: (v) => setState(() => currentKycType = v),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                            child: MoonFormTextInput(
                                controller: kycNumberController,
                                hintText: 'KYC Number / ID')),
                      ]),
                      if (showDocuments) ...[
                        sectionTitle('Documents'),
                        Row(children: [
                          Expanded(
                              child: Column(children: [
                            const Text('Passport Photo'),
                            const SizedBox(height: 8),
                            if (currentPassport != null)
                              Image.memory(
                                  base64Decode(
                                      currentPassport!.split(',').last),
                                  height: 80,
                                  fit: BoxFit.cover),
                            AppButton.plain(
                                onTap: () => pickImage(true),
                                label: const Text('Pick Passport')),
                          ])),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(children: [
                            const Text('Signature'),
                            const SizedBox(height: 8),
                            if (currentSignature != null)
                              Image.memory(
                                  base64Decode(
                                      currentSignature!.split(',').last),
                                  height: 80,
                                  fit: BoxFit.cover),
                            AppButton.plain(
                                onTap: () => pickImage(false),
                                label: const Text('Pick Signature')),
                          ])),
                        ]),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel')),
                AppButton.filled(
                  isFullWidth: false,
                  onTap: () {
                    onSave(ctx, currentGender, currentKycType, currentPassport,
                        currentSignature);
                    Navigator.pop(dialogContext);
                  },
                  label: Text(saveLabel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  Map<String, dynamic> _buildAppData({
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController otherNamesController,
    required TextEditingController dobController,
    required TextEditingController phoneController,
    required TextEditingController farmLocationController,
    required TextEditingController farmSizeController,
    required TextEditingController cropTypeController,
    required TextEditingController latitudeController,
    required TextEditingController longitudeController,
    required TextEditingController bankNameController,
    required TextEditingController accountNumberController,
    required TextEditingController accountNameController,
    required TextEditingController nextOfKinNameController,
    required TextEditingController nextOfKinPhoneController,
    required TextEditingController nextOfKinRelationshipController,
    required TextEditingController kycNumberController,
    required String? gender,
    required String? kycType,
  }) {
    return {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'other_names': otherNamesController.text.trim(),
      'date_of_birth': dobController.text.trim(),
      'gender': gender,
      'phone_number': phoneController.text.trim(),
      'farm_location': farmLocationController.text.trim(),
      'farm_size': farmSizeController.text.trim(),
      'crop_type': cropTypeController.text.trim(),
      'latitude': double.tryParse(latitudeController.text),
      'longitude': double.tryParse(longitudeController.text),
      'bank_name': bankNameController.text.trim(),
      'account_number': accountNumberController.text.trim(),
      'account_name': accountNameController.text.trim(),
      'next_of_kin_name': nextOfKinNameController.text.trim(),
      'next_of_kin_phone': nextOfKinPhoneController.text.trim(),
      'next_of_kin_relationship': nextOfKinRelationshipController.text.trim(),
      'kyc_type': kycType,
      'kyc_number': kycNumberController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Created Applications',
                  style: context.moonTypography?.heading.text24),
              Row(
                children: [
                  const Text('Filtered to only your entries',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 16),
                  AppButton.filled(
                    isFullWidth: false,
                    onTap: () => _showCreateApplicationDialog(context),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('Create Application'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AgentCubit, AgentState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: MoonCircularLoader());
                }
                if (state.error != null) {
                  return AppErrorView(
                    onRetry: () =>
                        context.read<AgentCubit>().watchApplications(),
                  );
                }

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.moonColors?.gohan,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(context.moonColors?.goku),
                      columns: const [
                        DataColumn(label: Text('Reg No')),
                        DataColumn(label: Text('Farmer Name')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Edit')),
                      ],
                      rows: state.applications.map((app) {
                        return DataRow(cells: [
                          DataCell(Text(app['reg_no'] ?? '-')),
                          DataCell(
                              Text('${app['first_name']} ${app['last_name']}')),
                          DataCell(MoonTag(
                            label: Text(
                                app['status']?.toString().toUpperCase() ??
                                    'NONE'),
                            tagSize: MoonTagSize.xs,
                          )),
                          DataCell(Text(app['phone_number'] ?? '-')),
                          DataCell(
                            IconButton(
                              tooltip: 'Edit application',
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              onPressed: () =>
                                  _showEditApplicationDialog(context, app),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
