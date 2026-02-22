import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

MoonFormTextInput AppFormTextInput({
  Key? key,
  TextEditingController? controller,
  String? initialValue,
  ValueChanged<String>? onChanged,
  FormFieldValidator<String>? validator,
  String? hintText,
  String? errorText,
  bool obscureText = false,
  TextInputType? keyboardType,
  Widget? leading,
  Widget? trailing,
  bool enabled = true,
}) {
  return MoonFormTextInput(
    key: key,
    controller: controller,
    initialValue: initialValue,
    onChanged: onChanged,
    validator: validator,
    hintText: hintText,
    errorText: errorText,
    obscureText: obscureText,
    keyboardType: keyboardType,
    leading: leading,
    trailing: trailing,
    enabled: enabled,
    height: 50, // Enforcing default height
  );
}
