part of 'farm_details_cubit.dart';

@freezed
class FarmDetailsState with _$FarmDetailsState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FarmDetailsState({
    @NumberInputConverter() @Default(NumberInput.pure()) NumberInput farmSize,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput farmLocation,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput cropType,
    double? latitude,
    double? longitude,
    @Default([]) List<dynamic> farmPolygon,
    @Default(false) bool isFetchingLocation,
  }) = _FarmDetailsState;

  const FarmDetailsState._();

  factory FarmDetailsState.fromJson(Map<String, dynamic> json) =>
      _$FarmDetailsStateFromJson(json);

  bool get isValid =>
      Formz.validate([
        farmSize,
        farmLocation,
        cropType,
      ]) &&
      (latitude != null &&
          latitude! >= -90 &&
          latitude! <= 90 &&
          latitude! != 0) &&
      (longitude != null &&
          longitude! >= -180 &&
          longitude! <= 180 &&
          longitude! != 0);
}
