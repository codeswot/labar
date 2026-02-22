import 'package:auto_route/auto_route.dart';
import 'package:labar_admin/core/di/injection.dart';
import 'package:labar_admin/core/router/auth_guard.dart';
import 'package:labar_admin/core/session/session_cubit.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: NotAuthorizedRoute.page),
        AutoRoute(
          page: DashboardRoute.page,
          initial: true,
          guards: [AuthGuard(getIt<SessionCubit>())],
        ),
      ];
}
