import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'package:ui_library/ui_library.dart';

@RoutePage()
class NotAuthorizedPage extends StatelessWidget {
  const NotAuthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Not Authorized',
              style: context.moonTypography?.heading.text24,
            ),
            const SizedBox(height: 8),
            Text(
              'You do not have permission to access this dashboard.',
              style: context.moonTypography?.body.text14,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: AppButton.outlined(
                onTap: () => context.read<SessionCubit>().signOut(),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
