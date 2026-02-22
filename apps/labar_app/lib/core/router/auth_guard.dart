import 'dart:async';
import 'package:auto_route/auto_route.dart';
import '../../core/session/session_cubit.dart';
import '../../core/session/session_state.dart';
import 'app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final SessionCubit sessionCubit;

  AuthGuard(this.sessionCubit);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (sessionCubit.state.status == SessionStatus.authenticated) {
      resolver.next(true);
    } else if (sessionCubit.state.status == SessionStatus.unknown) {
      late final StreamSubscription subscription;
      subscription = sessionCubit.stream.listen((state) {
        if (state.status != SessionStatus.unknown) {
          subscription.cancel();
          if (state.status == SessionStatus.authenticated) {
            resolver.next(true);
          } else {
            router.push(const SignInRoute());
          }
        }
      });
    } else {
      router.push(const SignInRoute());
    }
  }
}
