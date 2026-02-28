// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankDetailsStateImpl _$$BankDetailsStateImplFromJson(
        Map<String, dynamic> json) =>
    _$BankDetailsStateImpl(
      bankName: json['bank_name'] == null
          ? const OptionalTextInput.pure()
          : const OptionalTextInputConverter()
              .fromJson(json['bank_name'] as String),
      accountNumber: json['account_number'] == null
          ? const BankAccountInput.pure()
          : const BankAccountInputConverter()
              .fromJson(json['account_number'] as String),
      accountName: json['account_name'] == null
          ? const OptionalTextInput.pure()
          : const OptionalTextInputConverter()
              .fromJson(json['account_name'] as String),
      userId: json['user_id'] as String? ?? '',
    );

Map<String, dynamic> _$$BankDetailsStateImplToJson(
        _$BankDetailsStateImpl instance) =>
    <String, dynamic>{
      'bank_name': const OptionalTextInputConverter().toJson(instance.bankName),
      'account_number':
          const BankAccountInputConverter().toJson(instance.accountNumber),
      'account_name':
          const OptionalTextInputConverter().toJson(instance.accountName),
      'user_id': instance.userId,
    };
