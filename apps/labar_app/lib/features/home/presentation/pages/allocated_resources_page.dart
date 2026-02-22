import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/allocated_resources_cubit.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:ui_library/ui_library.dart';

@RoutePage()
class AllocatedResourcesPage extends StatelessWidget {
  final String applicationId;

  const AllocatedResourcesPage({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AllocatedResourcesCubit>()..watchResources(applicationId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.allocatedResources),
        ),
        body: BlocBuilder<AllocatedResourcesCubit, AllocatedResourcesState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: MoonCircularLoader()),
              loaded: (resources) {
                if (resources.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.noResourcesAllocated,
                      style: context.moonTypography?.body.text14,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: resources.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final resource = resources[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.moonColors?.gohan,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: resource.isCollected
                              ? context.moonColors?.roshi ?? Colors.green
                              : context.moonColors?.beerus ?? Colors.grey,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  resource.inventoryItem?['item_name'] ??
                                      resource.item ??
                                      'Unknown Item',
                                  style: context.moonTypography?.heading.text16,
                                ),
                              ),
                              MoonTag(
                                tagSize: MoonTagSize.sm,
                                backgroundColor: resource.isCollected
                                    ? context.moonColors?.roshi
                                        .withValues(alpha: 0.2)
                                    : context.moonColors?.beerus
                                        .withValues(alpha: 0.2),
                                label: Text(
                                  resource.isCollected
                                      ? context.l10n.collected.toUpperCase()
                                      : context.l10n.pending.toUpperCase(),
                                  style: TextStyle(
                                    color: resource.isCollected
                                        ? context.moonColors?.roshi
                                        : context.moonColors?.trunks,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.collectionAddress,
                            style: context.moonTypography?.body.text12.copyWith(
                              color: context.moonColors?.trunks,
                            ),
                          ),
                          Text(
                            resource.collectionAddress,
                            style: context.moonTypography?.body.text12,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Quantity Allocated',
                            style: context.moonTypography?.body.text12.copyWith(
                              color: context.moonColors?.trunks,
                            ),
                          ),
                          Text(
                            '${resource.quantity} ${resource.inventoryItem?['unit'] ?? ''}'
                                .trim(),
                            style: context.moonTypography?.body.text14,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (message) => AppErrorView(
                subtitle: message,
                onRetry: () => context
                    .read<AllocatedResourcesCubit>()
                    .watchResources(applicationId),
              ),
            );
          },
        ),
      ),
    );
  }
}
