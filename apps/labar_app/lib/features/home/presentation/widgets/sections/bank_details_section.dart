import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/bank_details_cubit.dart';
import 'package:moon_design/moon_design.dart';
import 'package:ui_library/ui_library.dart';

class BankDetailsSection extends StatelessWidget {
  const BankDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankDetailsCubit, BankDetailsState>(
      buildWhen: (previous, current) =>
          previous.bankName != current.bankName ||
          previous.accountNumber != current.accountNumber ||
          previous.accountName != current.accountName,
      builder: (context, state) {
        final cubit = BlocProvider.of<BankDetailsCubit>(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.bankDetails,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              MoonTextInputGroup(
                children: [
                  MoonFormTextInput(
                    hintText: context.l10n.accountNumber,
                    initialValue: state.accountNumber.value,
                    keyboardType: TextInputType.number,
                    onChanged: cubit.accountNumberChanged,
                    // Optional, so no error text usually unless strict pattern
                    errorText: !state.accountNumber.isPure &&
                            state.accountNumber.isNotValid
                        ? 'Invalid'
                        : null,
                  ),
                  MoonFormTextInput(
                    hintText: context.l10n.bankName,
                    initialValue: state.bankName.value,
                    onChanged: cubit.bankNameChanged,
                  ),
                  MoonFormTextInput(
                    hintText: context.l10n.accountName,
                    initialValue: state.accountName.value,
                    onChanged: cubit.accountNameChanged,
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
