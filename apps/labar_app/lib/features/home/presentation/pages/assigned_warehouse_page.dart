import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/assigned_warehouse_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/assigned_warehouse_state.dart';
import 'package:labar_app/core/utils/currency_utils.dart';
import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';
import 'package:ui_library/ui_library.dart';

@RoutePage()
class AssignedWarehousePage extends StatelessWidget {
  final String applicationId;

  const AssignedWarehousePage({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AssignedWarehouseCubit>()..watchDesignation(applicationId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.assignedWarehouse),
        ),
        body: BlocBuilder<AssignedWarehouseCubit, AssignedWarehouseState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: MoonCircularLoader()),
              loaded: (designation) {
                if (designation == null ||
                    designation.warehouseDetails == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warehouse_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.noWarehouseAssigned,
                          style: context.moonTypography?.body.text16.copyWith(
                            color: context.moonColors?.trunks,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.warehouseAssignmentInstruction,
                          textAlign: TextAlign.center,
                          style: context.moonTypography?.body.text14.copyWith(
                            color: context.moonColors?.trunks,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final warehouse = designation.warehouseDetails!;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.moonColors?.gohan,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.warehouse,
                              size: 64,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              warehouse.name,
                              style: context.moonTypography?.heading.text20,
                              textAlign: TextAlign.center,
                            ),
                            if (designation.note != null &&
                                designation.note!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                designation.note!,
                                style: context.moonTypography?.body.text14
                                    .copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: context.moonColors?.trunks,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.warehouseInformation,
                        style: context.moonTypography?.heading.text16.copyWith(
                          color: context.moonColors?.piccolo,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.location_on_outlined,
                        label: context.l10n.address,
                        value:
                            '${warehouse.state ?? ''}${(warehouse.state != null && (warehouse.address != null || warehouse.location != null)) ? '\n' : ''}${warehouse.address ?? warehouse.location ?? 'Not specified'}',
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.phone_outlined,
                        label: context.l10n.phoneNumber,
                        value: warehouse.contactNumber ?? 'Not specified',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Allocated Resources',
                        style: context.moonTypography?.heading.text16.copyWith(
                          color: context.moonColors?.piccolo,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (designation.allocatedResources.isEmpty)
                        Text(
                          'No resources allocated yet.',
                          style: context.moonTypography?.body.text14.copyWith(
                            color: context.moonColors?.trunks,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: designation.allocatedResources.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final res = designation.allocatedResources[index];
                            return _ResourceTile(resource: res);
                          },
                        ),
                      const SizedBox(height: 32),
                      Divider(color: context.moonColors?.beerus),
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.instruction,
                        style: context.moonTypography?.heading.text16,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.warehouseProceedInstruction,
                        style: context.moonTypography?.body.text14.copyWith(
                          color: context.moonColors?.trunks,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.moonColors?.krillin
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.moonColors?.krillin ?? Colors.orange,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.l10n.warehouseBagRecordInstruction,
                                style: context.moonTypography?.body.text14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (message) => AppErrorView(
                subtitle: context.l10n.errorOccurred,
                onRetry: () => context
                    .read<AssignedWarehouseCubit>()
                    .watchDesignation(applicationId),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final AllocatedResourceEntity resource;

  const _ResourceTile({required this.resource});

  @override
  Widget build(BuildContext context) {
    final isCollected = resource.isCollected == true;

    final inv = resource.inventoryItem;
    final item = inv?['items'];
    final price = item?['price'] ?? 0;
    final total = resource.quantity * price;
    final unit = item?['unit'] ?? inv?['unit'] ?? '';

    final itemName =
        inv?['item_name'] ?? item?['name'] ?? resource.item ?? 'Unknown Item';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.moonColors?.goku,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCollected
              ? Colors.green.withValues(alpha: 0.3)
              : context.moonColors?.beerus ?? Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isCollected ? Colors.green : Colors.blue)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCollected
                  ? Icons.check_circle_outline
                  : Icons.inventory_2_outlined,
              color: isCollected ? Colors.green : Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: context.moonTypography?.body.text16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Quantity: ${resource.quantity} $unit'.trim(),
                  style: context.moonTypography?.body.text12.copyWith(
                    color: context.moonColors?.trunks,
                  ),
                ),
                Text(
                  price > 0
                      ? 'Price: ${CurrencyUtils.formatNaira(price)} | Total: ${CurrencyUtils.formatNaira(total)}'
                      : 'Free',
                  style: context.moonTypography?.body.text12.copyWith(
                    color: context.moonColors?.roshi ?? Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  resource.collectionAddress ?? '',
                  style: context.moonTypography?.body.text12.copyWith(
                    color: context.moonColors?.trunks,
                  ),
                ),
              ],
            ),
          ),
          if (isCollected)
            MoonTag(
              label: const Text('COLLECTED'),
              tagSize: MoonTagSize.xs,
              backgroundColor: Colors.green.withValues(alpha: 0.2),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.moonColors?.trunks),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.moonTypography?.body.text12.copyWith(
                color: context.moonColors?.trunks,
              ),
            ),
            Text(
              value,
              style: context.moonTypography?.body.text14.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
