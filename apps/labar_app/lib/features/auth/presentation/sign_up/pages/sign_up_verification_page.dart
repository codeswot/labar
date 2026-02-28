import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_verification_cubit.dart';
import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_verification_state.dart';
import 'package:labar_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/core/router/app_router.gr.dart';

@RoutePage()
class SignUpVerificationPage extends StatefulWidget {
  final String email;

  const SignUpVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<SignUpVerificationPage> createState() => _SignUpVerificationPageState();
}

class _SignUpVerificationPageState extends State<SignUpVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpVerificationCubit>(),
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
                      icon: const Icon(MoonIcons.arrows_left_24_regular),
                      onPressed: () => context.router.back(),
                    ),
                  ),
                  AuthHeaderWidget(
                    title: context.l10n.verifyCodeTitle,
                    subtitle: context.l10n.verifyCodeSubtitle(widget.email),
                  ),
                  const SizedBox(height: 32),
                  BlocConsumer<SignUpVerificationCubit,
                      SignUpVerificationState>(
                    listener: (context, state) {
                      if (state.status == SignUpVerificationStatus.success) {
                        context.router.replaceAll([const HomeRoute()]);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          MoonAuthCode(
                            textController: _otpController,
                            validator: (String? value) => null,
                            errorBuilder:
                                (BuildContext context, String? errorText) =>
                                    Text(errorText ?? ''),
                            onCompleted: (code) {
                              BlocProvider.of<SignUpVerificationCubit>(context)
                                  .verifyOtp(widget.email, code);
                            },
                          ),
                          const SizedBox(height: 32),
                          AppButton.filled(
                            isFullWidth: true,
                            isLoading: state.status ==
                                SignUpVerificationStatus.verifying,
                            label: Text(context.l10n.verifyButton),
                            onTap: () {
                              if (_otpController.text.isNotEmpty) {
                                BlocProvider.of<SignUpVerificationCubit>(
                                        context)
                                    .verifyOtp(
                                        widget.email, _otpController.text);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          AppButton.plain(
                            isFullWidth: true,
                            onTap: state.resendCountdown > 0
                                ? null
                                : () {
                                    BlocProvider.of<SignUpVerificationCubit>(
                                            context)
                                        .resendOtp(widget.email);
                                    MoonToast.show(
                                      context,
                                      label: Text(context.l10n.codeResent),
                                    );
                                  },
                            label: state.resendCountdown > 0
                                ? Text.rich(
                                    TextSpan(
                                      text: context.l10n.sendRecoveryCodeButton,
                                      children: [
                                        TextSpan(
                                          text: ' (${state.resendCountdown}s)',
                                          style: TextStyle(
                                            color: context.moonColors?.piccolo,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(context.l10n.sendRecoveryCodeButton),
                          ),
                          if (state.status ==
                              SignUpVerificationStatus.failure) ...[
                            const SizedBox(height: 24),
                            MoonAlert(
                              show: state.status ==
                                  SignUpVerificationStatus.failure,
                              label: Text(state.errorMessage ??
                                  context.l10n.invalidCode),
                              backgroundColor: context.moonColors?.chichi
                                  .withValues(alpha: 0.1),
                              borderColor: context.moonColors?.chichi,
                              color: context.moonColors?.chichi,
                              leading: const Icon(
                                  MoonIcons.controls_close_24_regular),
                              trailing: IconButton(
                                icon: const Icon(
                                    MoonIcons.controls_close_24_regular),
                                onPressed: () {
                                  BlocProvider.of<SignUpVerificationCubit>(
                                          context)
                                      .clearError();
                                },
                              ),
                            ),
                          ],
                        ],
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
