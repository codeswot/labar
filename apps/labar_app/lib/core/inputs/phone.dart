import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty([super.value = '']) : super.dirty();

  @override
  PhoneValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return null;
    // Basic phone validation: at least 7 digits
    return value.length >= 7 ? null : PhoneValidationError.invalid;
  }
}
