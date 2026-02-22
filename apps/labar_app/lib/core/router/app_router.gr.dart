// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:labar_app/features/auth/presentation/forgot_password/pages/forgot_password_page.dart'
    as _i5;
import 'package:labar_app/features/auth/presentation/forgot_password/pages/otp_verification_page.dart'
    as _i7;
import 'package:labar_app/features/auth/presentation/sign_in/pages/sign_in_page.dart'
    as _i9;
import 'package:labar_app/features/auth/presentation/sign_up/pages/sign_up_page.dart'
    as _i10;
import 'package:labar_app/features/auth/presentation/sign_up/pages/sign_up_verification_page.dart'
    as _i11;
import 'package:labar_app/features/home/domain/entities/application_entity.dart'
    as _i14;
import 'package:labar_app/features/home/presentation/pages/allocated_resources_page.dart'
    as _i1;
import 'package:labar_app/features/home/presentation/pages/application_details_page.dart'
    as _i2;
import 'package:labar_app/features/home/presentation/pages/application_form_page.dart'
    as _i3;
import 'package:labar_app/features/home/presentation/pages/assigned_warehouse_page.dart'
    as _i4;
import 'package:labar_app/features/home/presentation/pages/home_page.dart'
    as _i6;
import 'package:labar_app/features/settings/presentation/pages/settings_page.dart'
    as _i8;

/// generated route for
/// [_i1.AllocatedResourcesPage]
class AllocatedResourcesRoute
    extends _i12.PageRouteInfo<AllocatedResourcesRouteArgs> {
  AllocatedResourcesRoute({
    _i13.Key? key,
    required String applicationId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         AllocatedResourcesRoute.name,
         args: AllocatedResourcesRouteArgs(
           key: key,
           applicationId: applicationId,
         ),
         initialChildren: children,
       );

  static const String name = 'AllocatedResourcesRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllocatedResourcesRouteArgs>();
      return _i1.AllocatedResourcesPage(
        key: args.key,
        applicationId: args.applicationId,
      );
    },
  );
}

class AllocatedResourcesRouteArgs {
  const AllocatedResourcesRouteArgs({this.key, required this.applicationId});

  final _i13.Key? key;

  final String applicationId;

  @override
  String toString() {
    return 'AllocatedResourcesRouteArgs{key: $key, applicationId: $applicationId}';
  }
}

/// generated route for
/// [_i2.ApplicationDetailsPage]
class ApplicationDetailsRoute
    extends _i12.PageRouteInfo<ApplicationDetailsRouteArgs> {
  ApplicationDetailsRoute({
    _i13.Key? key,
    required _i14.ApplicationEntity application,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         ApplicationDetailsRoute.name,
         args: ApplicationDetailsRouteArgs(key: key, application: application),
         initialChildren: children,
       );

  static const String name = 'ApplicationDetailsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ApplicationDetailsRouteArgs>();
      return _i2.ApplicationDetailsPage(
        key: args.key,
        application: args.application,
      );
    },
  );
}

class ApplicationDetailsRouteArgs {
  const ApplicationDetailsRouteArgs({this.key, required this.application});

  final _i13.Key? key;

  final _i14.ApplicationEntity application;

  @override
  String toString() {
    return 'ApplicationDetailsRouteArgs{key: $key, application: $application}';
  }
}

/// generated route for
/// [_i3.ApplicationFormPage]
class ApplicationFormRoute extends _i12.PageRouteInfo<void> {
  const ApplicationFormRoute({List<_i12.PageRouteInfo>? children})
    : super(ApplicationFormRoute.name, initialChildren: children);

  static const String name = 'ApplicationFormRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.ApplicationFormPage();
    },
  );
}

/// generated route for
/// [_i4.AssignedWarehousePage]
class AssignedWarehouseRoute
    extends _i12.PageRouteInfo<AssignedWarehouseRouteArgs> {
  AssignedWarehouseRoute({
    _i13.Key? key,
    required String applicationId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         AssignedWarehouseRoute.name,
         args: AssignedWarehouseRouteArgs(
           key: key,
           applicationId: applicationId,
         ),
         initialChildren: children,
       );

  static const String name = 'AssignedWarehouseRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AssignedWarehouseRouteArgs>();
      return _i4.AssignedWarehousePage(
        key: args.key,
        applicationId: args.applicationId,
      );
    },
  );
}

class AssignedWarehouseRouteArgs {
  const AssignedWarehouseRouteArgs({this.key, required this.applicationId});

  final _i13.Key? key;

  final String applicationId;

  @override
  String toString() {
    return 'AssignedWarehouseRouteArgs{key: $key, applicationId: $applicationId}';
  }
}

/// generated route for
/// [_i5.ForgotPasswordPage]
class ForgotPasswordRoute extends _i12.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i12.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomePage();
    },
  );
}

/// generated route for
/// [_i7.OtpVerificationPage]
class OtpVerificationRoute
    extends _i12.PageRouteInfo<OtpVerificationRouteArgs> {
  OtpVerificationRoute({
    _i13.Key? key,
    required String email,
    required String flowType,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         OtpVerificationRoute.name,
         args: OtpVerificationRouteArgs(
           key: key,
           email: email,
           flowType: flowType,
         ),
         initialChildren: children,
       );

  static const String name = 'OtpVerificationRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpVerificationRouteArgs>();
      return _i7.OtpVerificationPage(
        key: args.key,
        email: args.email,
        flowType: args.flowType,
      );
    },
  );
}

class OtpVerificationRouteArgs {
  const OtpVerificationRouteArgs({
    this.key,
    required this.email,
    required this.flowType,
  });

  final _i13.Key? key;

  final String email;

  final String flowType;

  @override
  String toString() {
    return 'OtpVerificationRouteArgs{key: $key, email: $email, flowType: $flowType}';
  }
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i12.PageRouteInfo<void> {
  const SettingsRoute({List<_i12.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsPage();
    },
  );
}

/// generated route for
/// [_i9.SignInPage]
class SignInRoute extends _i12.PageRouteInfo<void> {
  const SignInRoute({List<_i12.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.SignInPage();
    },
  );
}

/// generated route for
/// [_i10.SignUpPage]
class SignUpRoute extends _i12.PageRouteInfo<void> {
  const SignUpRoute({List<_i12.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.SignUpPage();
    },
  );
}

/// generated route for
/// [_i11.SignUpVerificationPage]
class SignUpVerificationRoute
    extends _i12.PageRouteInfo<SignUpVerificationRouteArgs> {
  SignUpVerificationRoute({
    _i13.Key? key,
    required String email,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         SignUpVerificationRoute.name,
         args: SignUpVerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'SignUpVerificationRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpVerificationRouteArgs>();
      return _i11.SignUpVerificationPage(key: args.key, email: args.email);
    },
  );
}

class SignUpVerificationRouteArgs {
  const SignUpVerificationRouteArgs({this.key, required this.email});

  final _i13.Key? key;

  final String email;

  @override
  String toString() {
    return 'SignUpVerificationRouteArgs{key: $key, email: $email}';
  }
}
