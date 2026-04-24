import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageServiceProvider = Provider((ref) => LocalStorageService());

class LocalStorageService {
  final _cacheBox = Hive.box('cache');
  final _settingsBox = Hive.box('settings');

  void cacheData(String key, dynamic data) {
    _cacheBox.put(key, data);
  }

  dynamic getCachedData(String key) {
    return _cacheBox.get(key);
  }

  void saveSetting(String key, dynamic value) {
    _settingsBox.put(key, value);
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  bool hasCache(String key) {
    return _cacheBox.containsKey(key);
  }
}
