import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/presentation/cubit/form_inputs.dart';

part 'bank_details_state.dart';
part 'bank_details_cubit.freezed.dart';
part 'bank_details_cubit.g.dart';

@injectable
class BankDetailsCubit extends HydratedCubit<BankDetailsState> {
  BankDetailsCubit() : super(const BankDetailsState());

  void init({
    String? bankName,
    String? accountNumber,
    String? accountName,
  }) {
    emit(state.copyWith(
      bankName: bankName != null && bankName.isNotEmpty
          ? OptionalTextInput.dirty(bankName)
          : const OptionalTextInput.pure(),
      accountNumber: accountNumber != null && accountNumber.isNotEmpty
          ? BankAccountInput.dirty(accountNumber)
          : const BankAccountInput.pure(),
      accountName: accountName != null && accountName.isNotEmpty
          ? OptionalTextInput.dirty(accountName)
          : const OptionalTextInput.pure(),
    ));
  }

  void bankNameChanged(String value) {
    emit(state.copyWith(bankName: OptionalTextInput.dirty(value)));
  }

  void accountNumberChanged(String value) {
    emit(state.copyWith(accountNumber: BankAccountInput.dirty(value)));
  }

  void accountNameChanged(String value) {
    emit(state.copyWith(accountName: OptionalTextInput.dirty(value)));
  }

  @override
  BankDetailsState? fromJson(Map<String, dynamic> json) {
    try {
      return BankDetailsState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(BankDetailsState state) => state.toJson();
}
