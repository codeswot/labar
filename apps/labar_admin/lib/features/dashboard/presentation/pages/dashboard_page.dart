import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/core/session/session_state.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/admin_dashboard_view.dart';
import 'package:labar_admin/features/dashboard/presentation/pages/agent_dashboard_view.dart';
import 'package:ui_library/ui_library.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        final user = state.user;
        final role = user?.role;
        final isAdmin = role == 'admin' || role == 'super_admin';

        return Scaffold(
          body: Row(
            children: [
              // Sidebar
              Container(
                width: 260,
                color: context.moonColors?.gohan,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          const MoonAvatar(
                            content: Icon(Icons.dashboard_rounded),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Labar Admin',
                            style: context.moonTypography?.heading.text18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (isAdmin) ...[
                      _SidebarItem(
                        label: 'Overview',
                        icon: Icons.grid_view_rounded,
                        selected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      _SidebarItem(
                        label: 'Applications',
                        icon: Icons.assignment_rounded,
                        selected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                      _SidebarItem(
                        label: 'User Management',
                        icon: Icons.people_alt_rounded,
                        selected: _selectedIndex == 2,
                        onTap: () => setState(() => _selectedIndex = 2),
                      ),
                      _SidebarItem(
                        label: 'Inventory',
                        icon: Icons.inventory_2_rounded,
                        selected: _selectedIndex == 3,
                        onTap: () => setState(() => _selectedIndex = 3),
                      ),
                    ] else ...[
                      _SidebarItem(
                        label: 'My Applications',
                        icon: Icons.list_alt_rounded,
                        selected: true,
                        onTap: () {},
                      ),
                    ],
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.moonColors?.goku,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const MoonAvatar(
                              content: Icon(Icons.person),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user?.email?.split('@').first ?? 'User',
                                    style:
                                        context.moonTypography?.heading.text14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    role?.toUpperCase() ?? 'NONE',
                                    style: context.moonTypography?.body.text10,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  context.read<SessionCubit>().signOut(),
                              icon: const Icon(Icons.logout, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Container(
                  color: context.moonColors?.goku,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isAdmin
                        ? AdminDashboardView(index: _selectedIndex)
                        : const AgentDashboardView(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? context.moonColors?.piccolo.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? context.moonColors?.piccolo
                    : context.moonColors?.bulma,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: context.moonTypography?.body.text14.copyWith(
                  color: selected
                      ? context.moonColors?.piccolo
                      : context.moonColors?.bulma,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
