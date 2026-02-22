import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/presentation/cubit/form_inputs.dart';

part 'farm_details_state.dart';
part 'farm_details_cubit.freezed.dart';
part 'farm_details_cubit.g.dart';

@injectable
class FarmDetailsCubit extends HydratedCubit<FarmDetailsState> {
  FarmDetailsCubit() : super(const FarmDetailsState());

  void init({
    String? farmSize,
    String? farmLocation,
    String? cropType,
    double? latitude,
    double? longitude,
  }) {
    emit(state.copyWith(
      farmSize: farmSize != null && farmSize.isNotEmpty
          ? NumberInput.dirty(farmSize)
          : const NumberInput.pure(),
      farmLocation: farmLocation != null && farmLocation.isNotEmpty
          ? RequiredTextInput.dirty(farmLocation)
          : const RequiredTextInput.pure(),
      cropType: cropType != null && cropType.isNotEmpty
          ? RequiredTextInput.dirty(cropType)
          : const RequiredTextInput.pure(),
      latitude: latitude,
      longitude: longitude,
    ));
  }

  void farmSizeChanged(String value) {
    emit(state.copyWith(farmSize: NumberInput.dirty(value)));
  }

  void farmLocationChanged(String value) {
    emit(state.copyWith(farmLocation: RequiredTextInput.dirty(value)));
  }

  void cropTypeChanged(String value) {
    emit(state.copyWith(cropType: RequiredTextInput.dirty(value)));
  }

  void coordinatesChanged(double lat, double lng) {
    emit(state.copyWith(latitude: lat, longitude: lng));
  }

  void farmPolygonChanged(List<Map<String, dynamic>> points) {
    emit(state.copyWith(farmPolygon: points));
  }

  Future<void> fetchCurrentLocation() async {
    emit(state.copyWith(isFetchingLocation: true));
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(isFetchingLocation: false));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(isFetchingLocation: false));
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        isFetchingLocation: false,
      ));
    } catch (e) {
      emit(state.copyWith(isFetchingLocation: false));
    }
  }

  @override
  FarmDetailsState? fromJson(Map<String, dynamic> json) {
    try {
      return FarmDetailsState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(FarmDetailsState state) => state.toJson();
}
