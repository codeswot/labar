import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_state.dart';
import 'package:labar_app/features/auth/presentation/sign_up/widgets/sign_up_form.dart';
import 'package:labar_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            context.router
                .replace(SignUpVerificationRoute(email: state.email.value));
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
                        title: context.l10n.signUpTitle,
                        subtitle: context.l10n.signUpSubtitle,
                      ),
                      const SizedBox(height: 32),
                      const SignUpForm(),
                      const SizedBox(height: 24),
                      if (state.status.isFailure) ...[
                        MoonAlert(
                          show: state.status.isFailure,
                          label: Text(state.errorMessage ??
                              context.l10n.registrationFailed),
                          leading:
                              const Icon(MoonIcons.controls_close_24_regular),
                          backgroundColor:
                              context.moonColors!.chichi.withValues(alpha: 0.1),
                          color: context.moonColors?.chichi,
                          borderColor: context.moonColors!.chichi,
                          trailing: IconButton(
                            icon:
                                const Icon(MoonIcons.controls_close_24_regular),
                            onPressed: () {
                              BlocProvider.of<SignUpCubit>(context).clearError();
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      AppButton.plain(
                        onTap: () {
                          context.router.replace(SignInRoute());
                        },
                        label: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: context.l10n.alreadyHaveAccount),
                              TextSpan(
                                text: ' ${context.l10n.signInButton}',
                                style: TextStyle(
                                  color: context.moonColors?.piccolo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isFullWidth: false,
                      ),
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
