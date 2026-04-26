import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDbService {
  final Box _cacheBox = Hive.box('cache');

  // Generic method to save data
  Future<void> saveData(String key, List<dynamic> data) async {
    final jsonList = data.map((e) => e.toJson()).toList();
    await _cacheBox.put(key, jsonEncode(jsonList));
  }

  // Generic method to load data
  List<dynamic>? loadData(String key, Function(Map<String, dynamic>) fromJson) {
    final String? jsonString = _cacheBox.get(key);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((e) => fromJson(e)).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Handle Offline Queue
  Future<void> addToSyncQueue(String table, String action, Map<String, dynamic> data) async {
    List<dynamic> queue = getSyncQueue();
    // Action can be 'insert', 'update', 'delete'
    queue.add({
      'table': table,
      'action': action,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _cacheBox.put('sync_queue', jsonEncode(queue));
  }

  List<dynamic> getSyncQueue() {
    final String? jsonString = _cacheBox.get('sync_queue');
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> clearSyncQueue() async {
    await _cacheBox.delete('sync_queue');
  }

  Future<void> setSyncQueue(List<dynamic> queue) async {
    await _cacheBox.put('sync_queue', jsonEncode(queue));
  }
}
