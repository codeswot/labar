import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/router/app_router.gr.dart';

import 'package:labar_app/features/auth/presentation/sign_in/cubit/sign_in_cubit.dart';
import 'package:labar_app/features/auth/presentation/sign_in/cubit/sign_in_state.dart';
import 'package:labar_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:labar_app/features/auth/presentation/sign_in/widgets/sign_in_form.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignInCubit>(),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.success) {
            context.router.replace(const HomeRoute());
          } else if (state.status == SignInStatus.emailNotVerified) {
            context.router.push(
              SignUpVerificationRoute(email: state.email.value),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthHeaderWidget(
                        title: context.l10n.signInTitle,
                        subtitle: context.l10n.signInSubtitle,
                      ),
                      const SizedBox(height: 32),
                      const SignInForm(),
                      const SizedBox(height: 24),
                      AppButton.plain(
                        onTap: () {
                          context.router.push(const SignUpRoute());
                        },
                        label: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: context.l10n.dontHaveAccount),
                              TextSpan(
                                text: ' ${context.l10n.signUpButton}',
                                style: TextStyle(
                                  color: context.moonColors?.piccolo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isFullWidth: true,
                      ),
                      if (state.status == SignInStatus.failure) ...[
                        const SizedBox(height: 24),
                        MoonAlert(
                          show: state.status == SignInStatus.failure,
                          label: Text(state.errorMessage ??
                              context.l10n.authenticationFailed),
                          backgroundColor:
                              context.moonColors?.chichi.withValues(alpha: 0.1),
                          borderColor: context.moonColors?.chichi,
                          color: context.moonColors?.chichi,
                          leading:
                              const Icon(MoonIcons.controls_close_24_regular),
                          trailing: IconButton(
                            icon:
                                const Icon(MoonIcons.controls_close_24_regular),
                            onPressed: () {
                              BlocProvider.of<SignInCubit>(context)
                                  .clearError();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
