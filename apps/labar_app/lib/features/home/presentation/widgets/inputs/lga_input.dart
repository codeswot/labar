import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/searchable_dropdown_input.dart';
import 'package:moon_design/moon_design.dart';

class LgaInput extends StatelessWidget {
  const LgaInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      buildWhen: (previous, current) =>
          previous.lga != current.lga ||
          previous.currentLgas != current.currentLgas ||
          previous.stateOfOrigin != current.stateOfOrigin,
      builder: (context, state) {
        final cubit = BlocProvider.of<PersonalInfoCubit>(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.localGovernment,
                style: context.moonTypography?.body.text12),
            const SizedBox(height: 8),
            _buildInput(context, state, cubit),
          ],
        );
      },
    );
  }

  Widget _buildInput(
      BuildContext context, PersonalInfoState state, PersonalInfoCubit cubit) {
    if (state.stateOfOrigin.value.isEmpty) {
      return MoonFormTextInput(
        hintText: context.l10n.localGovernment,
        readOnly: true,
        enabled: false,
      );
    }

    if (state.currentLgas.isEmpty) {
      // It might be loading, or just empty.
      // If state of origin is selected but currentLgas is empty, it might be loading.
      // But we don't have explicit loading state here, relying on list emptiness.
      // Ideally we should have Loading status. For now, following previous logic.
      return const Center(child: MoonCircularLoader());
    }

    return SearchableDropdownInput(
      hintText: context.l10n.localGovernment,
      initialValue: state.lga.value,
      items: state.currentLgas,
      errorText: !state.lga.isPure && state.lga.isNotValid
          ? context.l10n.fieldRequired
          : null,
      onChanged: cubit.lgaChanged,
    );
  }
}
