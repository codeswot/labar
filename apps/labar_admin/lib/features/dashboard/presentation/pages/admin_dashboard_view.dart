import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/application_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/dashboard_overview_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/user_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/inventory_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/dashboard_overview_view.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/application_management_view.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/user_management_view.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/inventory_management_view.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/warehouse_management_view.dart';

import 'package:labar_admin/features/dashboard/presentation/cubit/item_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/item_management_view.dart';

class AdminDashboardView extends StatelessWidget {
  final int index;
  final Function(int)? onIndexChanged;
  const AdminDashboardView(
      {super.key, required this.index, this.onIndexChanged});

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
        BlocProvider(create: (context) => getIt<ItemManagementCubit>()..init()),
      ],
      child: _buildContent(index),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return const DashboardOverview();
      case 1:
        return const ApplicationManagementView();
      case 2:
        return const UserManagementView();
      case 3:
        return const InventoryManagementView();
      case 4:
        return WarehouseManagementView(
            onNavigateToInventory: () => onIndexChanged?.call(3));
      case 5:
        return const ItemManagementView();
      default:
        return const DashboardOverview();
    }
  }
}
