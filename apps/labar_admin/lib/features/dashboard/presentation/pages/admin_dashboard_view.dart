import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/application_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/dashboard_overview_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/user_management_cubit.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/inventory_management_view.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:ui_library/ui_library.dart';

class AdminDashboardView extends StatelessWidget {
  final int index;
  const AdminDashboardView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => getIt<UserManagementCubit>()..fetchUsers()),
        BlocProvider(
            create: (context) =>
                getIt<ApplicationManagementCubit>()..watchApplications()),
        BlocProvider(
            create: (context) => getIt<DashboardOverviewCubit>()..init()),
        BlocProvider(
            create: (context) => getIt<InventoryManagementCubit>()..init()),
      ],
      child: _buildContent(index),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return const _DashboardOverview();
      case 1:
        return const _ApplicationManagementView();
      case 2:
        return const _UserManagementView();
      case 3:
        return const InventoryManagementView();
      default:
        return const _DashboardOverview();
    }
  }
}

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: MoonCircularLoader());
        }

        if (state.error != null) {
          return AppErrorView(
            onRetry: () => context.read<DashboardOverviewCubit>().init(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard Overview',
                  style: context.moonTypography?.heading.text24),
              const SizedBox(height: 24),
              Row(
                children: [
                  _StatCard(
                    title: 'Total Applications',
                    value: state.totalApplications.toString(),
                    icon: Icons.assignment_rounded,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 24),
                  _StatCard(
                    title: 'Active Agents',
                    value: state.activeAgents.toString(),
                    icon: Icons.person_pin_rounded,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 24),
                  _StatCard(
                    title: 'Pending Reviews',
                    value: state.pendingReviews.toString(),
                    icon: Icons.hourglass_empty_rounded,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text('Recent Activity',
                  style: context.moonTypography?.heading.text18),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.moonColors?.gohan,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: state.recentActivity.isEmpty
                    ? const Center(child: Text('No recent activity'))
                    : Column(
                        children: state.recentActivity.map((activity) {
                          final name = activity['first_name'] != null
                              ? '${activity['first_name']} ${activity['last_name']}'
                              : 'Unknown Farmer';
                          final regNo = activity['reg_no'] ?? 'N/A';

                          return Column(
                            children: [
                              _ActivityItem(
                                title: 'New Application',
                                subtitle: '$name submitted application $regNo',
                                time: 'Recently',
                              ),
                              if (activity != state.recentActivity.last)
                                const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.moonColors?.gohan,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 16),
            Text(title, style: context.moonTypography?.body.text12),
            const SizedBox(height: 4),
            Text(value, style: context.moonTypography?.heading.text24),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.moonColors?.goku,
            child: Icon(Icons.notifications_none_rounded,
                size: 20, color: context.moonColors?.piccolo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.moonTypography?.heading.text14),
                Text(subtitle, style: context.moonTypography?.body.text12),
              ],
            ),
          ),
          Text(time, style: context.moonTypography?.body.text10),
        ],
      ),
    );
  }
}

class _ApplicationManagementView extends StatefulWidget {
  const _ApplicationManagementView();

  @override
  State<_ApplicationManagementView> createState() =>
      _ApplicationManagementViewState();
}

class _ApplicationManagementViewState
    extends State<_ApplicationManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
                            _DetailInfo(
                                label: 'Full Name',
                                value:
                                    '${app['first_name'] ?? ''} ${app['last_name'] ?? ''}'),
                            _DetailInfo(
                                label: 'Email', value: app['email'] ?? '-'),
                            _DetailInfo(
                                label: 'Phone', value: app['phone'] ?? '-'),
                            _DetailInfo(
                                label: 'State', value: app['state'] ?? '-'),
                            _DetailInfo(label: 'LGA', value: app['lga'] ?? '-'),
                            _DetailInfo(
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
                  _FarmMapView(app: app),
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
                              child: _DetailInfo(
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
                                                '${res['inventory']?['item_name'] ?? res['item'] ?? 'Unknown Item'} (${res['quantity'] ?? 0} ${res['inventory']?['unit'] ?? ''})'
                                                    .trim(),
                                                style: context.moonTypography
                                                    ?.body.text14),
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
                        final data = {
                          'first_name': firstNameController.text.trim(),
                          'last_name': lastNameController.text.trim(),
                          'other_names': otherNamesController.text.trim(),
                          'date_of_birth': dobController.text.trim(),
                          'gender': gender,
                          'phone_number': phoneController.text.trim(),
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
                          'next_of_kin_phone':
                              nextOfKinPhoneController.text.trim(),
                          'next_of_kin_relationship':
                              nextOfKinRelationshipController.text.trim(),
                          'kyc_type': kycType,
                          'kyc_number': kycNumberController.text.trim(),
                        };
                        print('Submitting Application: $data');
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
                      title: Text(w['name']),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MoonDropdown(
                show: showItemDropdown,
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
                          '${item['item_name']} - ${item['warehouses']?['name']} (Available: ${item['quantity']} ${item['unit']})'),
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
                              ? '${inventory.firstWhere((i) => i['id'] == selectedItemId)['item_name']} - ${inventory.firstWhere((i) => i['id'] == selectedItemId)['warehouses']?['name']}'
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
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            AppButton.filled(
              isFullWidth: false,
              onTap: () {
                final qty = num.tryParse(quantityController.text) ?? 0;
                if (selectedItemId != null && qty > 0) {
                  cubit.allocateResource(
                    applicationId: applicationId,
                    item: selectedItemId!,
                    quantity: qty,
                    collectionAddress: addressController.text.trim(),
                  );
                  Navigator.pop(dialogContext);
                }
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

class _UserManagementView extends StatefulWidget {
  const _UserManagementView();

  @override
  State<_UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<_UserManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<SessionCubit>().state.user;
    final callerRole = currentUser?.role;

    return BlocListener<UserManagementCubit, UserManagementState>(
      listener: (context, state) {
        if (state.error != null) {
          MoonToast.show(
            context,
            label: Text(state.error!),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User Management',
                    style: context.moonTypography?.heading.text24),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: MoonTextInput(
                        controller: _searchController,
                        hintText: 'Search users...',
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
                    const SizedBox(width: 16),
                    if (callerRole == 'super_admin')
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () => _showAddUserDialog(context),
                        label: const Text('Add Admin / Agent'),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<UserManagementCubit, UserManagementState>(
                builder: (context, state) {
                  final users = state.users.where((user) {
                    if (_searchQuery.isEmpty) return true;

                    final firstName = (user.firstName ?? '').toLowerCase();
                    final lastName = (user.lastName ?? '').toLowerCase();
                    final email = (user.email ?? '').toLowerCase();
                    final role = (user.role ?? '').toLowerCase();

                    return firstName.contains(_searchQuery) ||
                        lastName.contains(_searchQuery) ||
                        email.contains(_searchQuery) ||
                        role.contains(_searchQuery);
                  }).toList();

                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 48, color: context.moonColors?.trunks),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No users found'
                                : 'No users found matching "$_searchQuery"',
                            style: context.moonTypography?.body.text16,
                          ),
                          if (state.error != null) ...[
                            const SizedBox(height: 16),
                            AppButton.filled(
                              label: const Text('Retry'),
                              onTap: () => context
                                  .read<UserManagementCubit>()
                                  .fetchUsers(),
                            ),
                          ],
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
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: users.map((user) {
                              final isActive = user.active ?? true;
                              final isMe = user.id == currentUser?.id;
                              final fullName = (user.firstName != null ||
                                      user.lastName != null)
                                  ? '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                      .trim()
                                  : '-';
                              return DataRow(
                                  onSelectChanged: (_) =>
                                      _showUserProfile(context, user),
                                  cells: [
                                    DataCell(Row(
                                      children: [
                                        Text(fullName),
                                        if (isMe) ...[
                                          const SizedBox(width: 8),
                                          MoonTag(
                                            label: const Text('ME'),
                                            tagSize: MoonTagSize.xs,
                                            backgroundColor: context
                                                .moonColors?.beerus
                                                .withValues(alpha: 0.5),
                                          ),
                                        ],
                                      ],
                                    )),
                                    DataCell(Text(user.email ?? '-')),
                                    DataCell(MoonTag(
                                      label: Text(
                                          user.role?.toUpperCase() ?? 'NONE'),
                                      tagSize: MoonTagSize.xs,
                                      backgroundColor: user.role ==
                                              'super_admin'
                                          ? Colors.purple.withValues(alpha: 0.2)
                                          : null,
                                    )),
                                    DataCell(Text(user.createdAt
                                        .toString()
                                        .split(' ')
                                        .first)),
                                    DataCell(
                                      callerRole == 'super_admin'
                                          ? MoonSwitch(
                                              value: isActive,
                                              onChanged: isMe
                                                  ? null
                                                  : (v) => context
                                                      .read<
                                                          UserManagementCubit>()
                                                      .toggleUserStatus(
                                                          user.id, v),
                                            )
                                          : MoonTag(
                                              label: Text(isActive
                                                  ? 'ACTIVE'
                                                  : 'INACTIVE'),
                                              tagSize: MoonTagSize.xs,
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                              backgroundColor: isActive
                                                  ? Colors.green
                                                      .withValues(alpha: 0.2)
                                                  : Colors.red
                                                      .withValues(alpha: 0.2),
                                            ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (callerRole == 'super_admin') ...[
                                            IconButton(
                                              icon: const Icon(Icons
                                                  .manage_accounts_outlined),
                                              tooltip: 'Change Role',
                                              onPressed: isMe
                                                  ? null
                                                  : () => _showRolePicker(
                                                      context, user),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red),
                                              tooltip: 'Delete User',
                                              onPressed: isMe
                                                  ? null
                                                  : () => _confirmDelete(
                                                      context, user),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
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
          ],
        ),
      ),
    );
  }

  void _showUserProfile(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailInfo(label: 'First Name', value: user.firstName ?? '-'),
            _DetailInfo(label: 'Last Name', value: user.lastName ?? '-'),
            _DetailInfo(label: 'Email', value: user.email ?? '-'),
            _DetailInfo(label: 'Role', value: user.role?.toUpperCase() ?? '-'),
            _DetailInfo(label: 'Created At', value: user.createdAt.toString()),
            _DetailInfo(
                label: 'Status',
                value: (user.active ?? true) ? 'Active' : 'Inactive'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _showRolePicker(BuildContext context, dynamic user) {
    const roles = ['farmer', 'agent', 'admin', 'super_admin'];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles
              .map((r) => ListTile(
                    title: Text(r.toUpperCase()),
                    trailing: r == user.role
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      context
                          .read<UserManagementCubit>()
                          .updateRole(user.id, r);
                      Navigator.pop(dialogContext);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.email}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<UserManagementCubit>().deleteUser(user.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    String selectedRole = 'agent';
    final callerRole = context.read<SessionCubit>().state.user?.role;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserManagementCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Internal User'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MoonTextInput(
                      controller: firstNameController, hintText: 'First Name'),
                  const SizedBox(height: 12),
                  MoonTextInput(
                      controller: lastNameController, hintText: 'Last Name'),
                  const SizedBox(height: 12),
                  MoonTextInput(controller: emailController, hintText: 'Email'),
                  const SizedBox(height: 12),
                  MoonTextInput(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(height: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      isExpanded: true,
                      onChanged: (v) => setState(() => selectedRole = v!),
                      items: [
                        const DropdownMenuItem(
                            value: 'agent', child: Text('Agent')),
                        if (callerRole == 'super_admin')
                          const DropdownMenuItem(
                              value: 'admin', child: Text('Admin')),
                      ],
                    ),
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
                  context.read<UserManagementCubit>().createUser(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        role: selectedRole,
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                      );
                  Navigator.pop(dialogContext);
                },
                label: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final String label;
  final String value;

  const _DetailInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.moonTypography?.body.text10.copyWith(
              color: context.moonColors?.trunks,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: context.moonTypography?.body.text14.copyWith(
              color: context.moonColors?.bulma,
            ),
          ),
        ],
      ),
    );
  }
}

class _FarmMapView extends StatefulWidget {
  final dynamic app;
  const _FarmMapView({required this.app});

  @override
  State<_FarmMapView> createState() => _FarmMapViewState();
}

class _FarmMapViewState extends State<_FarmMapView> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  List<ll.LatLng> _extractPolygon() {
    final raw = widget.app['farm_polygon'];
    if (raw == null) return [];
    List<dynamic> points;
    if (raw is String) {
      try {
        points = (json.decode(raw) as List);
      } catch (_) {
        return [];
      }
    } else if (raw is List) {
      points = raw;
    } else {
      return [];
    }
    return points
        .map((p) {
          final map = p as Map<String, dynamic>;
          final lat = (map['lat'] as num?)?.toDouble();
          final lng = (map['lng'] as num?)?.toDouble();
          if (lat == null || lng == null) return null;
          return ll.LatLng(lat, lng);
        })
        .whereType<ll.LatLng>()
        .toList();
  }

  ll.LatLng? _centerPoint(List<ll.LatLng> pts) {
    if (pts.isEmpty) return null;
    final lat = pts.map((p) => p.latitude).reduce((a, b) => a + b) / pts.length;
    final lng =
        pts.map((p) => p.longitude).reduce((a, b) => a + b) / pts.length;
    return ll.LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final polygonPoints = _extractPolygon();
    final lat = (widget.app['latitude'] as num?)?.toDouble();
    final lng = (widget.app['longitude'] as num?)?.toDouble();
    final farmSize = widget.app['farm_size']?.toString();

    ll.LatLng center = ll.LatLng(9.0820, 8.6753); // Nigeria fallback
    double zoom = 5;

    if (polygonPoints.isNotEmpty) {
      center = _centerPoint(polygonPoints)!;
      zoom = 14;
    } else if (lat != null && lng != null) {
      center = ll.LatLng(lat, lng);
      zoom = 14;
    }

    final hasMapData = polygonPoints.isNotEmpty || (lat != null && lng != null);

    if (!hasMapData) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: context.moonColors?.goku,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('No farm location data available')),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: zoom,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.codeswot.labar_admin',
                ),
                if (polygonPoints.length >= 3)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: polygonPoints,
                        color: Colors.purple.withOpacity(0.3),
                        borderColor: Colors.purple,
                        borderStrokeWidth: 2.5,
                      ),
                    ],
                  ),
                if (lat != null && lng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: ll.LatLng(lat, lng),
                        width: 32,
                        height: 32,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (farmSize != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.straighten_rounded,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '$farmSize ha',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
