import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
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
                      const SizedBox(width: 16),
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
                      child: Text('Current Inventory Levels',
                          style: context.moonTypography?.heading.text18),
                    ),
                    const Divider(height: 0),
                    Builder(builder: (context) {
                      final filteredInventory = state.inventory.where((inv) {
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
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Unit')),
                        ],
                        rows: filteredInventory.map((inv) {
                          return DataRow(cells: [
                            DataCell(Text(inv['item_name'] ?? '')),
                            DataCell(Text(inv['warehouses']?['name'] ??
                                'Unknown Warehouse')),
                            DataCell(Text(inv['quantity'].toString())),
                            DataCell(Text(inv['unit'] ?? '')),
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
                      child: Text('Waybills Generated',
                          style: context.moonTypography?.heading.text18),
                    ),
                    const Divider(height: 0),
                    Builder(builder: (context) {
                      final filteredWaybills = state.waybills.where((wb) {
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

  void _showAddInventory(
      BuildContext context, List<Map<String, dynamic>> warehouses) {
    final cubit = context.read<InventoryManagementCubit>();
    String? selectedWarehouseId;
    final itemNameController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController();

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
                                label: Text(w['name'] ?? 'Unknown'),
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
                    if (qty > 0) {
                      if (selectedWarehouseId != null) {
                        cubit.addInventory(
                          warehouseId: selectedWarehouseId!,
                          itemName: itemNameController.text.trim(),
                          quantity: qty,
                          unit: unitController.text.trim(),
                        );
                        Navigator.pop(dialogCtx);
                      } else {
                        // Show slight error for selectedWarehouseId == null
                      }
                    } else {
                      // Show error for qty <= 0
                    }
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
                                label: Text(w['name'] ?? 'Unknown'),
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

                      if (qty > 0 &&
                          selectedWarehouseId != null &&
                          selectedItemName != null) {
                        final waybill = await cubit.generateWaybill(
                          warehouseId: selectedWarehouseId!,
                          destination: destinationController.text.trim(),
                          driverName: driverNameController.text.trim(),
                          driverPhone: driverPhoneController.text.trim(),
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
                      }
                    },
                    label: const Text('Generate'),
                  ),
                ],
              );
            }));
  }

  void _downloadWaybillPDF(
      BuildContext context, Map<String, dynamic> waybillData) async {
    await WaybillPdfGenerator.generateAndDownload(waybillData);
  }
}
