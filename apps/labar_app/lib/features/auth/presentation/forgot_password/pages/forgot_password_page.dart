import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/features/auth/presentation/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:labar_app/features/auth/presentation/forgot_password/cubit/forgot_password_state.dart';
import 'package:labar_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: context.l10n.backButton,
                      icon: const Icon(MoonIcons.arrows_left_24_regular),
                      onPressed: () => context.router.back(),
                    ),
                  ),
                  AuthHeaderWidget(
                    title: context.l10n.forgotPasswordTitle,
                    subtitle: context.l10n.forgotPasswordSubtitle,
                  ),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state.status == ForgotPasswordStatus.emailSent) {
                        context.router.push(
                          OtpVerificationRoute(
                              email: _emailController.text,
                              flowType: 'recovery'),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppFormTextInput(
                              controller: _emailController,
                              hintText: context.l10n.emailLabel,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  (value?.contains('@') ?? false)
                                      ? null
                                      : context.l10n.invalidEmail,
                              leading: const Icon(
                                  MoonIcons.mail_envelope_24_regular),
                            ),
                            const SizedBox(height: 24),
                            AppButton.filled(
                              isFullWidth: true,
                              isLoading:
                                  state.status == ForgotPasswordStatus.loading,
                              label: Text(context.l10n.sendRecoveryCodeButton),
                              onTap: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  BlocProvider.of<ForgotPasswordCubit>(context)
                                      .requestPasswordReset();
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            if (state.status ==
                                ForgotPasswordStatus.failure) ...[
                              MoonAlert(
                                show: state.status ==
                                    ForgotPasswordStatus.failure,
                                borderColor: context.moonColors!.chichi,
                                label: Text(
                                    state.errorMessage ?? context.l10n.error),
                                color: context.moonColors!.chichi
                                    .withValues(alpha: 0.1),
                                leading: const Icon(
                                    MoonIcons.controls_close_24_regular),
                                trailing: IconButton(
                                  icon: const Icon(
                                      MoonIcons.controls_close_24_regular),
                                  onPressed: () {
                                    BlocProvider.of<ForgotPasswordCubit>(
                                            context)
                                        .clearError();
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
