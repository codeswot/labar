import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:labar_app/features/auth/presentation/sign_up/cubit/sign_up_state.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MoonTextInputGroup(
              orientation: MoonTextInputGroupOrientation.vertical,
              children: [
                AppFormTextInput(
                  initialValue: state.email.value,
                  onChanged: (value) =>
                      BlocProvider.of<SignUpCubit>(context).emailChanged(value),
                  hintText: context.l10n.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  errorText: state.email.displayError != null
                      ? context.l10n.invalidEmail
                      : null,
                  leading: const Icon(MoonIcons.mail_envelope_24_regular),
                ),
                AppFormTextInput(
                  initialValue: state.password.value,
                  onChanged: (value) => BlocProvider.of<SignUpCubit>(context)
                      .passwordChanged(value),
                  hintText: context.l10n.passwordLabel,
                  obscureText: _obscurePassword,
                  errorText: state.password.displayError != null
                      ? context.l10n.passwordTooShort
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
                AppFormTextInput(
                  initialValue: state.confirmedPassword.value,
                  onChanged: (value) => BlocProvider.of<SignUpCubit>(context)
                      .confirmedPasswordChanged(value),
                  hintText: context.l10n.confirmPasswordLabel,
                  obscureText: _obscurePassword,
                  errorText: state.confirmedPassword.displayError != null
                      ? context.l10n.passwordMismatch
                      : null,
                  leading: const Icon(MoonIcons.security_lock_24_regular),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton.filled(
              isFullWidth: true,
              label: state.status.isInProgress
                  ? const MoonCircularLoader()
                  : Text(context.l10n.createAccountButton),
              onTap: state.isValid && !state.status.isInProgress
                  ? () => BlocProvider.of<SignUpCubit>(context).signUp()
                  : null,
            ),
          ],
        );
      },
    );
  }
}
