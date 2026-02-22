import 'package:labar_app/features/home/domain/entities/allocated_resource_entity.dart';

abstract class AllocatedResourceRepository {
  /// Stream of allocated resources for a specific application.
  Stream<List<AllocatedResourceEntity>> watchAllocatedResources(
      String applicationId);
}
