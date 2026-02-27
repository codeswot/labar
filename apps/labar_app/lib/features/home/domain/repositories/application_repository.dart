import 'package:labar_app/features/home/domain/entities/agent_entity.dart';
import 'package:labar_app/features/home/domain/entities/application_entity.dart';

abstract class ApplicationRepository {
  /// Stream of the user's application.
  /// Returns null if no application exists yet.
  Stream<ApplicationEntity?> getApplicationStream();

  /// Saves the current state of the application (draft or final).
  Future<void> saveApplication(ApplicationEntity application);

  /// Submits the application (changes status to submitted).
  Future<void> submitApplication(ApplicationEntity application);

  /// Uploads a file and returns the path.
  Future<String> uploadFile(String path, String name);

  /// Fetches the current application once (useful for refreshing signed URLs).
  Future<ApplicationEntity?> getApplication();

  /// Fetches the list of all agents.
  Future<List<AgentEntity>> getAgents();
}
