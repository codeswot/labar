import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/features/home/presentation/cubit/application_form_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:labar_app/features/home/presentation/cubit/home_state.dart';
import 'package:labar_app/features/home/presentation/widgets/application_form.dart';
import 'package:labar_app/features/home/presentation/widgets/submitted_view.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/core/session/session_cubit.dart';
import 'package:labar_app/core/session/session_state.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ApplicationFormCubit _formCubit;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _formCubit = getIt<ApplicationFormCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final userId =
          BlocProvider.of<SessionCubit>(context).state.user?.id ?? '';
      if (userId.isNotEmpty) {
        _formCubit.init(userId);
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formCubit,
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: [
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              final user = state.user;
              final name = user?.email ?? 'User';
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Tooltip(
                  message: context.l10n.settings,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => context.router.push(const SettingsRoute()),
                    child: UserAvatar(name: name),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: MoonCircularLoader(),
            );
          }

          if (state.errorMessage != null) {
            return AppErrorView(
              subtitle: state.errorMessage!,
              onRetry: () => context.read<HomeCubit>().reset(),
            );
          }

          switch (state.view) {
            case HomeView.submitted:
              return const SubmittedView();
            case HomeView.form:
              return const ApplicationForm();
          }
        },
      ),
    );
  }
}
