import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/core/utils/currency_utils.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/detail_info.dart';
import 'package:ui_library/ui_library.dart';
import 'pdf_waybill_generator.dart';
import 'package:intl/intl.dart';

class InventoryManagementView extends StatefulWidget {
  const InventoryManagementView({super.key});

  @override
  State<InventoryManagementView> createState() =>
      _InventoryManagementViewState();
}

class _InventoryManagementViewState extends State<InventoryManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _invWarehouseFilter;
  String? _invStateFilter;
  bool _invLowStockFilter = false;
  String? _wbWarehouseFilter;

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: context.moonColors?.dodoria,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.inventory.isEmpty) {
          return const Center(child: MoonCircularLoader());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Inventory & Waybills',
                      style: context.moonTypography?.heading.text24),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: MoonTextInput(
                          controller: _searchController,
                          hintText: 'Search inventory & waybills...',
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
                      const SizedBox(width: 24),
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () =>
                            _showAddInventory(context, state.warehouses),
                        label: const Text('Add Inventory'),
                      ),
                      const SizedBox(width: 12),
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () => _showAddWarehouse(context),
                        label: const Text('Add Warehouse'),
                      ),
                      const SizedBox(width: 12),
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () => _showGenerateWaybill(
                            context, state.inventory, state.warehouses),
                        label: const Text('Generate Waybill'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),

              // Inventory Section
              Container(
                decoration: BoxDecoration(
                  color: context.moonColors?.gohan,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: context.moonColors?.beerus ??
                          Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Text('Current Inventory Levels',
                              style: context.moonTypography?.heading.text18),
                          const Spacer(),
                          SizedBox(
                            width: 150,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _invWarehouseFilter,
                                hint: const Text('Warehouse'),
                                isExpanded: true,
                                onChanged: (v) =>
                                    setState(() => _invWarehouseFilter = v),
                                items: [
                                  const DropdownMenuItem(
                                      value: null,
                                      child: Text('All Warehouses')),
                                  ...state.warehouses.map((w) =>
                                      DropdownMenuItem(
                                          value: w['id'],
                                          child: Text(w['name']))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 150,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _invStateFilter,
                                hint: const Text('State'),
                                isExpanded: true,
                                onChanged: (v) =>
                                    setState(() => _invStateFilter = v),
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
                          const SizedBox(width: 12),
                          MoonChip(
                            label: const Text('Low Stock'),
                            isActive: _invLowStockFilter,
                            onTap: () => setState(
                                () => _invLowStockFilter = !_invLowStockFilter),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Builder(builder: (context) {
                      final filteredInventory = state.inventory.where((inv) {
                        // Filter by Warehouse
                        if (_invWarehouseFilter != null &&
                            inv['warehouse_id'] != _invWarehouseFilter) {
                          return false;
                        }

                        // Filter by State
                        if (_invStateFilter != null &&
                            inv['warehouses']?['state'] != _invStateFilter) {
                          return false;
                        }

                        // Filter by Low Stock (e.g. < 50)
                        if (_invLowStockFilter &&
                            (inv['quantity'] as num) >= 50) {
                          return false;
                        }

                        if (_searchQuery.isEmpty) return true;
                        final itemName =
                            (inv['item_name'] ?? '').toString().toLowerCase();
                        final warehouseName = (inv['warehouses']?['name'] ?? '')
                            .toString()
                            .toLowerCase();
                        return itemName.contains(_searchQuery) ||
                            warehouseName.contains(_searchQuery);
                      }).toList();

                      if (filteredInventory.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Center(
                            child: Text(_searchQuery.isEmpty
                                ? 'No inventory records found.'
                                : 'No records matching "$_searchQuery"'),
                          ),
                        );
                      }

                      return DataTable(
                        columns: const [
                          DataColumn(label: Text('Item Name')),
                          DataColumn(label: Text('Warehouse')),
                          DataColumn(label: Text('State')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Unit')),
                          DataColumn(label: Text('Price per Item')),
                        ],
                        rows: filteredInventory.map((inv) {
                          return DataRow(
                              onSelectChanged: (_) =>
                                  _showInventoryDetailDialog(context, inv),
                              cells: [
                                DataCell(Text(inv['item_name'] ?? '')),
                                DataCell(Text(inv['warehouses']?['name'] ??
                                    'Unknown Warehouse')),
                                DataCell(
                                    Text(inv['warehouses']?['state'] ?? 'N/A')),
                                DataCell(Text(inv['quantity'].toString())),
                                DataCell(Text(inv['unit'] ?? '')),
                                DataCell(Text(inv['price_per_item'] != null
                                    ? CurrencyUtils.formatNaira(
                                        inv['price_per_item'])
                                    : 'Free')),
                              ]);
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Waybills Section
              Container(
                decoration: BoxDecoration(
                  color: context.moonColors?.gohan,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: context.moonColors?.beerus ??
                          Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Text('Waybills Generated',
                              style: context.moonTypography?.heading.text18),
                          const Spacer(),
                          SizedBox(
                            width: 200,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _wbWarehouseFilter,
                                hint: const Text('Source Warehouse'),
                                isExpanded: true,
                                onChanged: (v) =>
                                    setState(() => _wbWarehouseFilter = v),
                                items: [
                                  const DropdownMenuItem(
                                      value: null,
                                      child: Text('All Warehouses')),
                                  ...state.warehouses.map((w) =>
                                      DropdownMenuItem(
                                          value: w['id'],
                                          child: Text(w['name']))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Builder(builder: (context) {
                      final filteredWaybills = state.waybills.where((wb) {
                        // Filter by Source Warehouse
                        if (_wbWarehouseFilter != null &&
                            wb['warehouse_id'] != _wbWarehouseFilter) {
                          return false;
                        }

                        if (_searchQuery.isEmpty) return true;
                        final waybillNumber = (wb['waybill_number'] ?? '')
                            .toString()
                            .toLowerCase();
                        final itemName =
                            (wb['item_name'] ?? '').toString().toLowerCase();
                        final destination =
                            (wb['destination'] ?? '').toString().toLowerCase();
                        return waybillNumber.contains(_searchQuery) ||
                            itemName.contains(_searchQuery) ||
                            destination.contains(_searchQuery);
                      }).toList();

                      if (filteredWaybills.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: Center(
                            child: Text(_searchQuery.isEmpty
                                ? 'No waybills found.'
                                : 'No waybills matching "$_searchQuery"'),
                          ),
                        );
                      }

                      return DataTable(
                        columns: const [
                          DataColumn(label: Text('Waybill #')),
                          DataColumn(label: Text('Item Name')),
                          DataColumn(label: Text('Qty')),
                          DataColumn(label: Text('Destination')),
                          DataColumn(label: Text('Date Generated')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: filteredWaybills.map((wb) {
                          final generatedDate = (wb['dispatch_date'] != null)
                              ? DateFormat('MMM dd, yyyy HH:mm')
                                  .format(DateTime.parse(wb['dispatch_date']))
                              : '';

                          return DataRow(cells: [
                            DataCell(Text(wb['waybill_number'] ?? '')),
                            DataCell(Text(wb['item_name'] ?? '')),
                            DataCell(Text('${wb['quantity']} ${wb['unit']}')),
                            DataCell(Text(wb['destination'] ?? '')),
                            DataCell(Text(generatedDate)),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.picture_as_pdf,
                                    size: 16, color: Colors.red),
                                onPressed: () {
                                  _downloadWaybillPDF(context, wb);
                                },
                                tooltip: 'Download PDF',
                              ),
                            ),
                          ]);
                        }).toList(),
                      );
                    }),
                  ],
                ),
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

  void _showAddInventory(
      BuildContext context, List<Map<String, dynamic>> warehouses) {
    final cubit = context.read<InventoryManagementCubit>();
    String? selectedWarehouseId;
    final itemNameController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
              title: const Text('Add Inventory'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatefulBuilder(builder: (builderContext, setState) {
                      bool showDropdown = false;

                      return StatefulBuilder(
                          builder: (innerContext, setInnerState) {
                        return MoonDropdown(
                          show: showDropdown,
                          onTapOutside: () =>
                              setInnerState(() => showDropdown = false),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: warehouses.map((w) {
                              return MoonMenuItem(
                                onTap: () {
                                  setInnerState(() {
                                    selectedWarehouseId = w['id'];
                                    showDropdown = false;
                                  });
                                  setState(() {});
                                },
                                label: Text(
                                    '${w['name']} (${w['state'] ?? 'N/A'})'),
                              );
                            }).toList(),
                          ),
                          child: GestureDetector(
                            onTap: () => setInnerState(
                                () => showDropdown = !showDropdown),
                            child: AbsorbPointer(
                              child: MoonTextInput(
                                hintText: 'Select Warehouse',
                                readOnly: true,
                                controller: TextEditingController(
                                    text: warehouses.firstWhere(
                                        (w) => w['id'] == selectedWarehouseId,
                                        orElse: () => {'name': ''})['name']),
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                    const SizedBox(height: 12),
                    MoonTextInput(
                      controller: itemNameController,
                      hintText: 'Item Name (e.g. Fertilizer NPK 15:15:15)',
                    ),
                    const SizedBox(height: 12),
                    MoonTextInput(
                      controller: qtyController,
                      hintText: 'Quantity',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    MoonTextInput(
                      controller: unitController,
                      hintText: 'Unit (e.g. Bags)',
                    ),
                    const SizedBox(height: 12),
                    MoonTextInput(
                      controller: priceController,
                      hintText: 'Price per Item (Optional, blank = Free)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                AppButton.filled(
                  onTap: () {
                    final qty = num.tryParse(qtyController.text) ?? 0;
                    final price = num.tryParse(priceController.text);
                    if (selectedWarehouseId == null) {
                      MoonToast.show(context,
                          label: const Text('Please select a warehouse'));
                      return;
                    }
                    if (qty <= 0) {
                      MoonToast.show(context,
                          label: const Text('Quantity must be greater than 0'));
                      return;
                    }
                    cubit.addInventory(
                      warehouseId: selectedWarehouseId!,
                      itemName: itemNameController.text.trim(),
                      quantity: qty,
                      unit: unitController.text.trim(),
                      pricePerItem: price,
                    );
                    Navigator.pop(dialogCtx);
                  },
                  label: const Text('Save'),
                ),
              ],
            ));
  }

  void _showGenerateWaybill(
      BuildContext context,
      List<Map<String, dynamic>> inventory,
      List<Map<String, dynamic>> warehouses) {
    final cubit = context.read<InventoryManagementCubit>();
    String? selectedWarehouseId;
    String? selectedItemName;
    final qtyController = TextEditingController();
    final unitController = TextEditingController(text: 'Bags');
    final destinationController = TextEditingController();
    final driverNameController = TextEditingController();
    final driverPhoneController = TextEditingController();
    final vehicleNumberController = TextEditingController();

    String? createdBy = context.read<SessionCubit>().state.user?.id;

    bool showWarehouseDropdown = false;
    bool showItemDropdown = false;

    showDialog(
        context: context,
        builder: (dialogCtx) =>
            StatefulBuilder(builder: (builderContext, setDialogState) {
              final availableItems = inventory
                  .where((item) => item['warehouse_id'] == selectedWarehouseId)
                  .toList();

              return AlertDialog(
                title: const Text('Generate Waybill (Dispatch Items)'),
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MoonDropdown(
                          show: showWarehouseDropdown,
                          onTapOutside: () => setDialogState(
                              () => showWarehouseDropdown = false),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: warehouses.map((w) {
                              return MoonMenuItem(
                                onTap: () {
                                  setDialogState(() {
                                    selectedWarehouseId = w['id'];
                                    selectedItemName = null;
                                    unitController.text = '';
                                    showWarehouseDropdown = false;
                                  });
                                },
                                label: Text(
                                    '${w['name']} (${w['state'] ?? 'N/A'})'),
                              );
                            }).toList(),
                          ),
                          child: GestureDetector(
                            onTap: () => setDialogState(() =>
                                showWarehouseDropdown = !showWarehouseDropdown),
                            child: AbsorbPointer(
                              child: MoonTextInput(
                                hintText: 'Select Warehouse',
                                readOnly: true,
                                controller: TextEditingController(
                                    text: warehouses.firstWhere(
                                        (w) => w['id'] == selectedWarehouseId,
                                        orElse: () => {'name': ''})['name']),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        MoonDropdown(
                          show: showItemDropdown,
                          onTapOutside: () =>
                              setDialogState(() => showItemDropdown = false),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: availableItems.isEmpty
                                ? [
                                    const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('No items available'))
                                  ]
                                : availableItems.map((item) {
                                    return MoonMenuItem(
                                      onTap: () {
                                        setDialogState(() {
                                          selectedItemName = item['item_name'];
                                          unitController.text =
                                              item['unit'] ?? 'Bags';
                                          showItemDropdown = false;
                                        });
                                      },
                                      label: Text(
                                          '${item['item_name']} (Qty: ${item['quantity']})'),
                                    );
                                  }).toList(),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedWarehouseId != null) {
                                setDialogState(
                                    () => showItemDropdown = !showItemDropdown);
                              }
                            },
                            child: AbsorbPointer(
                              child: MoonTextInput(
                                hintText: 'Select Item',
                                readOnly: true,
                                controller: TextEditingController(
                                    text: selectedItemName ?? ''),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: MoonTextInput(
                                    hintText: 'Quantity',
                                    controller: qtyController,
                                    keyboardType: TextInputType.number)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: MoonTextInput(
                                    hintText: 'Unit',
                                    controller: unitController)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        MoonTextInput(
                            hintText: 'Destination Address',
                            controller: destinationController),
                        const SizedBox(height: 12),
                        MoonTextInput(
                            hintText: 'Driver Name',
                            controller: driverNameController),
                        const SizedBox(height: 12),
                        MoonTextInput(
                            hintText: 'Driver Phone',
                            controller: driverPhoneController),
                        const SizedBox(height: 12),
                        MoonTextInput(
                            hintText: 'Vehicle Number',
                            controller: vehicleNumberController),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text('Cancel'),
                  ),
                  AppButton.filled(
                    onTap: () async {
                      if (createdBy == null) return;
                      final qty = num.tryParse(qtyController.text) ?? 0;

                      if (selectedWarehouseId == null) {
                        MoonToast.show(context,
                            label: const Text('Please select a warehouse'));
                        return;
                      }
                      if (selectedItemName == null) {
                        MoonToast.show(context,
                            label: const Text('Please select an item'));
                        return;
                      }
                      if (qty <= 0) {
                        MoonToast.show(context,
                            label:
                                const Text('Quantity must be greater than 0'));
                        return;
                      }

                      final item = inventory.firstWhere((i) =>
                          i['warehouse_id'] == selectedWarehouseId &&
                          i['item_name'] == selectedItemName);
                      final available = item['quantity'] as num;

                      if (qty > available) {
                        MoonToast.show(context,
                            label: Text(
                                'Insufficient stock. Available: $available ${item['unit']}'));
                        return;
                      }

                      String driverPhone = driverPhoneController.text.trim();
                      if (driverPhone.startsWith('0')) {
                        driverPhone = '+234${driverPhone.substring(1)}';
                      }

                      final waybill = await cubit.generateWaybill(
                        warehouseId: selectedWarehouseId!,
                        destination: destinationController.text.trim(),
                        driverName: driverNameController.text.trim(),
                        driverPhone: driverPhone,
                        vehicleNumber: vehicleNumberController.text.trim(),
                        itemName: selectedItemName!,
                        quantity: qty,
                        unit: unitController.text.trim(),
                        createdBy: createdBy,
                      );

                      Navigator.pop(dialogCtx);
                      if (waybill != null) {
                        _downloadWaybillPDF(context, waybill);
                      }
                    },
                    label: const Text('Generate'),
                  ),
                ],
              );
            }));
  }

  void _showInventoryDetailDialog(
      BuildContext context, Map<String, dynamic> inv) {
    final cubit = context.read<InventoryManagementCubit>();
    cubit.fetchInventoryDetails(inv['id']);

    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<InventoryManagementCubit, InventoryManagementState>(
          builder: (context, state) {
            final allocations = state.selectedInventoryAllocations;
            final totalAllocated = allocations.fold<num>(
                0, (sum, item) => sum + (item['quantity'] as num? ?? 0));

            return AlertDialog(
              title: Text('Inventory Detail: ${inv['item_name']}'),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DetailInfo(label: 'Item Name', value: inv['item_name']),
                      DetailInfo(
                          label: 'Warehouse',
                          value: inv['warehouses']?['name'] ??
                              'Unknown Warehouse'),
                      DetailInfo(
                          label: 'State',
                          value: inv['warehouses']?['state'] ?? 'N/A'),
                      DetailInfo(
                          label: 'Address',
                          value: inv['warehouses']?['address'] ?? 'N/A'),
                      Row(
                        children: [
                          Expanded(
                            child: DetailInfo(
                                label: 'Quantity Available',
                                value: '${inv['quantity']} ${inv['unit']}'),
                          ),
                          Expanded(
                            child: DetailInfo(
                                label: 'Quantity Allocated',
                                value: '$totalAllocated ${inv['unit']}'),
                          ),
                        ],
                      ),
                      DetailInfo(
                          label: 'Price per Item',
                          value: inv['price_per_item'] != null
                              ? CurrencyUtils.formatNaira(inv['price_per_item'])
                              : 'Free'),
                      const SizedBox(height: 24),
                      Text('Allocation History & Associated Farmers',
                          style: context.moonTypography?.heading.text16),
                      const SizedBox(height: 12),
                      if (state.isLoading)
                        const Center(child: MoonCircularLoader())
                      else if (allocations.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(child: Text('No allocations found.')),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    context.moonColors?.beerus ?? Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allocations.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 0),
                            itemBuilder: (context, index) {
                              final alloc = allocations[index];
                              final app = alloc['applications'];
                              final farmerName = app != null
                                  ? '${app['first_name'] ?? ''} ${app['last_name'] ?? ''}'
                                  : 'Unknown Farmer';
                              final date = alloc['created_at'] != null
                                  ? DateFormat('MMM dd, yyyy HH:mm').format(
                                      DateTime.parse(alloc['created_at']))
                                  : '-';
                              final price = inv['price_per_item'] ?? 0;
                              final total =
                                  (alloc['quantity'] as num? ?? 0) * price;

                              return ListTile(
                                title: Text(farmerName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Allocated on: $date'),
                                    if (price > 0)
                                      Text(
                                          'Total Value: ${CurrencyUtils.formatNaira(total)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange)),
                                  ],
                                ),
                                trailing: Text(
                                  '${alloc['quantity']} ${inv['unit']}',
                                  style: context.moonTypography?.heading.text14,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
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

  void _downloadWaybillPDF(
      BuildContext context, Map<String, dynamic> waybillData) async {
    await WaybillPdfGenerator.generateAndDownload(waybillData);
  }
}
