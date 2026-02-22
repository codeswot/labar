import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/presentation/cubit/form_inputs.dart';

part 'contact_info_state.dart';
part 'contact_info_cubit.freezed.dart';
part 'contact_info_cubit.g.dart';

@injectable
class ContactInfoCubit extends HydratedCubit<ContactInfoState> {
  ContactInfoCubit() : super(const ContactInfoState());

  void init({
    String? phoneNumber,
    String? nextOfKinName,
    String? nextOfKinPhone,
    String? nextOfKinRelationship,
  }) {
    emit(state.copyWith(
      phoneNumber: phoneNumber != null && phoneNumber.isNotEmpty
          ? PhoneNumberInput.dirty(phoneNumber)
          : const PhoneNumberInput.pure(),
      nextOfKinName: nextOfKinName != null && nextOfKinName.isNotEmpty
          ? NameInput.dirty(nextOfKinName)
          : const NameInput.pure(),
      nextOfKinPhone: nextOfKinPhone != null && nextOfKinPhone.isNotEmpty
          ? PhoneNumberInput.dirty(nextOfKinPhone)
          : const PhoneNumberInput.pure(),
      nextOfKinRelationship:
          nextOfKinRelationship != null && nextOfKinRelationship.isNotEmpty
              ? RequiredTextInput.dirty(nextOfKinRelationship)
              : const RequiredTextInput.pure(),
    ));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(phoneNumber: PhoneNumberInput.dirty(value)));
  }

  void nextOfKinNameChanged(String value) {
    emit(state.copyWith(nextOfKinName: NameInput.dirty(value)));
  }

  void nextOfKinPhoneChanged(String value) {
    emit(state.copyWith(nextOfKinPhone: PhoneNumberInput.dirty(value)));
  }

  void nextOfKinRelationshipChanged(String value) {
    emit(state.copyWith(nextOfKinRelationship: RequiredTextInput.dirty(value)));
  }

  @override
  ContactInfoState? fromJson(Map<String, dynamic> json) {
    try {
      return ContactInfoState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContactInfoState state) => state.toJson();
}
