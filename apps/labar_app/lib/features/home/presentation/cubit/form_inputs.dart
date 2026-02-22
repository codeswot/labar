import 'package:formz/formz.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:formz/formz.dart';

// --- Generic Required String ---
enum RequiredTextInputError { empty }

class RequiredTextInput extends FormzInput<String, RequiredTextInputError> {
  const RequiredTextInput.pure() : super.pure('');
  const RequiredTextInput.dirty([super.value = '']) : super.dirty();

  @override
  RequiredTextInputError? validator(String value) {
    return value.isNotEmpty ? null : RequiredTextInputError.empty;
  }
}

class RequiredTextInputConverter
    implements JsonConverter<RequiredTextInput, String> {
  const RequiredTextInputConverter();

  @override
  RequiredTextInput fromJson(String json) => RequiredTextInput.dirty(json);

  @override
  String toJson(RequiredTextInput object) => object.value;
}

// --- Generic Optional String ---
enum OptionalTextInputError { invalid }

class OptionalTextInput extends FormzInput<String, OptionalTextInputError> {
  const OptionalTextInput.pure() : super.pure('');
  const OptionalTextInput.dirty([super.value = '']) : super.dirty();

  @override
  OptionalTextInputError? validator(String value) {
    return null;
  }
}

class OptionalTextInputConverter
    implements JsonConverter<OptionalTextInput, String> {
  const OptionalTextInputConverter();

  @override
  OptionalTextInput fromJson(String json) => OptionalTextInput.dirty(json);

  @override
  String toJson(OptionalTextInput object) => object.value;
}

// --- Name Input (Min 2 chars) ---
enum NameInputError { empty, tooShort }

class NameInput extends FormzInput<String, NameInputError> {
  const NameInput.pure() : super.pure('');
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameInputError? validator(String value) {
    if (value.isEmpty) return NameInputError.empty;
    if (value.trim().length < 2) return NameInputError.tooShort;
    return null;
  }
}

class NameInputConverter implements JsonConverter<NameInput, String> {
  const NameInputConverter();
  @override
  NameInput fromJson(String json) => NameInput.dirty(json);
  @override
  String toJson(NameInput object) => object.value;
}

// --- Phone Number Input ---
enum PhoneNumberInputError { empty, invalid }

class PhoneNumberInput extends FormzInput<String, PhoneNumberInputError> {
  const PhoneNumberInput.pure() : super.pure('');
  const PhoneNumberInput.dirty([super.value = '']) : super.dirty();

  static final _phoneRegex = RegExp(r'^\d{10,15}$');

  @override
  PhoneNumberInputError? validator(String value) {
    if (value.isEmpty) return PhoneNumberInputError.empty;
    if (!_phoneRegex.hasMatch(value)) return PhoneNumberInputError.invalid;
    return null;
  }
}

class PhoneNumberInputConverter
    implements JsonConverter<PhoneNumberInput, String> {
  const PhoneNumberInputConverter();
  @override
  PhoneNumberInput fromJson(String json) => PhoneNumberInput.dirty(json);
  @override
  String toJson(PhoneNumberInput object) => object.value;
}

// --- Number Input (Double) ---
enum NumberInputError { empty, invalid }

class NumberInput extends FormzInput<String, NumberInputError> {
  const NumberInput.pure() : super.pure('');
  const NumberInput.dirty([super.value = '']) : super.dirty();

  @override
  NumberInputError? validator(String value) {
    if (value.isEmpty) return NumberInputError.empty;
    if (double.tryParse(value) == null) return NumberInputError.invalid;
    return null;
  }
}

class NumberInputConverter implements JsonConverter<NumberInput, String> {
  const NumberInputConverter();
  @override
  NumberInput fromJson(String json) => NumberInput.dirty(json);
  @override
  String toJson(NumberInput object) => object.value;
}

// --- Optional Bank Account Number ---
enum BankAccountInputError { invalid }

class BankAccountInput extends FormzInput<String, BankAccountInputError> {
  const BankAccountInput.pure() : super.pure('');
  const BankAccountInput.dirty([super.value = '']) : super.dirty();

  static final _accountRegex = RegExp(r'^\d{10}$');

  @override
  BankAccountInputError? validator(String value) {
    if (value.isEmpty) return null; // Optional
    if (!_accountRegex.hasMatch(value)) return BankAccountInputError.invalid;
    return null;
  }
}

class BankAccountInputConverter
    implements JsonConverter<BankAccountInput, String> {
  const BankAccountInputConverter();
  @override
  BankAccountInput fromJson(String json) => BankAccountInput.dirty(json);
  @override
  String toJson(BankAccountInput object) => object.value;
}
