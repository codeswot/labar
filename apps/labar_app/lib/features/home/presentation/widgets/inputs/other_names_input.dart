import 'package:flutter/material.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:moon_design/moon_design.dart';

class OtherNamesInput extends MoonFormTextInput {
  OtherNamesInput({
    super.key,
    required BuildContext context,
    required PersonalInfoState state,
    required ValueChanged<String> onChanged,
  }) : super(
          hintText: context.l10n.otherNames,
          initialValue: state.otherNames.value,
          // Other names might be optional, or not. The original code checked isPure/isNotValid
          errorText: !state.otherNames.isPure && state.otherNames.isNotValid
              ? context.l10n.fieldRequired
              : null,
          onChanged: onChanged,
        );
}
