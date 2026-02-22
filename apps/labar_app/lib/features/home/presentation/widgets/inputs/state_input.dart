import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/searchable_dropdown_input.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StateInput extends StatelessWidget {
  const StateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      buildWhen: (previous, current) =>
          previous.stateOfOrigin != current.stateOfOrigin ||
          previous.availableStates != current.availableStates,
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.availableStates.isEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.state,
                  style: context.moonTypography?.body.text12),
              const SizedBox(height: 8),
              SearchableDropdownInput(
                hintText: context.l10n.state,
                initialValue: state.stateOfOrigin.value,
                items: state.availableStates,
                errorText: !state.stateOfOrigin.isPure &&
                        state.stateOfOrigin.isNotValid
                    ? context.l10n.fieldRequired
                    : null,
                onChanged: BlocProvider.of<PersonalInfoCubit>(context)
                    .stateOfOriginChanged,
              ),
            ],
          ),
        );
      },
    );
  }
}
