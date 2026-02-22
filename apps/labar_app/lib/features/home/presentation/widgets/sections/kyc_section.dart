import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/kyc_details_cubit.dart';
import 'package:moon_design/moon_design.dart';

class KYCSection extends StatefulWidget {
  const KYCSection({super.key});

  @override
  State<KYCSection> createState() => _KYCSectionState();
}

class _KYCSectionState extends State<KYCSection> {
  bool _showDropdown = false;

  String _getKycLabel(BuildContext context, KycType type) {
    switch (type) {
      case KycType.nin:
        return context.l10n.nin;
      case KycType.bvn:
        return context.l10n.bvn;
      case KycType.internationalPassport:
        return context.l10n.internationalPassport;
      case KycType.votersCard:
        return context.l10n.votersCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycDetailsCubit, KycDetailsState>(
      buildWhen: (previous, current) =>
          previous.kycType != current.kycType ||
          previous.kycNumber != current.kycNumber,
      builder: (context, state) {
        final cubit = BlocProvider.of<KycDetailsCubit>(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.kycInformation,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              Text(context.l10n.idType,
                  style: context.moonTypography?.body.text12),
              const SizedBox(height: 8),
              MoonDropdown(
                show: _showDropdown,
                constrainWidthToChild: true,
                onTapOutside: () => setState(() => _showDropdown = false),
                content: Column(
                  children: KycType.values.map((type) {
                    return MoonMenuItem(
                      onTap: () {
                        setState(() => _showDropdown = false);
                        cubit.kycTypeChanged(type);
                      },
                      label: Text(_getKycLabel(context, type)),
                    );
                  }).toList(),
                ),
                child: MoonFormTextInput(
                  hintText: context.l10n.idType,
                  initialValue: state.kycType != null
                      ? _getKycLabel(context, state.kycType!)
                      : '',
                  readOnly: true,
                  onTap: () => setState(() => _showDropdown = !_showDropdown),
                  trailing: MoonButton.icon(
                    buttonSize: MoonButtonSize.xs,
                    hoverEffectColor: Colors.transparent,
                    onTap: () => setState(() => _showDropdown = !_showDropdown),
                    icon: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _showDropdown ? -0.5 : 0,
                      child:
                          const Icon(MoonIcons.controls_chevron_down_16_light),
                    ),
                  ),
                ),
              ),
              if (state.kycType != null) ...[
                const SizedBox(height: 16),
                Text(context.l10n.idNumber,
                    style: context.moonTypography?.body.text12),
                const SizedBox(height: 8),
                MoonFormTextInput(
                  hintText:
                      '${_getKycLabel(context, state.kycType!)} ${context.l10n.idNumber}',
                  initialValue: state.kycNumber.value,
                  onChanged: cubit.kycNumberChanged,
                  errorText:
                      !state.kycNumber.isPure && state.kycNumber.isNotValid
                          ? context.l10n.fieldRequired
                          : null,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
