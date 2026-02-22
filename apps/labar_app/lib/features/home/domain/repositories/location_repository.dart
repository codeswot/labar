abstract class LocationRepository {
  Future<List<String>> getStates();
  Future<List<String>> getLgas(String state);
}
