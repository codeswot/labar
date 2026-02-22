import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract class LocationLocalDataSource {
  Future<List<String>> getStates();
  Future<List<String>> getLgas(String state);
}

@LazySingleton(as: LocationLocalDataSource)
class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<List<String>> getStates() async {
    try {
      final String response =
          await rootBundle.loadString('assets/locations/states.json');
      final List<dynamic> data = json.decode(response);
      return List<String>.from(data);
    } catch (e) {
      throw Exception('Failed to load states: $e');
    }
  }

  @override
  Future<List<String>> getLgas(String state) async {
    try {
      final String filename =
          state.toLowerCase().replaceAll(' ', '_').replaceAll('/', '_');
      final String response =
          await rootBundle.loadString('assets/locations/$filename.json');
      final List<dynamic> data = json.decode(response);
      return List<String>.from(data);
    } catch (e) {
      // Return empty list instead of throwing to be safe?
      // Or throw to let repo handle? The cubit was catching.
      // I'll throw and let upper layers decide.
      throw Exception('Failed to load LGAs for $state: $e');
    }
  }
}
