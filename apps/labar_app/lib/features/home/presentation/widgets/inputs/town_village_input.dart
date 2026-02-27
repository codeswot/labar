import 'package:flutter/material.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:moon_design/moon_design.dart';

class TownVillageInput extends StatelessWidget {
  final BuildContext context;
  final PersonalInfoState state;
  final Function(String) onChanged;

  const TownVillageInput({
    super.key,
    required this.context,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MoonFormTextInput(
      hintText: context.l10n.village,
      initialValue: state.town.value,
      errorText: !state.town.isPure && state.town.isNotValid
          ? context.l10n.fieldRequired
          : null,
      onChanged: onChanged,
    );
  }
}
