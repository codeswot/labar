import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/dashboard_overview_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/activity_item.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:ui_library/ui_library.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

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
                  StatCard(
                    title: 'Total Applications',
                    value: state.totalApplications.toString(),
                    icon: Icons.assignment_rounded,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 24),
                  StatCard(
                    title: 'Active Agents',
                    value: state.activeAgents.toString(),
                    icon: Icons.person_pin_rounded,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 24),
                  StatCard(
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
                              ActivityItem(
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
