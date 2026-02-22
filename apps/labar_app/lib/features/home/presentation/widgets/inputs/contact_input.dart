import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:moon_design/moon_design.dart';

class ContactInput extends MoonFormTextInput {
  ContactInput({
    super.key,
    required String super.hintText,
    super.initialValue,
    required ValueChanged<String> super.onChanged,
    super.errorText,
    IconData? leadingIcon,
    bool pickNameAndPhone = false,
    bool isNameField = false,
    Function(String name, String phone)? onContactPicked,
  }) : super(
          keyboardType: isNameField ? TextInputType.text : TextInputType.phone,
          leading: leadingIcon != null ? Icon(leadingIcon) : null,
          trailing: MoonButton.icon(
            buttonSize: MoonButtonSize.xs,
            hoverEffectColor: Colors.transparent,
            onTap: () async {
              final FlutterNativeContactPicker contactPicker =
                  FlutterNativeContactPicker();
              try {
                final Contact? contact = await contactPicker.selectContact();
                if (contact != null) {
                  String phone = '';
                  if (contact.phoneNumbers != null &&
                      contact.phoneNumbers!.isNotEmpty) {
                    phone = contact.phoneNumbers!.first;
                  }

                  if (pickNameAndPhone && onContactPicked != null) {
                    onContactPicked(contact.fullName ?? '', phone);
                  } else {
                    onChanged(phone);
                  }
                }
              } catch (e) {
                debugPrint('Contact picker error: $e');
              }
            },
            icon: const Icon(Icons.contacts),
          ),
        );
}
