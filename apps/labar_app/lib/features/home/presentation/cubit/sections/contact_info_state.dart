part of 'contact_info_cubit.dart';

@freezed
class ContactInfoState with _$ContactInfoState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ContactInfoState({
    @PhoneNumberInputConverter()
    @Default(PhoneNumberInput.pure())
    PhoneNumberInput phoneNumber,
    @NameInputConverter() @Default(NameInput.pure()) NameInput nextOfKinName,
    @PhoneNumberInputConverter()
    @Default(PhoneNumberInput.pure())
    PhoneNumberInput nextOfKinPhone,
    @RequiredTextInputConverter()
    @Default(RequiredTextInput.pure())
    RequiredTextInput nextOfKinRelationship,
    @Default('') String userId,
  }) = _ContactInfoState;

  const ContactInfoState._();

  factory ContactInfoState.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoStateFromJson(json);

  bool get isValid => Formz.validate([
        phoneNumber,
        nextOfKinName,
        nextOfKinPhone,
        nextOfKinRelationship,
      ]);
}
