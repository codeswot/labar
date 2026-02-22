import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/farm_details_cubit.dart';
import 'package:ui_library/ui_library.dart';

class FarmDetailsSection extends StatefulWidget {
  const FarmDetailsSection({super.key});

  @override
  State<FarmDetailsSection> createState() => _FarmDetailsSectionState();
}

class _FarmDetailsSectionState extends State<FarmDetailsSection> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    final state = context.read<FarmDetailsCubit>().state;
    _latitudeController =
        TextEditingController(text: state.latitude?.toString() ?? '');
    _longitudeController =
        TextEditingController(text: state.longitude?.toString() ?? '');
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FarmDetailsCubit, FarmDetailsState>(
      listener: (context, state) {
        if (state.latitude?.toString() != _latitudeController.text) {
          _latitudeController.text = state.latitude?.toString() ?? '';
        }
        if (state.longitude?.toString() != _longitudeController.text) {
          _longitudeController.text = state.longitude?.toString() ?? '';
        }
      },
      buildWhen: (previous, current) =>
          previous.cropType != current.cropType ||
          previous.farmSize != current.farmSize ||
          previous.farmLocation != current.farmLocation ||
          previous.isFetchingLocation != current.isFetchingLocation,
      builder: (context, state) {
        final cubit = BlocProvider.of<FarmDetailsCubit>(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.farmDetailsAndLocation,
                style: context.moonTypography?.heading.text20,
              ),
              const SizedBox(height: 16),
              MoonFormTextInput(
                hintText: context.l10n.cropType,
                initialValue: state.cropType.value,
                errorText: !state.cropType.isPure && state.cropType.isNotValid
                    ? context.l10n.fieldRequired
                    : null,
                onChanged: cubit.cropTypeChanged,
              ),
              const SizedBox(height: 16),
              MoonTextInputGroup(
                children: [
                  MoonFormTextInput(
                    hintText: context.l10n.farmSizeHectares,
                    initialValue: state.farmSize.value,
                    keyboardType: TextInputType.number,
                    errorText:
                        !state.farmSize.isPure && state.farmSize.isNotValid
                            ? context.l10n.fieldRequired
                            : null,
                    onChanged: cubit.farmSizeChanged,
                  ),
                  MoonFormTextInput(
                    hintText: context.l10n.farmDescription,
                    initialValue: state.farmLocation.value,
                    errorText: !state.farmLocation.isPure &&
                            state.farmLocation.isNotValid
                        ? context.l10n.fieldRequired
                        : null,
                    onChanged: cubit.farmLocationChanged,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MoonTextInputGroup(children: [
                MoonFormTextInput(
                  controller: _latitudeController,
                  hintText: context.l10n.latitude,
                  readOnly: true,
                  leading: const Icon(Icons.location_on),
                  onTap: () {},
                ),
                MoonFormTextInput(
                  controller: _longitudeController,
                  hintText: context.l10n.longitude,
                  readOnly: true,
                  leading: const Icon(Icons.location_on),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 8),
              AppButton.filled(
                label: state.isFetchingLocation
                    ? MoonCircularLoader(
                        color: context.moonColors!.goten,
                      )
                    : Text(context.l10n.getCurrentLocation),
                onTap: state.isFetchingLocation
                    ? null
                    : () => cubit.fetchCurrentLocation(),
              ),
            ],
          ),
        );
      },
    );
  }
}
