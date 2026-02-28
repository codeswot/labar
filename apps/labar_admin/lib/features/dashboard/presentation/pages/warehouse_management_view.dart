import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/core/session/session_state.dart';
import 'package:labar_admin/core/utils/currency_utils.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/detail_info.dart';
import 'package:ui_library/ui_library.dart';

class WarehouseManagementView extends StatefulWidget {
  final VoidCallback? onNavigateToInventory;
  const WarehouseManagementView({super.key, this.onNavigateToInventory});

  @override
  State<WarehouseManagementView> createState() =>
      WarehouseManagementViewState();
}

class WarehouseManagementViewState extends State<WarehouseManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _stateFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryManagementCubit, InventoryManagementState>(
      listener: (context, state) {
        if (state.error != null) {
          MoonToast.show(context, label: Text(state.error!));
        }
      },
      builder: (context, state) {
        final filteredWarehouses = state.warehouses.where((w) {
          // Filter by State
          if (_stateFilter != null && (w['state'] ?? '') != _stateFilter) {
            return false;
          }

          if (_searchQuery.isEmpty) return true;
          final name = (w['name'] ?? '').toString().toLowerCase();
          final stateName = (w['state'] ?? '').toString().toLowerCase();
          final address = (w['address'] ?? '').toString().toLowerCase();
          return name.contains(_searchQuery) ||
              stateName.contains(_searchQuery) ||
              address.contains(_searchQuery);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Warehouse Management',
                      style: context.moonTypography?.heading.text24),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _stateFilter,
                            hint: const Text('State'),
                            isExpanded: true,
                            onChanged: (v) => setState(() => _stateFilter = v),
                            items: [
                              const DropdownMenuItem(
                                  value: null, child: Text('All States')),
                              ...state.warehouses
                                  .map((w) => w['state'])
                                  .toSet()
                                  .where((s) => s != null)
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s!))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 300,
                        child: MoonTextInput(
                          controller: _searchController,
                          hintText: 'Search warehouses...',
                          leading: const Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<SessionCubit, SessionState>(
                    builder: (context, sessionState) {
                      final role =
                          sessionState.status == SessionStatus.authenticated
                              ? sessionState.user?.role
                              : null;
                      if (role == 'super_admin' || role == 'admin') {
                        return AppButton.filled(
                          isFullWidth: false,
                          onTap: () => _showAddWarehouse(context),
                          label: const Text('Add Warehouse'),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.moonColors?.gohan,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor:
                          WidgetStateProperty.all(context.moonColors?.goku),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('State')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Created At')),
                      ],
                      rows: filteredWarehouses.map((w) {
                        return DataRow(
                          onSelectChanged: (_) =>
                              _showWarehouseDetailDialog(context, w),
                          cells: [
                            DataCell(Text(w['name'] ?? 'N/A')),
                            DataCell(Text(w['state'] ?? 'N/A')),
                            DataCell(Text(w['address'] ?? 'N/A')),
                            DataCell(Text(w['created_at'] != null
                                ? w['created_at'].toString().split(' ').first
                                : 'N/A')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWarehouseDetailDialog(
      BuildContext context, Map<String, dynamic> warehouse) {
    final cubit = context.read<InventoryManagementCubit>();
    cubit.fetchWarehouseDetails(warehouse['id']);

    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<InventoryManagementCubit, InventoryManagementState>(
          builder: (context, state) {
            final warehouseInventory = state.inventory
                .where((item) => item['warehouse_id'] == warehouse['id'])
                .toList();
            final farmers = state.selectedWarehouseFarmers;
            final allocations = state.selectedWarehouseAllocations;

            return AlertDialog(
              title: Text('Warehouse Detail: ${warehouse['name']}'),
              content: SizedBox(
                width: 800,
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview
                      Row(
                        children: [
                          Expanded(
                              child: DetailInfo(
                                  label: 'Name',
                                  value: warehouse['name'] ?? '')),
                          Expanded(
                              child: DetailInfo(
                                  label: 'State',
                                  value: warehouse['state'] ?? '')),
                        ],
                      ),
                      DetailInfo(
                          label: 'Address', value: warehouse['address'] ?? ''),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Inventory Tabs
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Inventory'),
                                Tab(text: 'Attached Farmers'),
                                Tab(text: 'Allocation Records'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                children: [
                                  // Inventory
                                  _buildInventoryList(warehouseInventory),
                                  // Farmers
                                  _buildFarmersList(farmers),
                                  // Allocations
                                  _buildAllocationsList(allocations),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, sessionState) {
                    final role =
                        sessionState.status == SessionStatus.authenticated
                            ? sessionState.user?.role
                            : null;
                    if (role == 'super_admin' || role == 'admin') {
                      return AppButton.filled(
                        isFullWidth: false,
                        label: const Text('Edit Warehouse'),
                        onTap: () {
                          Navigator.pop(dialogCtx);
                          _showEditWarehouse(context, warehouse);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInventoryList(List<Map<String, dynamic>> inventory) {
    if (inventory.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No inventory in this warehouse.'),
          const SizedBox(height: 24),
          AppButton.filled(
            isFullWidth: false,
            label: const Text('Add New Inventory'),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigateToInventory?.call();
            },
          ),
        ],
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: inventory.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final inv = inventory[index];
              final itemDetails = inv['items'];
              final itemName =
                  itemDetails?['name'] ?? inv['item_name'] ?? 'Unknown Item';
              final unit = itemDetails?['unit'] ?? inv['unit'] ?? '';
              final price = itemDetails?['price'] ?? inv['price_per_item'] ?? 0;
              final qty = inv['quantity'] ?? 0;
              final totalValue = qty * price;

              return ListTile(
                title: Text(itemName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: $qty $unit'),
                    if (price > 0)
                      Text(
                        'Total Value: ${CurrencyUtils.formatNaira(totalValue)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                  ],
                ),
                trailing: Text(price > 0
                    ? '${CurrencyUtils.formatNaira(price)} / $unit'
                    : 'Free'),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AppButton.filled(
          isFullWidth: true,
          label: const Text('Add New Inventory'),
          onTap: () {
            Navigator.pop(context);
            widget.onNavigateToInventory?.call();
          },
        ),
      ],
    );
  }

  Widget _buildFarmersList(List<Map<String, dynamic>> farmers) {
    if (farmers.isEmpty) {
      return const Center(child: Text('No farmers attached.'));
    }
    return ListView.separated(
      itemCount: farmers.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final f = farmers[index];
        final app = f['applications'];
        final name = (app != null)
            ? '${app['first_name'] ?? ''} ${app['last_name'] ?? ''}'
            : 'Unknown';
        return ListTile(
          leading: const MoonAvatar(content: Icon(Icons.person)),
          title: Text(name),
          subtitle: Text('Reg No: ${app?['reg_no'] ?? 'N/A'}'),
        );
      },
    );
  }

  Widget _buildAllocationsList(List<Map<String, dynamic>> allocations) {
    if (allocations.isEmpty) {
      return const Center(child: Text('No allocation records found.'));
    }
    return ListView.separated(
      itemCount: allocations.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final alloc = allocations[index];
        final inv = alloc['inventory'];
        final itemDetails = inv != null ? inv['items'] : null;
        final app = alloc['applications'];
        final farmerName = (app != null)
            ? '${app['first_name'] ?? ''} ${app['last_name'] ?? ''}'
            : 'Unknown Farmer';

        final itemName = itemDetails?['name'] ?? inv?['item_name'] ?? 'Item';
        final unit = itemDetails?['unit'] ?? inv?['unit'] ?? '';
        final date = (alloc['created_at'] != null)
            ? DateFormat('MMM dd, yyyy HH:mm')
                .format(DateTime.parse(alloc['created_at']))
            : '';

        final price = itemDetails?['price'] ?? inv?['price_per_item'] ?? 0;
        final total = (alloc['quantity'] as num? ?? 0) * price;

        return ListTile(
          title: Text('$farmerName - $itemName'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Qty: ${alloc['quantity']} $unit | Date: $date'),
              if (price > 0)
                Text(
                  'Allocated Value: ${CurrencyUtils.formatNaira(total)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showAddWarehouse(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    String? selectedState;
    bool showStateDropdown = false;

    final nigeriaStates = [
      "Abia",
      "Adamawa",
      "Akwa Ibom",
      "Anambra",
      "Bauchi",
      "Bayelsa",
      "Benue",
      "Borno",
      "Cross River",
      "Delta",
      "Ebonyi",
      "Edo",
      "Ekiti",
      "Enugu",
      "FCT",
      "Gombe",
      "Imo",
      "Jigawa",
      "Kaduna",
      "Kano",
      "Katsina",
      "Kebbi",
      "Kogi",
      "Kwara",
      "Lagos",
      "Nasarawa",
      "Niger",
      "Ogun",
      "Ondo",
      "Osun",
      "Oyo",
      "Plateau",
      "Rivers",
      "Sokoto",
      "Taraba",
      "Yobe",
      "Zamfara"
    ];

    final cubit = context.read<InventoryManagementCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add New Warehouse'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoonTextInput(
                  controller: nameController,
                  hintText: 'Warehouse Name',
                ),
                const SizedBox(height: 12),
                MoonTextInput(
                  controller: addressController,
                  hintText: 'Address',
                ),
                const SizedBox(height: 12),
                MoonDropdown(
                  constrainWidthToChild: true,
                  show: showStateDropdown,
                  onTapOutside: () => setState(() => showStateDropdown = false),
                  content: Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: nigeriaStates
                            .map((s) => MoonMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectedState = s;
                                      showStateDropdown = false;
                                    });
                                  },
                                  label: Text(s),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => showStateDropdown = true),
                    child: AbsorbPointer(
                      child: MoonTextInput(
                        hintText: 'Select State',
                        controller: TextEditingController(text: selectedState),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              AppButton.filled(
                isFullWidth: false,
                label: const Text('Add Warehouse'),
                onTap: () {
                  if (nameController.text.isNotEmpty &&
                      selectedState != null &&
                      addressController.text.isNotEmpty) {
                    context.read<InventoryManagementCubit>().addWarehouse(
                          name: nameController.text,
                          address: addressController.text,
                          state: selectedState,
                        );
                    Navigator.pop(dialogContext);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditWarehouse(
      BuildContext context, Map<String, dynamic> warehouse) {
    final nameController = TextEditingController(text: warehouse['name']);
    final addressController = TextEditingController(text: warehouse['address']);
    String? selectedState = warehouse['state'];
    bool showStateDropdown = false;

    final nigeriaStates = [
      "Abia",
      "Adamawa",
      "Akwa Ibom",
      "Anambra",
      "Bauchi",
      "Bayelsa",
      "Benue",
      "Borno",
      "Cross River",
      "Delta",
      "Ebonyi",
      "Edo",
      "Ekiti",
      "Enugu",
      "FCT",
      "Gombe",
      "Imo",
      "Jigawa",
      "Kaduna",
      "Kano",
      "Katsina",
      "Kebbi",
      "Kogi",
      "Kwara",
      "Lagos",
      "Nasarawa",
      "Niger",
      "Ogun",
      "Ondo",
      "Osun",
      "Oyo",
      "Plateau",
      "Rivers",
      "Sokoto",
      "Taraba",
      "Yobe",
      "Zamfara"
    ];

    final cubit = context.read<InventoryManagementCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Edit Warehouse'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoonTextInput(
                  controller: nameController,
                  hintText: 'Warehouse Name',
                ),
                const SizedBox(height: 12),
                MoonTextInput(
                  controller: addressController,
                  hintText: 'Address',
                ),
                const SizedBox(height: 12),
                MoonDropdown(
                  constrainWidthToChild: true,
                  show: showStateDropdown,
                  onTapOutside: () => setState(() => showStateDropdown = false),
                  content: Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: nigeriaStates
                            .map((s) => MoonMenuItem(
                                  onTap: () {
                                    setState(() {
                                      selectedState = s;
                                      showStateDropdown = false;
                                    });
                                  },
                                  label: Text(s),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => showStateDropdown = true),
                    child: AbsorbPointer(
                      child: MoonTextInput(
                        hintText: 'Select State',
                        controller: TextEditingController(text: selectedState),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              AppButton.filled(
                isFullWidth: false,
                label: const Text('Update Warehouse'),
                onTap: () {
                  if (nameController.text.isNotEmpty &&
                      selectedState != null &&
                      addressController.text.isNotEmpty) {
                    context.read<InventoryManagementCubit>().updateWarehouse(
                          id: warehouse['id'],
                          name: nameController.text,
                          address: addressController.text,
                          state: selectedState,
                        );
                    Navigator.pop(dialogContext);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
