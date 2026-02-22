part of 'kyc_details_cubit.dart';

@freezed
class KycDetailsState with _$KycDetailsState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory KycDetailsState({
    KycType? kycType,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput kycNumber,
  }) = _KycDetailsState;

  const KycDetailsState._();

  factory KycDetailsState.fromJson(Map<String, dynamic> json) =>
      _$KycDetailsStateFromJson(json);

  bool get isValid => kycType != null && Formz.validate([kycNumber]);
}
