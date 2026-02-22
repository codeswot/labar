import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/contact_info_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/inputs/contact_input.dart';
import 'package:moon_design/moon_design.dart';
import 'package:ui_library/ui_library.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';

class ContactInformationSection extends StatelessWidget {
  const ContactInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactInfoCubit, ContactInfoState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber ||
          previous.nextOfKinName != current.nextOfKinName ||
          previous.nextOfKinPhone != current.nextOfKinPhone ||
          previous.nextOfKinRelationship != current.nextOfKinRelationship,
      builder: (context, state) {
        final cubit = BlocProvider.of<ContactInfoCubit>(context);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.contactInformation,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              ContactInput(
                hintText: context.l10n.phoneNumber,
                initialValue: state.phoneNumber.value,
                leadingIcon: Icons.phone,
                onChanged: cubit.phoneNumberChanged,
                errorText:
                    !state.phoneNumber.isPure && state.phoneNumber.isNotValid
                        ? 'Required'
                        : null,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.nextOfKin,
                style: context.moonTypography?.heading.text16,
              ),
              const SizedBox(height: 8),
              MoonTextInputGroup(
                children: [
                  ContactInput(
                    hintText: context.l10n.fullName,
                    initialValue: state.nextOfKinName.value,
                    pickNameAndPhone: true,
                    isNameField: true,
                    onContactPicked: (name, phone) {
                      cubit.nextOfKinNameChanged(name);
                      cubit.nextOfKinPhoneChanged(phone);
                    },
                    onChanged: cubit.nextOfKinNameChanged,
                    errorText: !state.nextOfKinName.isPure &&
                            state.nextOfKinName.isNotValid
                        ? context.l10n.fieldRequired
                        : null,
                  ),
                  ContactInput(
                    hintText: context.l10n.phoneNumber,
                    initialValue: state.nextOfKinPhone.value,
                    onChanged: cubit.nextOfKinPhoneChanged,
                    errorText: !state.nextOfKinPhone.isPure &&
                            state.nextOfKinPhone.isNotValid
                        ? context.l10n.fieldRequired
                        : null,
                  ),
                  MoonFormTextInput(
                    hintText: context.l10n.relationship,
                    initialValue: state.nextOfKinRelationship.value,
                    errorText: !state.nextOfKinRelationship.isPure &&
                            state.nextOfKinRelationship.isNotValid
                        ? context.l10n.fieldRequired
                        : null,
                    onChanged: cubit.nextOfKinRelationshipChanged,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
