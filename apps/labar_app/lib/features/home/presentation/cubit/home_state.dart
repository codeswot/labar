import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';
import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';

part 'home_state.freezed.dart';

enum HomeView { form, submitted }

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeView.form) HomeView view,
    ApplicationEntity? application,
    @Default([]) List<AllocatedResourceEntity> allocatedResources,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _HomeState;
}
