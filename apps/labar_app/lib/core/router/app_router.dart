import 'package:auto_route/auto_route.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/core/router/auth_guard.dart';
import 'package:labar_app/core/session/session_cubit.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: OtpVerificationRoute.page),
        AutoRoute(page: SignUpVerificationRoute.page),
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          guards: [AuthGuard(getIt<SessionCubit>())],
        ),
        AutoRoute(page: ApplicationDetailsRoute.page),
        AutoRoute(page: ApplicationFormRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: AllocatedResourcesRoute.page),
        AutoRoute(page: AssignedWarehouseRoute.page),
      ];
}
