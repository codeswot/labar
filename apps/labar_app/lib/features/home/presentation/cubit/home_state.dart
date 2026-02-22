import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';

part 'home_state.freezed.dart';

enum HomeView { form, submitted }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeView.form) HomeView view,
    ApplicationEntity? application,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _HomeState;
}
