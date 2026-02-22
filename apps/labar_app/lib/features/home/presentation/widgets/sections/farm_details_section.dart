import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labar_app/core/extensions/localization_extension.dart';
import 'package:labar_app/features/home/presentation/cubit/sections/farm_details_cubit.dart';
import 'package:labar_app/features/home/presentation/widgets/farm_map_selector.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:ui_library/ui_library.dart';

class FarmDetailsSection extends StatefulWidget {
  const FarmDetailsSection({super.key});

  @override
  State<FarmDetailsSection> createState() => _FarmDetailsSectionState();
}

class _FarmDetailsSectionState extends State<FarmDetailsSection> {
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _farmSizeController;

  @override
  void initState() {
    super.initState();
    final state = context.read<FarmDetailsCubit>().state;
    _latitudeController =
        TextEditingController(text: state.latitude?.toString() ?? '');
    _longitudeController =
        TextEditingController(text: state.longitude?.toString() ?? '');
    _farmSizeController = TextEditingController(text: state.farmSize.value);
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  Future<void> _openMapSelector() async {
    final cubit = context.read<FarmDetailsCubit>();
    final currentPolygon = cubit.state.farmPolygon;

    // Restore any previously traced points
    final initialPoints = currentPolygon
        .map((p) => ll.LatLng(
              (p['lat'] as num).toDouble(),
              (p['lng'] as num).toDouble(),
            ))
        .toList();

    final result = await context.router.pushNativeRoute<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => FarmMapSelector(initialPoints: initialPoints),
      ),
    );

    if (result != null && mounted) {
      final area = result['area'] as double;
      final points = (result['points'] as List<ll.LatLng>)
          .map((p) => {'lat': p.latitude, 'lng': p.longitude})
          .toList();

      final formattedArea = area.toStringAsFixed(2);
      _farmSizeController.text = formattedArea;
      cubit.farmSizeChanged(formattedArea);
      cubit.farmPolygonChanged(points);

      // If we have at least one point, also update the primary lat/lng
      if (points.isNotEmpty) {
        cubit.coordinatesChanged(
          points.first['lat']!,
          points.first['lng']!,
        );
      }
    }
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
          previous.isFetchingLocation != current.isFetchingLocation ||
          previous.farmPolygon != current.farmPolygon,
      builder: (context, state) {
        final cubit = BlocProvider.of<FarmDetailsCubit>(context);
        final hasPolygon = state.farmPolygon.isNotEmpty;
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
              // Farm size row with mapping button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MoonFormTextInput(
                      controller: _farmSizeController,
                      hintText: context.l10n.farmSizeHectares,
                      keyboardType: TextInputType.number,
                      errorText:
                          !state.farmSize.isPure && state.farmSize.isNotValid
                              ? context.l10n.fieldRequired
                              : null,
                      onChanged: cubit.farmSizeChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Trace farm on map',
                    child: MoonButton.icon(
                      onTap: _openMapSelector,
                      icon: Icon(
                        hasPolygon ? Icons.map_rounded : Icons.map_outlined,
                        color: hasPolygon
                            ? context.moonColors?.piccolo
                            : context.moonColors?.trunks,
                      ),
                    ),
                  ),
                ],
              ),
              if (hasPolygon)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          size: 14, color: context.moonColors?.piccolo),
                      const SizedBox(width: 4),
                      Text(
                        '${state.farmPolygon.length} points mapped',
                        style: context.moonTypography?.body.text12
                            .copyWith(color: context.moonColors?.piccolo),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              MoonFormTextInput(
                hintText: context.l10n.farmDescription,
                initialValue: state.farmLocation.value,
                errorText:
                    !state.farmLocation.isPure && state.farmLocation.isNotValid
                        ? context.l10n.fieldRequired
                        : null,
                onChanged: cubit.farmLocationChanged,
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
