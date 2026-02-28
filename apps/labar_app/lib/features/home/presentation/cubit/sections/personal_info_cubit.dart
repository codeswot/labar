import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:labar_app/core/utils/app_logger.dart';
import 'package:labar_app/features/home/domain/usecases/get_lgas_usecase.dart';
import 'package:labar_app/features/home/domain/usecases/get_states_usecase.dart';
import 'package:labar_app/features/home/presentation/cubit/form_inputs.dart';

part 'personal_info_state.dart';
part 'personal_info_cubit.freezed.dart';
part 'personal_info_cubit.g.dart';

@injectable
class PersonalInfoCubit extends HydratedCubit<PersonalInfoState> {
  final GetStatesUseCase _getStatesUseCase;
  final GetLgasUseCase _getLgasUseCase;

  PersonalInfoCubit(
    this._getStatesUseCase,
    this._getLgasUseCase,
  ) : super(const PersonalInfoState());

  void init({
    required String currentUserId,
    String? firstName,
    String? lastName,
    String? otherNames,
    String? gender,
    String? stateOfOrigin,
    String? lga,
    String? town,
    DateTime? dateOfBirth,
  }) {
    if (state.userId.isNotEmpty && state.userId != currentUserId) {
      emit(PersonalInfoState(userId: currentUserId));
    } else if (state.userId.isEmpty) {
      emit(state.copyWith(userId: currentUserId));
    }

    if (state.availableStates.isEmpty) {
      _loadStates();
    }

    emit(state.copyWith(
      firstName: firstName != null && firstName.isNotEmpty
          ? NameInput.dirty(firstName)
          : state.firstName,
      lastName: lastName != null && lastName.isNotEmpty
          ? NameInput.dirty(lastName)
          : state.lastName,
      otherNames: otherNames != null && otherNames.isNotEmpty
          ? OptionalTextInput.dirty(otherNames)
          : state.otherNames,
      gender: gender != null && gender.isNotEmpty
          ? RequiredTextInput.dirty(gender)
          : state.gender,
      stateOfOrigin: stateOfOrigin != null && stateOfOrigin.isNotEmpty
          ? RequiredTextInput.dirty(stateOfOrigin)
          : state.stateOfOrigin,
      lga: lga != null && lga.isNotEmpty
          ? RequiredTextInput.dirty(lga)
          : state.lga,
      town: town != null && town.isNotEmpty
          ? RequiredTextInput.dirty(town)
          : state.town,
      dateOfBirth: dateOfBirth ?? state.dateOfBirth,
    ));

    if (state.stateOfOrigin.value.isNotEmpty && state.currentLgas.isEmpty) {
      _loadLgas(state.stateOfOrigin.value);
    }
  }

  Future<void> _loadStates() async {
    try {
      final List<String> states = await _getStatesUseCase();
      AppLogger.info('Loaded states: $states');
      if (!isClosed) emit(state.copyWith(availableStates: states));
    } catch (e) {
      AppLogger.error('Error loading states data: $e');
    }
  }

  Future<void> _loadLgas(String stateName) async {
    if (stateName.isEmpty) {
      if (!isClosed) emit(state.copyWith(currentLgas: []));
      return;
    }
    try {
      final List<String> lgas = await _getLgasUseCase(stateName);
      if (!isClosed) emit(state.copyWith(currentLgas: lgas));
    } catch (e) {
      AppLogger.error('Error loading LGAs for $stateName: $e');
      if (!isClosed) emit(state.copyWith(currentLgas: []));
    }
  }

  void firstNameChanged(String value) {
    emit(state.copyWith(firstName: NameInput.dirty(value)));
  }

  void lastNameChanged(String value) {
    emit(state.copyWith(lastName: NameInput.dirty(value)));
  }

  void otherNamesChanged(String value) {
    emit(state.copyWith(otherNames: OptionalTextInput.dirty(value)));
  }

  void genderChanged(String value) {
    emit(state.copyWith(gender: RequiredTextInput.dirty(value)));
  }

  void stateOfOriginChanged(String value) {
    emit(state.copyWith(
      stateOfOrigin: RequiredTextInput.dirty(value),
      lga: const RequiredTextInput.pure(),
    ));
    _loadLgas(value);
  }

  void lgaChanged(String value) {
    emit(state.copyWith(lga: RequiredTextInput.dirty(value)));
  }

  void townChanged(String value) {
    emit(state.copyWith(town: RequiredTextInput.dirty(value)));
  }

  void dateOfBirthChanged(DateTime? value) {
    emit(state.copyWith(dateOfBirth: value));
  }

  @override
  PersonalInfoState? fromJson(Map<String, dynamic> json) {
    try {
      final loadedState = PersonalInfoState.fromJson(json);
      return loadedState;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PersonalInfoState state) => state.toJson();
}
