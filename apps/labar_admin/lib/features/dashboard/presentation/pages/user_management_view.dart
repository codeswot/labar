import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/cubit/user_management_cubit.dart';
import 'package:labar_admin/features/dashboard/presentation/widgets/detail_info.dart';
import 'package:labar_admin/features/auth/domain/entities/user_entity.dart';
import 'package:ui_library/ui_library.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => UserManagementViewState();
}

class UserManagementViewState extends State<UserManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _roleFilter;
  bool? _activeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<SessionCubit>().state.user;
    final callerRole = currentUser?.role;

    return BlocListener<UserManagementCubit, UserManagementState>(
      listener: (context, state) {
        if (state.error != null) {
          MoonToast.show(
            context,
            label: Text(state.error!),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User Management',
                    style: context.moonTypography?.heading.text24),
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: MoonTextInput(
                        controller: _searchController,
                        hintText: 'Search users...',
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
                    SizedBox(
                      width: 150,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _roleFilter,
                          hint: const Text('Role'),
                          isExpanded: true,
                          onChanged: (v) => setState(() => _roleFilter = v),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('All Roles')),
                            ...[
                              'super_admin',
                              'admin',
                              'agent',
                              'warehouse_manager',
                              'farmer'
                            ].map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(
                                    r.replaceAll('_', ' ').toUpperCase()))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 150,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<bool>(
                          value: _activeFilter,
                          hint: const Text('Status'),
                          isExpanded: true,
                          onChanged: (v) => setState(() => _activeFilter = v),
                          items: const [
                            DropdownMenuItem(
                                value: null, child: Text('All Status')),
                            DropdownMenuItem(
                                value: true, child: Text('ACTIVE')),
                            DropdownMenuItem(
                                value: false, child: Text('INACTIVE')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (callerRole == 'super_admin')
                      AppButton.filled(
                        isFullWidth: false,
                        onTap: () => _showAddUserDialog(context),
                        label: const Text('Add User'),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<UserManagementCubit, UserManagementState>(
                builder: (context, state) {
                  final users = state.users.where((user) {
                    // Filter by Role
                    if (_roleFilter != null &&
                        (user.role ?? '').toLowerCase() !=
                            _roleFilter!.toLowerCase()) {
                      return false;
                    }

                    // Filter by Active Status
                    if (_activeFilter != null &&
                        (user.active ?? true) != _activeFilter) {
                      return false;
                    }

                    if (_searchQuery.isEmpty) return true;

                    final firstName = (user.firstName ?? '').toLowerCase();
                    final lastName = (user.lastName ?? '').toLowerCase();
                    final email = (user.email ?? '').toLowerCase();
                    final role = (user.role ?? '').toLowerCase();

                    return firstName.contains(_searchQuery) ||
                        lastName.contains(_searchQuery) ||
                        email.contains(_searchQuery) ||
                        role.contains(_searchQuery);
                  }).toList();

                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 48, color: context.moonColors?.trunks),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No users found'
                                : 'No users found matching "$_searchQuery"',
                            style: context.moonTypography?.body.text16,
                          ),
                          if (state.error != null) ...[
                            const SizedBox(height: 16),
                            AppButton.filled(
                              label: const Text('Retry'),
                              onTap: () => context
                                  .read<UserManagementCubit>()
                                  .fetchUsers(),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: context.moonColors?.gohan,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: WidgetStateProperty.all(
                                context.moonColors?.goku),
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: users.map((user) {
                              final isActive = user.active ?? true;
                              final isMe = user.id == currentUser?.id;
                              final fullName = (user.firstName != null ||
                                      user.lastName != null)
                                  ? '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                      .trim()
                                  : '-';
                              return DataRow(
                                  onSelectChanged: (_) =>
                                      _showUserProfile(context, user),
                                  cells: [
                                    DataCell(Row(
                                      children: [
                                        Text(fullName),
                                        if (isMe) ...[
                                          const SizedBox(width: 8),
                                          MoonTag(
                                            label: const Text('ME'),
                                            tagSize: MoonTagSize.xs,
                                            backgroundColor: context
                                                .moonColors?.beerus
                                                .withValues(alpha: 0.5),
                                          ),
                                        ],
                                      ],
                                    )),
                                    DataCell(Text(user.email ?? '-')),
                                    DataCell(MoonTag(
                                      label: Text(
                                          user.role?.toUpperCase() ?? 'NONE'),
                                      tagSize: MoonTagSize.xs,
                                      backgroundColor: user.role ==
                                              'super_admin'
                                          ? Colors.purple.withValues(alpha: 0.2)
                                          : null,
                                    )),
                                    DataCell(Text(user.createdAt
                                        .toString()
                                        .split(' ')
                                        .first)),
                                    DataCell(
                                      callerRole == 'super_admin'
                                          ? MoonSwitch(
                                              value: isActive,
                                              onChanged: isMe
                                                  ? null
                                                  : (v) => context
                                                      .read<
                                                          UserManagementCubit>()
                                                      .toggleUserStatus(
                                                          user.id, v),
                                            )
                                          : MoonTag(
                                              label: Text(isActive
                                                  ? 'ACTIVE'
                                                  : 'INACTIVE'),
                                              tagSize: MoonTagSize.xs,
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                              backgroundColor: isActive
                                                  ? Colors.green
                                                      .withValues(alpha: 0.2)
                                                  : Colors.red
                                                      .withValues(alpha: 0.2),
                                            ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (callerRole == 'super_admin') ...[
                                            IconButton(
                                              icon: const Icon(Icons
                                                  .manage_accounts_outlined),
                                              tooltip: 'Change Role',
                                              onPressed: isMe
                                                  ? null
                                                  : () => _showRolePicker(
                                                      context, user),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red),
                                              tooltip: 'Delete User',
                                              onPressed: isMe
                                                  ? null
                                                  : () => _confirmDelete(
                                                      context, user),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserProfile(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('User Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailInfo(label: 'First Name', value: user.firstName ?? '-'),
            DetailInfo(label: 'Last Name', value: user.lastName ?? '-'),
            DetailInfo(label: 'Email', value: user.email ?? '-'),
            DetailInfo(label: 'Role', value: user.role?.toUpperCase() ?? '-'),
            DetailInfo(label: 'Created At', value: user.createdAt.toString()),
            DetailInfo(
                label: 'Status',
                value: (user.active ?? true) ? 'Active' : 'Inactive'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _showRolePicker(BuildContext context, dynamic user) {
    const roles = [
      'farmer',
      'agent',
      'warehouse_manager',
      'admin',
      'super_admin'
    ];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: roles
              .map((r) => ListTile(
                    title: Text(r.toUpperCase()),
                    trailing: r == user.role
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      context
                          .read<UserManagementCubit>()
                          .updateRole(user.id, r);
                      Navigator.pop(dialogContext);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.email}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<UserManagementCubit>().deleteUser(user.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    String selectedRole = 'agent';
    final callerRole = context.read<SessionCubit>().state.user?.role;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserManagementCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Internal User'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MoonTextInput(
                      controller: firstNameController, hintText: 'First Name'),
                  const SizedBox(height: 12),
                  MoonTextInput(
                      controller: lastNameController, hintText: 'Last Name'),
                  const SizedBox(height: 12),
                  MoonTextInput(controller: emailController, hintText: 'Email'),
                  const SizedBox(height: 12),
                  MoonTextInput(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(height: 12),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      isExpanded: true,
                      onChanged: (v) => setState(() => selectedRole = v!),
                      items: [
                        const DropdownMenuItem(
                            value: 'agent', child: Text('Agent')),
                        const DropdownMenuItem(
                            value: 'warehouse_manager',
                            child: Text('Warehouse Manager')),
                        if (callerRole == 'super_admin')
                          const DropdownMenuItem(
                              value: 'admin', child: Text('Admin')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel')),
              AppButton.filled(
                isFullWidth: false,
                onTap: () {
                  context.read<UserManagementCubit>().createUser(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        role: selectedRole,
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                      );
                  Navigator.pop(dialogContext);
                },
                label: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
