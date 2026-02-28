import 'package:auto_route/auto_route.dart';
import '../session/session_cubit.dart';
import '../session/session_state.dart';
import 'app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final SessionCubit sessionCubit;

  AuthGuard(this.sessionCubit);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // Wait for initialization if status is unknown
    if (sessionCubit.state.status == SessionStatus.unknown) {
      await sessionCubit.stream
          .firstWhere((state) => state.status != SessionStatus.unknown);
    }

    final state = sessionCubit.state;
    if (state.status == SessionStatus.authenticated) {
      final role = state.user?.role;
      if (role == 'admin' ||
          role == 'super_admin' ||
          role == 'agent' ||
          role == 'warehouse_manager') {
        resolver.next(true);
      } else {
        router.push(const NotAuthorizedRoute());
      }
    } else {
      router.push(const SignInRoute());
    }
  }
}
