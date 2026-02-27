part of 'personal_info_cubit.dart';

@freezed
class PersonalInfoState with _$PersonalInfoState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PersonalInfoState({
    @NameInputConverter() @Default(NameInput.pure()) NameInput firstName,
    @NameInputConverter() @Default(NameInput.pure()) NameInput lastName,
    @OptionalTextInputConverter()
    @Default(OptionalTextInput.pure())
    OptionalTextInput otherNames,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput gender,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput stateOfOrigin,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput lga,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput town,
    DateTime? dateOfBirth,
    @Default([]) List<String> availableStates,
    @Default([]) List<String> currentLgas,
  }) = _PersonalInfoState;

  const PersonalInfoState._();

  factory PersonalInfoState.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoStateFromJson(json);

  bool get isValid {
    final now = DateTime.now();
    bool strictAdult = false;
    if (dateOfBirth != null) {
      final age = now.year - dateOfBirth!.year;
      if (age > 18) {
        strictAdult = true;
      } else if (age == 18) {
        if (now.month > dateOfBirth!.month) {
          strictAdult = true;
        } else if (now.month == dateOfBirth!.month) {
          if (now.day >= dateOfBirth!.day) {
            strictAdult = true;
          }
        }
      }
    }

    return Formz.validate([
          firstName,
          lastName,
          gender,
          stateOfOrigin,
          lga,
          town,
        ]) &&
        strictAdult;
  }
}
