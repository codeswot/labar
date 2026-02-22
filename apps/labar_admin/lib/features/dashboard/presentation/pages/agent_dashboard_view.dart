import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/agent_cubit.dart';
import 'package:ui_library/ui_library.dart';

class AgentDashboardView extends StatelessWidget {
  const AgentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AgentCubit>()..watchApplications(),
      child: const _AgentApplicationsList(),
    );
  }
}

class _AgentApplicationsList extends StatelessWidget {
  const _AgentApplicationsList();

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
              Text('My Created Applications',
                  style: context.moonTypography?.heading.text24),
              const Text('Filtered to only your entries',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<AgentCubit, AgentState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: MoonCircularLoader());
                }
                if (state.error != null) {
                  return AppErrorView(
                    onRetry: () =>
                        context.read<AgentCubit>().watchApplications(),
                  );
                }

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.moonColors?.gohan,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(context.moonColors?.goku),
                      columns: const [
                        DataColumn(label: Text('Reg No')),
                        DataColumn(label: Text('Farmer Name')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: state.applications.map((app) {
                        return DataRow(cells: [
                          DataCell(Text(app['reg_no'] ?? '-')),
                          DataCell(
                              Text('${app['first_name']} ${app['last_name']}')),
                          DataCell(MoonTag(
                            label: Text(
                                app['status']?.toString().toUpperCase() ??
                                    'NONE'),
                            tagSize: MoonTagSize.xs,
                          )),
                          DataCell(Text(app['phone_number'] ?? '-')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () {}, // TODO: Edit Form
                              ),
                              IconButton(
                                icon: const Icon(Icons.file_upload_outlined,
                                    size: 18),
                                onPressed: () {}, // TODO: Upload Files
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 18),
                                onPressed: () => context
                                    .read<AgentCubit>()
                                    .deleteApplication(app['id']),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
