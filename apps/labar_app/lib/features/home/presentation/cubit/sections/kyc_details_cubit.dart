import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/features/home/domain/entities/enums.dart';
import 'package:labar_app/features/home/presentation/cubit/form_inputs.dart';

part 'kyc_details_state.dart';
part 'kyc_details_cubit.freezed.dart';
part 'kyc_details_cubit.g.dart';

@injectable
class KycDetailsCubit extends HydratedCubit<KycDetailsState> {
  KycDetailsCubit() : super(const KycDetailsState());

  void init({
    KycType? kycType,
    String? kycNumber,
  }) {
    emit(state.copyWith(
      kycType: kycType,
      kycNumber: kycNumber != null && kycNumber.isNotEmpty
          ? RequiredTextInput.dirty(kycNumber)
          : const RequiredTextInput.pure(),
    ));
  }

  void kycTypeChanged(KycType? value) {
    emit(state.copyWith(kycType: value));
  }

  void kycNumberChanged(String value) {
    emit(state.copyWith(kycNumber: RequiredTextInput.dirty(value)));
  }

  @override
  KycDetailsState? fromJson(Map<String, dynamic> json) {
    try {
      return KycDetailsState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(KycDetailsState state) => state.toJson();
}
