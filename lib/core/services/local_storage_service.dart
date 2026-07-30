import 'package:hive_flutter/hive_flutter.dart';

/// LocalStorageService wraps Hive boxes to store cache data.
class LocalStorageService {
  static const String _defaultBoxName = 'banking_app_local_cache';
  late Box _box;

  /// Initializes Hive and opens the default storage box.
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_defaultBoxName);
  }

  /// Retrieve a value associated with the given [key].
  T? get<T>(String key) {
    return _box.get(key) as T?;
  }

  /// Store a value associated with the given [key].
  Future<void> put<T>(String key, T value) async {
    await _box.put(key, value);
  }

  /// Delete a value associated with the given [key].
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// Clears all keys and values in the local cache box.
  Future<void> clearAll() async {
    await _box.clear();
  }
}
