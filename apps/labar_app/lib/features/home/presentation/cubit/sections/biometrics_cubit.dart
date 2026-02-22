import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'biometrics_cubit.freezed.dart';
part 'biometrics_cubit.g.dart';

@freezed
class BiometricsState with _$BiometricsState {
  const factory BiometricsState({
    List<int>? signatureBytes,
    String? passportPath,
  }) = _BiometricsState;

  const BiometricsState._();

  factory BiometricsState.fromJson(Map<String, dynamic> json) =>
      _$BiometricsStateFromJson(json);

  bool get isValid =>
      (signatureBytes != null && signatureBytes!.isNotEmpty) &&
      (passportPath != null && passportPath!.isNotEmpty);
}

@injectable
class BiometricsCubit extends Cubit<BiometricsState> {
  BiometricsCubit() : super(const BiometricsState());

  void setSignature(List<int>? bytes) {
    emit(state.copyWith(signatureBytes: bytes));
  }

  void setPassport(String? path) {
    emit(state.copyWith(passportPath: path));
  }
}
