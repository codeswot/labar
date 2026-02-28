import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labar_admin/core/utils/currency_utils.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/application_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/detail_info.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/farm_map_view.dart';
import 'package:ui_library/ui_library.dart';

class ApplicationManagementView extends StatefulWidget {
  const ApplicationManagementView({super.key});

  @override
  State<ApplicationManagementView> createState() =>
      ApplicationManagementViewState();
}

class ApplicationManagementViewState extends State<ApplicationManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _statusFilter;
  String? _stateFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              Text('Application Management',
                  style: context.moonTypography?.heading.text24),
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: MoonTextInput(
                      controller: _searchController,
                      hintText: 'Search applications...',
                      leading: const Icon(Icons.search),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      trailing: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _statusFilter,
                        hint: const Text('Status'),
                        isExpanded: true,
                        onChanged: (v) => setState(() => _statusFilter = v),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('All Status')),
                          ...[
                            'initial',
                            'in_review',
                            'approved',
                            'rejected',
                            'allocated',
                            'collected'
                          ].map((s) => DropdownMenuItem(
                              value: s, child: Text(s.toUpperCase()))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<ApplicationManagementCubit,
                      ApplicationManagementState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: 150,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _stateFilter,
                            hint: const Text('State'),
                            isExpanded: true,
                            onChanged: (v) => setState(() => _stateFilter = v),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('All States')),
                              ...state.availableStates.map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  AppButton.filled(
                    isFullWidth: false,
                    onTap: () => _showCreateApplicationDialog(context),
                    label: const Text('Create Application'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocListener<ApplicationManagementCubit,
                ApplicationManagementState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<ApplicationManagementCubit,
                  ApplicationManagementState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: MoonCircularLoader());
                  }

                  if (state.error != null) {
                    return AppErrorView(
                      onRetry: () => context
                          .read<ApplicationManagementCubit>()
                          .watchApplications(),
                    );
                  }

                  final applications = state.applications.where((app) {
                    // Filter by Status
                    if (_statusFilter != null &&
                        (app['status'] ?? '').toString().toLowerCase() !=
                            _statusFilter!.toLowerCase()) {
                      return false;
                    }

                    // Filter by State
                    if (_stateFilter != null &&
                        (app['state'] ?? '').toString() != _stateFilter) {
                      return false;
                    }

                    if (_searchQuery.isEmpty) return true;

                    final regNo =
                        (app['reg_no'] ?? '').toString().toLowerCase();
                    final firstName =
                        (app['first_name'] ?? '').toString().toLowerCase();
                    final lastName =
                        (app['last_name'] ?? '').toString().toLowerCase();
                    final otherNames =
                        (app['other_names'] ?? '').toString().toLowerCase();
                    final status =
                        (app['status'] ?? '').toString().toLowerCase();
                    final stateName =
                        (app['state'] ?? '').toString().toLowerCase();
                    final phoneNumber =
                        (app['phone_number'] ?? '').toString().toLowerCase();

                    return regNo.contains(_searchQuery) ||
                        firstName.contains(_searchQuery) ||
                        lastName.contains(_searchQuery) ||
                        otherNames.contains(_searchQuery) ||
                        status.contains(_searchQuery) ||
                        stateName.contains(_searchQuery) ||
                        phoneNumber.contains(_searchQuery);
                  }).toList();

                  if (applications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 48, color: context.moonColors?.trunks),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No applications yet'
                                : 'No applications found matching "$_searchQuery"',
                            style: context.moonTypography?.body.text16,
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: context.moonColors?.gohan,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: WidgetStateProperty.all(
                                context.moonColors?.goku),
                            columns: const [
                              DataColumn(label: Text('Reg No')),
                              DataColumn(label: Text('Farmer Name')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('State')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: applications.map((app) {
                              final status =
                                  app['status']?.toString().toLowerCase() ??
                                      'initial';
                              final name = app['first_name'] != null
                                  ? '${app['first_name']} ${app['last_name']}'
                                  : 'Unknown';
                              return DataRow(
                                  onSelectChanged: (_) =>
                                      _showApplicationDetailDialog(
                                          context, app),
                                  cells: [
                                    DataCell(Text(app['reg_no'] ?? '-')),
                                    DataCell(Text(name)),
                                    DataCell(GestureDetector(
                                      onTap: () => _showStatusPicker(
                                          context, app['id'], status),
                                      child: MoonTag(
                                        label: Text(status.toUpperCase()),
                                        tagSize: MoonTagSize.xs,
                                        backgroundColor: _getStatusColor(status)
                                            .withOpacity(0.2),
                                      ),
                                    )),
                                    DataCell(
                                        Text(app['state']?.toString() ?? '-')),
                                    DataCell(Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.warehouse_rounded,
                                              size: 18),
                                          tooltip: 'Assign Warehouse',
                                          onPressed: () => _showWarehousePicker(
                                              context,
                                              app['id'],
                                              state.warehouses),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red, size: 18),
                                          tooltip: 'Delete Application',
                                          onPressed: () =>
                                              _confirmDeleteApplication(
                                                  context, app),
                                        ),
                                      ],
                                    )),
                                  ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetailDialog(BuildContext context, dynamic app) {
    final status = app['status']?.toString().toLowerCase() ?? 'initial';
    context
        .read<ApplicationManagementCubit>()
        .fetchApplicationDetails(app['id']);

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<ApplicationManagementCubit>(),
          ),
          BlocProvider.value(
            value: context.read<InventoryManagementCubit>(),
          ),
        ],
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Application Detail: ${app['reg_no'] ?? '-'}'),
              MoonTag(
                label: Text(status.toUpperCase()),
                tagSize: MoonTagSize.xs,
                backgroundColor: _getStatusColor(status).withValues(alpha: 0.2),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (app['passport_url'] != null)
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(app['passport_url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: context.moonColors?.goku,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.person, size: 48),
                        ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailInfo(
                                label: 'Full Name',
                                value:
                                    '${app['first_name'] ?? ''} ${app['last_name'] ?? ''}'),
                            DetailInfo(
                                label: 'Email', value: app['email'] ?? '-'),
                            DetailInfo(
                                label: 'Phone', value: app['phone'] ?? '-'),
                            DetailInfo(
                                label: 'State', value: app['state'] ?? '-'),
                            DetailInfo(label: 'LGA', value: app['lga'] ?? '-'),
                            DetailInfo(
                                label: 'Town/Village',
                                value: app['town'] ?? '-'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (app['id_card_url'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Card',
                            style: context.moonTypography?.heading.text14),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(app['id_card_url']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Text('Farm Location',
                      style: context.moonTypography?.heading.text16),
                  const SizedBox(height: 12),
                  FarmMapView(app: app),
                  const SizedBox(height: 24),
                  Text('Additional Information',
                      style: context.moonTypography?.heading.text16),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 24,
                    runSpacing: 0,
                    children: (app as Map<String, dynamic>)
                        .entries
                        .where((e) =>
                            e.value != null &&
                            !{
                              'id',
                              'user_id',
                              'created_at',
                              'updated_at',
                              'passport_url',
                              'signature_url',
                              'passport_path',
                              'signature_path',
                              'proof_of_payment_path',
                              'proof_of_payment_url',
                              'first_name',
                              'last_name',
                              'email',
                              'phone',
                              'state',
                              'lga',
                              'status',
                              'reg_no',
                              'id_card_path',
                              'id_card_url'
                            }.contains(e.key))
                        .map((e) => SizedBox(
                              width: 200,
                              child: DetailInfo(
                                label: e.key.replaceAll('_', ' ').toUpperCase(),
                                value: e.value.toString(),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Signature',
                      style: context.moonTypography?.heading.text16),
                  const SizedBox(height: 12),
                  if (app['signature_url'] != null)
                    Image.network(
                      app['signature_url'],
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  else
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.moonColors?.goku,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Center(child: Text('No signature available')),
                    ),
                  const SizedBox(height: 24),
                  Text('Proof of Payment',
                      style: context.moonTypography?.heading.text16),
                  const SizedBox(height: 12),
                  if (app['proof_of_payment_url'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        app['proof_of_payment_url'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.moonColors?.goku,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                          child: Text('No proof of payment available')),
                    ),
                  const SizedBox(height: 24),
                  BlocBuilder<ApplicationManagementCubit,
                      ApplicationManagementState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Warehouse Designation',
                                  style:
                                      context.moonTypography?.heading.text16),
                              Row(
                                children: [
                                  AppButton.plain(
                                    isFullWidth: false,
                                    onTap: () => _showWarehousePicker(
                                        context, app['id'], state.warehouses),
                                    label: Text(
                                        state.selectedDesignation == null
                                            ? 'Assign'
                                            : 'Change'),
                                  ),
                                  if (state.selectedDesignation != null) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.link_off_rounded,
                                          size: 20, color: Colors.red),
                                      onPressed: () {
                                        context
                                            .read<ApplicationManagementCubit>()
                                            .unassignWarehouse(app['id']);
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (state.selectedDesignation != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.moonColors?.goku,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.selectedDesignation!['warehouses']
                                            ?['name'] ??
                                        'Unknown Warehouse',
                                    style: context.moonTypography?.body.text14
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (state.selectedDesignation!['warehouses']
                                          ?['address'] !=
                                      null)
                                    Text(
                                      state.selectedDesignation!['warehouses']
                                          ['address'],
                                      style:
                                          context.moonTypography?.body.text12,
                                    ),
                                  if (state.selectedDesignation!['note'] !=
                                      null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Note: ${state.selectedDesignation!['note']}',
                                      style: context.moonTypography?.body.text12
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ],
                              ),
                            )
                          else
                            Text('No warehouse assigned.',
                                style: context.moonTypography?.body.text14
                                    .copyWith(
                                        color: context.moonColors?.trunks)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Allocated Resources',
                                  style:
                                      context.moonTypography?.heading.text16),
                              AppButton.plain(
                                isFullWidth: false,
                                onTap: () => _showResourceAllocationDialog(
                                    context, app['id']),
                                label: const Text('Allocate'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (state.selectedResources.isEmpty)
                            Text('No resources allocated.',
                                style: context.moonTypography?.body.text14
                                    .copyWith(
                                        color: context.moonColors?.trunks))
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.selectedResources.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final res = state.selectedResources[index];
                                final itemDetails = res['inventory']?['items'];
                                final price = itemDetails?['price'] ?? 0;
                                final qty = res['quantity'] ?? 0;
                                final subtotal = qty * price;
                                final unit = itemDetails?['unit'] ?? '';

                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: context.moonColors?.goku,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.inventory_2_rounded,
                                          size: 20,
                                          color: context.moonColors?.beerus),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${itemDetails?['name'] ?? 'Unknown Item'} ($qty $unit)'
                                                    .trim(),
                                                style: context.moonTypography
                                                    ?.body.text14),
                                            if (price > 0)
                                              Text(
                                                  'Price: ${CurrencyUtils.formatNaira(price)} | Total: ${CurrencyUtils.formatNaira(subtotal)}',
                                                  style: context.moonTypography
                                                      ?.body.text12
                                                      .copyWith(
                                                          color: context
                                                              .moonColors
                                                              ?.roshi,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            Text(res['collection_address'],
                                                style: context.moonTypography
                                                    ?.body.text12),
                                          ],
                                        ),
                                      ),
                                      if (res['is_collected'] != true)
                                        Tooltip(
                                          message: 'Mark as collected',
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.check_circle_outline,
                                                size: 20,
                                                color: Colors.green),
                                            onPressed: () {
                                              context
                                                  .read<
                                                      ApplicationManagementCubit>()
                                                  .markAllocatedResourceAsCollected(
                                                    resourceId: res['id'],
                                                    applicationId: app['id'],
                                                  );
                                            },
                                          ),
                                        ),
                                      if (res['is_collected'] == true)
                                        MoonTag(
                                          label: const Text('COLLECTED'),
                                          tagSize: MoonTagSize.xs,
                                          backgroundColor: Colors.green
                                              .withValues(alpha: 0.2),
                                        ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            size: 20, color: Colors.red),
                                        onPressed: () {
                                          context
                                              .read<
                                                  ApplicationManagementCubit>()
                                              .removeAllocatedResource(
                                                resourceId: res['id'],
                                                applicationId: app['id'],
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 12),
                          if (state.selectedResources.isNotEmpty)
                            Builder(builder: (context) {
                              final total = state.selectedResources.fold<num>(0,
                                  (sum, res) {
                                final itemDetails = res['inventory']?['items'];
                                final price = itemDetails?['price'] ?? 0;
                                final qty = res['quantity'] ?? 0;
                                return sum + (qty * price);
                              });
                              if (total == 0) return const SizedBox.shrink();
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: context.moonColors?.beerus,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Grand Total (Resources)',
                                        style: context
                                            .moonTypography?.heading.text14),
                                    Text(CurrencyUtils.formatNaira(total),
                                        style: context
                                            .moonTypography?.heading.text16
                                            .copyWith(
                                                color: context
                                                    .moonColors?.piccolo)),
                                  ],
                                ),
                              );
                            }),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton.filled(
                    isFullWidth: true,
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _showStatusPicker(context, app['id'], status);
                    },
                    label: const Text('Change Status'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateApplicationDialog(BuildContext context) {
    final emailController = TextEditingController(text: '');
    final firstNameController = TextEditingController(text: '');
    final lastNameController = TextEditingController(text: '');
    final otherNamesController = TextEditingController(text: '');
    final phoneController = TextEditingController(text: '');
    final dobController = TextEditingController(text: '');
    final bankNameController = TextEditingController(text: '');
    final accountNumberController = TextEditingController(text: '');
    final accountNameController = TextEditingController(text: '');
    final nextOfKinNameController = TextEditingController(text: '');
    final nextOfKinPhoneController = TextEditingController(text: '');
    final nextOfKinRelationshipController = TextEditingController(text: '');
    final farmSizeController = TextEditingController(text: '');
    final farmLocationController = TextEditingController(text: '');
    final cropTypeController = TextEditingController(text: '');
    final kycNumberController = TextEditingController(text: '');
    final latitudeController = TextEditingController(text: '');
    final longitudeController = TextEditingController(text: '');
    final townController = TextEditingController(text: '');

    String? gender = '';
    String? kycType = '';
    String? selectedState;
    String? selectedLga;
    String? passportBase64;
    String? signatureBase64;

    final picker = ImagePicker();

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ApplicationManagementCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickImage(bool isPassport) async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                final bytes = await image.readAsBytes();
                final base64String =
                    'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';
                setState(() {
                  if (isPassport) {
                    passportBase64 = base64String;
                  } else {
                    signatureBase64 = base64String;
                  }
                });
              }
            }

            // Initial load
            context.read<ApplicationManagementCubit>().loadStates();

            return BlocBuilder<ApplicationManagementCubit,
                ApplicationManagementState>(
              builder: (context, state) {
                return AlertDialog(
                  title: const Text('Create Farmer Application'),
                  content: SizedBox(
                    width: 600,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSectionTitle(context, 'Account Info'),
                          MoonTextInput(
                              controller: emailController,
                              hintText: 'Farmer Email'),
                          const SizedBox(height: 12),
                          _buildSectionTitle(context, 'Personal Details'),
                          MoonTextInput(
                              controller: firstNameController,
                              hintText: 'First Name'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: lastNameController,
                              hintText: 'Last Name'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: otherNamesController,
                              hintText: 'Other Names'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                  child: MoonTextInput(
                                controller: dobController,
                                hintText: 'Date of Birth',
                                readOnly: true,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 18)),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    dobController.text =
                                        date.toString().split(' ').first;
                                  }
                                },
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: gender,
                                    hint: const Text('Gender'),
                                    isExpanded: true,
                                    items: ['Male', 'Female']
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => gender = v),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'Contact & Location'),
                          MoonTextInput(
                              controller: phoneController,
                              hintText: 'Phone Number (e.g. 08012345678)'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedState,
                                    hint: const Text('State'),
                                    isExpanded: true,
                                    items: state.availableStates
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          selectedState = v;
                                          selectedLga = null;
                                        });
                                        context
                                            .read<ApplicationManagementCubit>()
                                            .loadLgas(v);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedLga,
                                    hint: const Text('LGA'),
                                    isExpanded: true,
                                    items: state.availableLgas
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => selectedLga = v),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: townController,
                              hintText: 'Town/Village'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: farmLocationController,
                              hintText: 'Farm Location'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                  child: MoonTextInput(
                                      controller: latitudeController,
                                      hintText: 'Latitude')),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: MoonTextInput(
                                      controller: longitudeController,
                                      hintText: 'Longitude')),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'Farm & KYC'),
                          Row(
                            children: [
                              Expanded(
                                  child: MoonTextInput(
                                      controller: farmSizeController,
                                      hintText: 'Farm Size')),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: MoonTextInput(
                                      controller: cropTypeController,
                                      hintText: 'Crop Type')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: kycType,
                                    hint: const Text('KYC Type'),
                                    isExpanded: true,
                                    items: [
                                      'nin',
                                      'voters_card',
                                      'international_passport'
                                    ]
                                        .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e
                                                .replaceAll('_', ' ')
                                                .toUpperCase())))
                                        .toList(),
                                    onChanged: (v) =>
                                        setState(() => kycType = v),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: MoonTextInput(
                                      controller: kycNumberController,
                                      hintText: 'KYC Number')),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'Bank Details'),
                          MoonTextInput(
                              controller: bankNameController,
                              hintText: 'Bank Name'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: accountNumberController,
                              hintText: 'Account Number'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: accountNameController,
                              hintText: 'Account Name'),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'Next of Kin'),
                          MoonTextInput(
                              controller: nextOfKinNameController,
                              hintText: 'Full Name'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: nextOfKinPhoneController,
                              hintText: 'Phone Number'),
                          const SizedBox(height: 12),
                          MoonTextInput(
                              controller: nextOfKinRelationshipController,
                              hintText: 'Relationship'),
                          const SizedBox(height: 24),
                          _buildSectionTitle(context, 'Documents'),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Passport Photo'),
                                    const SizedBox(height: 8),
                                    if (passportBase64 != null)
                                      Image.memory(
                                          base64Decode(
                                              passportBase64!.split(',').last),
                                          height: 100),
                                    AppButton.plain(
                                        onTap: () => pickImage(true),
                                        label: const Text('Pick Passport')),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Signature'),
                                    const SizedBox(height: 8),
                                    if (signatureBase64 != null)
                                      Image.memory(
                                          base64Decode(
                                              signatureBase64!.split(',').last),
                                          height: 100),
                                    AppButton.plain(
                                        onTap: () => pickImage(false),
                                        label: const Text('Pick Signature')),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                        String phone = phoneController.text.trim();
                        if (phone.startsWith('0')) {
                          phone = '+234${phone.substring(1)}';
                        }

                        String nokPhone = nextOfKinPhoneController.text.trim();
                        if (nokPhone.startsWith('0')) {
                          nokPhone = '+234${nokPhone.substring(1)}';
                        }

                        final data = {
                          'first_name': firstNameController.text.trim(),
                          'last_name': lastNameController.text.trim(),
                          'other_names': otherNamesController.text.trim(),
                          'date_of_birth': dobController.text.trim(),
                          'gender': gender,
                          'phone_number': phone,
                          'state': selectedState,
                          'lga': selectedLga,
                          'town': townController.text.trim(),
                          'farm_location': farmLocationController.text.trim(),
                          'farm_size': farmSizeController.text.trim(),
                          'crop_type': cropTypeController.text.trim(),
                          'latitude': double.tryParse(latitudeController.text),
                          'longitude':
                              double.tryParse(longitudeController.text),
                          'bank_name': bankNameController.text.trim(),
                          'account_number': accountNumberController.text.trim(),
                          'account_name': accountNameController.text.trim(),
                          'next_of_kin_name':
                              nextOfKinNameController.text.trim(),
                          'next_of_kin_phone': nokPhone,
                          'next_of_kin_relationship':
                              nextOfKinRelationshipController.text.trim(),
                          'kyc_type': kycType,
                          'kyc_number': kycNumberController.text.trim(),
                        };
                        context
                            .read<ApplicationManagementCubit>()
                            .createApplication(
                              email: emailController.text.trim(),
                              metadata: {
                                'first_name': firstNameController.text.trim(),
                                'last_name': lastNameController.text.trim(),
                              },
                              applicationData: data,
                              passportBase64: passportBase64,
                              signatureBase64: signatureBase64,
                            );
                        Navigator.pop(dialogContext);
                      },
                      label: const Text('Create'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        title,
        style: context.moonTypography?.heading.text14.copyWith(
          color: context.moonColors?.piccolo,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showWarehousePicker(BuildContext context, String appId,
      List<Map<String, dynamic>> warehouses) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Assign Warehouse'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: warehouses
                .map((w) => ListTile(
                      title: Text('${w['name']} (${w['state'] ?? 'N/A'})'),
                      subtitle: Text(w['address'] ?? ''),
                      onTap: () {
                        context
                            .read<ApplicationManagementCubit>()
                            .assignWarehouse(
                              applicationId: appId,
                              warehouseId: w['id'],
                            );
                        Navigator.pop(dialogContext);
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showStatusPicker(
      BuildContext context, String appId, String currentStatus) {
    const statuses = ['initial', 'in_review', 'approved', 'rejected'];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses
              .map((s) => ListTile(
                    title: Text(s.toUpperCase()),
                    trailing: s == currentStatus
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      context
                          .read<ApplicationManagementCubit>()
                          .updateStatus(appId, s);
                      Navigator.pop(dialogContext);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showResourceAllocationDialog(
      BuildContext context, String applicationId) {
    String? selectedItemId;
    final quantityController = TextEditingController();
    final addressController = TextEditingController();

    final inventory = context.read<InventoryManagementCubit>().state.inventory;
    bool showItemDropdown = false;
    final cubit = context.read<ApplicationManagementCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) =>
          StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Allocate Resource'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoonDropdown(
                  show: showItemDropdown,
                  constrainWidthToChild: true,
                  onTapOutside: () =>
                      setDialogState(() => showItemDropdown = false),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: inventory.map((item) {
                      return MoonMenuItem(
                        onTap: () {
                          setDialogState(() {
                            selectedItemId = item['id'];
                            showItemDropdown = false;
                          });
                        },
                        label: Text(
                            '${item['items']?['name']} - ${item['warehouses']?['name']} (Available: ${item['quantity']} ${item['items']?['unit']}${item['items']?['price'] != null ? ' - ${CurrencyUtils.formatNaira(item['items']?['price'])}' : ' - Free'})'),
                      );
                    }).toList(),
                  ),
                  child: GestureDetector(
                    onTap: () => setDialogState(
                        () => showItemDropdown = !showItemDropdown),
                    child: AbsorbPointer(
                      child: MoonTextInput(
                        hintText: 'Select Resource Item',
                        readOnly: true,
                        controller: TextEditingController(
                            text: selectedItemId != null
                                ? '${inventory.firstWhere((i) => i['id'] == selectedItemId)['items']?['name']} - ${inventory.firstWhere((i) => i['id'] == selectedItemId)['warehouses']?['name']}'
                                : ''),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                MoonTextInput(
                  controller: quantityController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                MoonTextInput(
                  controller: addressController,
                  hintText: 'Collection Address',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            AppButton.filled(
              isFullWidth: false,
              onTap: () {
                final qty = num.tryParse(quantityController.text) ?? 0;
                if (selectedItemId == null) {
                  MoonToast.show(context,
                      label: const Text('Please select an item'));
                  return;
                }
                if (qty <= 0) {
                  MoonToast.show(context,
                      label: const Text('Quantity must be greater than 0'));
                  return;
                }

                final item =
                    inventory.firstWhere((i) => i['id'] == selectedItemId);
                final available = item['quantity'] as num;

                if (qty > available) {
                  MoonToast.show(context,
                      label: Text(
                          'Insufficient stock. Available: $available ${item['items']?['unit']}'));
                  return;
                }

                cubit.allocateResource(
                  applicationId: applicationId,
                  item: selectedItemId!,
                  quantity: qty,
                  collectionAddress: addressController.text.trim(),
                );
                Navigator.pop(dialogContext);
              },
              label: const Text('Allocate'),
            ),
          ],
        );
      }),
    );
  }

  void _confirmDeleteApplication(BuildContext context, dynamic app) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Application'),
        content: Text(
            'Are you sure you want to delete application ${app['reg_no']}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context
                  .read<ApplicationManagementCubit>()
                  .deleteApplication(app['id']);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'in_review':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
