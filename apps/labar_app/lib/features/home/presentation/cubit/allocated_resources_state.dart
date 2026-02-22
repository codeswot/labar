part of 'allocated_resources_cubit.dart';

@freezed
class AllocatedResourcesState with _$AllocatedResourcesState {
  const factory AllocatedResourcesState.initial() = _Initial;
  const factory AllocatedResourcesState.loading() = _Loading;
  const factory AllocatedResourcesState.loaded(
      List<AllocatedResourceEntity> resources) = _Loaded;
  const factory AllocatedResourcesState.error(String message) = _Error;
}
