import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/utils/currency_utils.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/item_management_cubit.dart';
import 'package:ui_library/ui_library.dart';

class ItemManagementView extends StatefulWidget {
  const ItemManagementView({super.key});

  @override
  State<ItemManagementView> createState() => _ItemManagementViewState();
}

class _ItemManagementViewState extends State<ItemManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemManagementCubit, ItemManagementState>(
      listener: (context, state) {
        if (state.error != null) {
          MoonToast.show(context, label: Text(state.error!));
        }
      },
      builder: (context, state) {
        final filteredItems = state.items.where((item) {
          if (_searchQuery.isEmpty) return true;
          final name = (item['name'] ?? '').toString().toLowerCase();
          final location = (item['location'] ?? '').toString().toLowerCase();
          return name.contains(_searchQuery) || location.contains(_searchQuery);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item Management',
                      style: context.moonTypography?.heading.text24),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: MoonTextInput(
                          controller: _searchController,
                          hintText: 'Search items...',
                          leading: const Icon(Icons.search),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () => _showItemDialog(context),
                        label: const Text('Add Item'),
                      ),
                    ],
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
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: WidgetStateProperty.all(
                                context.moonColors?.goku),
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Location')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: filteredItems.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item['name'] ?? 'N/A')),
                                  DataCell(Text(item['unit'] ?? 'N/A')),
                                  DataCell(Text(CurrencyUtils.formatNaira(
                                      item['price'] ?? 0))),
                                  DataCell(Text(item['location'] ?? 'N/A')),
                                  DataCell(Text(item['description'] ?? 'N/A')),
                                  DataCell(Text(item['created_at'] != null
                                      ? item['created_at']
                                          .toString()
                                          .split('T')
                                          .first
                                      : 'N/A')),
                                  DataCell(Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () => _showItemDialog(
                                            context,
                                            item: item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            size: 20, color: Colors.red),
                                        onPressed: () =>
                                            _showDeleteConfirm(context, item),
                                      ),
                                    ],
                                  )),
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

  void _showItemDialog(BuildContext context, {Map<String, dynamic>? item}) {
    final nameController = TextEditingController(text: item?['name']);
    final unitController = TextEditingController(text: item?['unit']);
    final priceController =
        TextEditingController(text: item?['price']?.toString());
    final locationController = TextEditingController(text: item?['location']);
    final descController = TextEditingController(text: item?['description']);

    final cubit = context.read<ItemManagementCubit>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(item == null ? 'Add New Item' : 'Edit Item'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MoonTextInput(
                controller: nameController,
                hintText: 'Item Name (e.g. Maize, Fertilizer)',
              ),
              const SizedBox(height: 12),
              MoonTextInput(
                controller: unitController,
                hintText: 'Unit (e.g. 50kg bag, Liters)',
              ),
              const SizedBox(height: 12),
              MoonTextInput(
                controller: priceController,
                hintText: 'Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              MoonTextInput(
                controller: locationController,
                hintText: 'Location/Origin',
              ),
              const SizedBox(height: 12),
              MoonTextInput(
                controller: descController,
                hintText: 'Description',
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
            isFullWidth: false,
            label: Text(item == null ? 'Add Item' : 'Update Item'),
            onTap: () {
              final name = nameController.text;
              final unit = unitController.text;
              final price = num.tryParse(priceController.text) ?? 0;
              final location = locationController.text;
              final description = descController.text;

              if (name.isNotEmpty && unit.isNotEmpty && location.isNotEmpty) {
                if (item == null) {
                  cubit.addItem(
                    name: name,
                    unit: unit,
                    price: price,
                    location: location,
                    description: description,
                  );
                } else {
                  cubit.updateItem(
                    id: item['id'],
                    name: name,
                    unit: unit,
                    price: price,
                    location: location,
                    description: description,
                  );
                }
                Navigator.pop(dialogCtx);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, Map<String, dynamic> item) {
    final cubit = context.read<ItemManagementCubit>();
    showDialog(
      context: context,
      builder: (dialogCtx) => MoonModal(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              const Text('Delete Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                  'Are you sure you want to delete "${item['name']}"? This might affect existing inventory records.'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.filled(
                      backgroundColor: Colors.red,
                      label: const Text('Delete'),
                      onTap: () {
                        cubit.deleteItem(item['id']);
                        Navigator.pop(dialogCtx);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
