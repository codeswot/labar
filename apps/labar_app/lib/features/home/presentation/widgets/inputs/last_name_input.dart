import 'package:flutter/material.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:moon_design/moon_design.dart';

class LastNameInput extends MoonFormTextInput {
  LastNameInput({
    super.key,
    required BuildContext context,
    required PersonalInfoState state,
    required ValueChanged<String> onChanged,
  }) : super(
          hintText: context.l10n.lastName,
          initialValue: state.lastName.value,
          errorText: !state.lastName.isPure && state.lastName.isNotValid
              ? context.l10n.fieldRequired
              : null,
          onChanged: onChanged,
        );
}
