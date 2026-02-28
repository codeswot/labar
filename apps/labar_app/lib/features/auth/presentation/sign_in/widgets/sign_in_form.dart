import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:labar_app/core/router/app_router.gr.dart';
import 'package:labar_app/features/auth/presentation/sign_in/cubit/sign_in_cubit.dart';
import 'package:labar_app/features/auth/presentation/sign_in/cubit/sign_in_state.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MoonTextInputGroup(
              orientation: MoonTextInputGroupOrientation.vertical,
              children: [
                if (!state.usePhone)
                  AppFormTextInput(
                    initialValue: state.email.value,
                    onChanged: (value) => BlocProvider.of<SignInCubit>(context)
                        .emailChanged(value),
                    hintText: context.l10n.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    errorText: state.email.displayError != null
                        ? context.l10n.invalidEmail
                        : null,
                    leading: const Icon(MoonIcons.mail_envelope_24_regular),
                  )
                else
                  AppFormTextInput(
                    initialValue: state.phone.value,
                    onChanged: (value) => BlocProvider.of<SignInCubit>(context)
                        .phoneChanged(value),
                    hintText: context.l10n.phoneLabel,
                    keyboardType: TextInputType.phone,
                    errorText: state.phone.displayError != null
                        ? context.l10n.invalidPhone
                        : null,
                    leading: const Icon(MoonIcons.devices_phone_24_regular),
                  ),
                AppFormTextInput(
                  initialValue: state.password.value,
                  onChanged: (value) => BlocProvider.of<SignInCubit>(context)
                      .passwordChanged(value),
                  hintText: context.l10n.passwordLabel,
                  obscureText: _obscurePassword,
                  errorText: state.password.displayError != null
                      ? context.l10n.invalidPassword
                      : null,
                  leading: const Icon(MoonIcons.security_lock_24_regular),
                  trailing: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(_obscurePassword
                        ? MoonIcons.controls_eye_24_regular
                        : MoonIcons.controls_eye_crossed_24_regular),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.plain(
                  onTap: () =>
                      BlocProvider.of<SignInCubit>(context).toggleAuthMode(),
                  label: Text(
                    state.usePhone
                        ? context.l10n.useEmail
                        : context.l10n.usePhone,
                    style: TextStyle(color: context.moonColors?.piccolo),
                  ),
                  isFullWidth: false,
                ),
                AppButton.plain(
                  onTap: () {
                    context.router.push(const ForgotPasswordRoute());
                  },
                  label: Text(context.l10n.forgotPasswordLink),
                  isFullWidth: false,
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton.filled(
              isFullWidth: true,
              label: state.status == SignInStatus.inProgress
                  ? const MoonCircularLoader()
                  : Text(context.l10n.signInButton),
              onTap: state.isValid && state.status != SignInStatus.inProgress
                  ? () => BlocProvider.of<SignInCubit>(context).signIn()
                  : null,
            ),
          ],
        );
      },
    );
  }
}
