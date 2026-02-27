import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/personal_info_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/date_of_birth_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/first_name_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/gender_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/last_name_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/lga_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/other_names_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/state_input.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/town_village_input.dart';
import 'package:moon_design/moon_design.dart';
import 'package:ui_library/ui_library.dart';

class PersonalInformationSection extends StatelessWidget {
  const PersonalInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.personalInformation,
            style: context.moonTypography?.heading.text20,
          ),
          const SizedBox(height: 16),
          BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
            buildWhen: (previous, current) =>
                previous.firstName != current.firstName ||
                previous.lastName != current.lastName ||
                previous.otherNames != current.otherNames ||
                previous.town != current.town,
            builder: (context, state) {
              final cubit = BlocProvider.of<PersonalInfoCubit>(context);
              return MoonTextInputGroup(
                children: [
                  FirstNameInput(
                    context: context,
                    state: state,
                    onChanged: cubit.firstNameChanged,
                  ),
                  LastNameInput(
                    context: context,
                    state: state,
                    onChanged: cubit.lastNameChanged,
                  ),
                  OtherNamesInput(
                    context: context,
                    state: state,
                    onChanged: cubit.otherNamesChanged,
                  ),
                  TownVillageInput(
                    context: context,
                    state: state,
                    onChanged: cubit.townChanged,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const StateInput(),
          const SizedBox(height: 16),
          const LgaInput(),
          const SizedBox(height: 16),
          const GenderInput(),
          const SizedBox(height: 16),
          const DateOfBirthInput(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
