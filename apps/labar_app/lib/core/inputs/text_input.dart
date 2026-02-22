import 'package:formz/formz.dart';

enum TextInputValidationError { empty }

class TextInput extends FormzInput<String, TextInputValidationError> {
  const TextInput.pure() : super.pure('');
  const TextInput.dirty([super.value = '']) : super.dirty();

  @override
  TextInputValidationError? validator(String value) {
    return value.isNotEmpty ? null : TextInputValidationError.empty;
  }
}
