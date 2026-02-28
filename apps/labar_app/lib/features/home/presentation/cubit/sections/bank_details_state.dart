part of 'bank_details_cubit.dart';

@freezed
class BankDetailsState with _$BankDetailsState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BankDetailsState({
    @OptionalTextInputConverter()
    @Default(OptionalTextInput.pure())
    OptionalTextInput bankName,
    @BankAccountInputConverter()
    @Default(BankAccountInput.pure())
    BankAccountInput accountNumber,
    @OptionalTextInputConverter()
    @Default(OptionalTextInput.pure())
    OptionalTextInput accountName,
    @Default('') String userId,
  }) = _BankDetailsState;

  const BankDetailsState._();

  factory BankDetailsState.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsStateFromJson(json);

  bool get isValid {
    final hasDetails = accountNumber.value.isNotEmpty ||
        bankName.value.isNotEmpty ||
        accountName.value.isNotEmpty;
    if (!hasDetails) return true; // entirely optional

    return Formz.validate([accountNumber]) &&
        bankName.value.isNotEmpty &&
        accountName.value.isNotEmpty;
  }
}
