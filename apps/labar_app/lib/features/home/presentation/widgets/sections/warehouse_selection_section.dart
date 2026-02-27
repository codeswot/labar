import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/domain/entities/warehouse_entity.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/warehouse_selection_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/warehouse_selection_state.dart';
import 'package:ui_library/ui_library.dart';

class WarehouseSelectionSection extends StatefulWidget {
  const WarehouseSelectionSection({super.key});

  @override
  State<WarehouseSelectionSection> createState() =>
      _WarehouseSelectionSectionState();
}

class _WarehouseSelectionSectionState extends State<WarehouseSelectionSection> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WarehouseSelectionCubit>()..loadWarehouses(),
      child: const _WarehouseSelectionContent(),
    );
  }
}

class _WarehouseSelectionContent extends StatelessWidget {
  const _WarehouseSelectionContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.selectWarehouse,
                style: context.moonTypography?.heading.text24,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.warehouseSelectionSubtitle,
                style: context.moonTypography?.body.text14.copyWith(
                  color: context.moonColors?.trunks,
                ),
              ),
              const SizedBox(height: 24),
              MoonTextInput(
                hintText: context.l10n.searchWarehouses,
                leading: const Icon(MoonIcons.generic_search_24_regular),
                onChanged: (v) =>
                    context.read<WarehouseSelectionCubit>().searchWarehouses(v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<WarehouseSelectionCubit, WarehouseSelectionState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: MoonCircularLoader());
              }

              if (state.error != null) {
                return Center(
                  child: AppErrorView(
                    onRetry: () => context
                        .read<WarehouseSelectionCubit>()
                        .loadWarehouses(),
                  ),
                );
              }

              if (state.filteredWarehouses.isEmpty) {
                return Center(
                  child: Text(context.l10n.noWarehousesFound),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.filteredWarehouses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final warehouse = state.filteredWarehouses[index];
                  final isSelected = context.select(
                    (ApplicationFormCubit cubit) =>
                        cubit.state.selectedWarehouse?.id == warehouse.id,
                  );

                  return _WarehouseCard(
                    warehouse: warehouse,
                    isSelected: isSelected,
                    onTap: () {
                      context
                          .read<ApplicationFormCubit>()
                          .selectWarehouse(warehouse);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WarehouseCard extends StatelessWidget {
  final WarehouseEntity warehouse;
  final bool isSelected;
  final VoidCallback onTap;

  const _WarehouseCard({
    required this.warehouse,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? context.moonColors?.piccolo
            : context.moonColors?.gohan,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? context.moonColors?.piccolo ?? Colors.blue
              : context.moonColors?.beerus ?? Colors.grey,
          width: 2,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: context.moonColors?.piccolo.withValues(alpha: 0.2) ??
                  Colors.blue.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: MoonMenuItem(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        label: Text(
          warehouse.name,
          style: context.moonTypography?.heading.text16.copyWith(
            color: isSelected
                ? context.moonColors?.goten
                : context.moonColors?.bulma,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          warehouse.location ?? '',
          style: context.moonTypography?.body.text12.copyWith(
            color: isSelected
                ? context.moonColors?.goten.withValues(alpha: 0.8)
                : context.moonColors?.trunks,
          ),
        ),
        trailing: isSelected
            ? Icon(
                MoonIcons.generic_check_alternative_24_regular,
                color: context.moonColors?.goten,
              )
            : null,
      ),
    );
  }
}
