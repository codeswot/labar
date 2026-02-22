import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/di/injection.dart';
import 'package:labar_app/features/auth/presentation/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:labar_app/features/auth/presentation/forgot_password/cubit/forgot_password_state.dart';
import 'package:labar_app/features/auth/presentation/widgets/auth_header_widget.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

@RoutePage()
class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String flowType;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.flowType,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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
                      icon: const Icon(MoonIcons.arrows_left_24_regular),
                      onPressed: () => context.router.back(),
                    ),
                  ),
                  AuthHeaderWidget(
                    title: context.l10n.verifyCodeTitle,
                    subtitle: context.l10n.verifyCodeSubtitle(widget.email),
                  ),
                  const SizedBox(height: 32),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state.status == ForgotPasswordStatus.success) {
                        context.router.popUntilRoot();
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
                              BlocProvider.of<ForgotPasswordCubit>(context)
                                  .verifyOtp(widget.email, code);
                            },
                          ),
                          const SizedBox(height: 32),
                          AppButton.filled(
                            isFullWidth: true,
                            isLoading: state.status ==
                                ForgotPasswordStatus.verifyingOtp,
                            label: Text(context.l10n.verifyButton),
                            onTap: () {
                              if (_otpController.text.isNotEmpty) {
                                BlocProvider.of<ForgotPasswordCubit>(context)
                                    .verifyOtp(
                                        widget.email, _otpController.text);
                              }
                            },
                          ),
                          if (state.status == ForgotPasswordStatus.failure) ...[
                            const SizedBox(height: 24),
                            MoonAlert(
                              label: Text(state.errorMessage ??
                                  context.l10n.invalidCode),
                              borderColor: context.moonColors!.chichi,
                              color: context.moonColors!.chichi
                                  .withValues(alpha: 0.1),
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
