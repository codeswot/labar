// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:labar_admin/features/auth/presentation/pages/not_authorized_page.dart'
    as _i2;
import 'package:labar_admin/features/auth/presentation/pages/sign_in_page.dart'
    as _i3;
import 'package:labar_admin/features/dashboard/presentation/pages/dashboard_page.dart'
    as _i1;

/// generated route for
/// [_i1.DashboardPage]
class DashboardRoute extends _i4.PageRouteInfo<void> {
  const DashboardRoute({List<_i4.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardPage();
    },
  );
}

/// generated route for
/// [_i2.NotAuthorizedPage]
class NotAuthorizedRoute extends _i4.PageRouteInfo<void> {
  const NotAuthorizedRoute({List<_i4.PageRouteInfo>? children})
    : super(NotAuthorizedRoute.name, initialChildren: children);

  static const String name = 'NotAuthorizedRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.NotAuthorizedPage();
    },
  );
}

/// generated route for
/// [_i3.SignInPage]
class SignInRoute extends _i4.PageRouteInfo<void> {
  const SignInRoute({List<_i4.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.SignInPage();
    },
  );
}
