import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/searchable_dropdown_input.dart';
import 'package:moon_design/moon_design.dart';

class GenderInput extends StatelessWidget {
  const GenderInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        final cubit = BlocProvider.of<PersonalInfoCubit>(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.gender,
                style: context.moonTypography?.body.text16),
            const SizedBox(height: 8),
            SearchableDropdownInput(
              hintText: context.l10n.gender,
              initialValue: state.gender.value,
              items: const ['Male', 'Female'],
              errorText: !state.gender.isPure && state.gender.isNotValid
                  ? context.l10n.fieldRequired
                  : null,
              onChanged: cubit.genderChanged,
            ),
          ],
        );
      },
    );
  }
}
