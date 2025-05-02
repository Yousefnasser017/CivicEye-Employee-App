import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageHelper {
 static FlutterSecureStorage _storage = const FlutterSecureStorage();

@visibleForTesting
static void overrideStorage(FlutterSecureStorage newStorage) {
  _storage = newStorage;
}

  static const _employeeKeys = [
    'employeeId',
    'fullName',
    'email',
    'department',
    'cityName',
    'governorateName',
    'username',
  ];

  /// Save basic employee data
  static Future<void> saveEmployeeData(Map<String, String> data) async {
    await Future.wait(
      data.entries.map((e) => _storage.write(key: e.key, value: e.value)),
    );
  }

  /// Read saved employee data
  static Future<Map<String, String>> readEmployeeData() async {
    final Map<String, String> data = {};
    for (final key in _employeeKeys) {
      data[key] = await _storage.read(key: key) ?? '';
    }
    return data;
  }

  /// Save last visited route
  static Future<void> saveLastPage(String route) async {
    await _storage.write(key: 'last_page', value: route);
  }

  /// Get last visited route
  static Future<String?> getLastPage() async {
    return _storage.read(key: 'last_page');
  }

  /// Save login state (true / false)
  static Future<void> saveLoginState(bool isLoggedIn) async {
    await _storage.write(key: 'isLoggedIn', value: isLoggedIn.toString());
  }

  /// Get login state
  static Future<bool> getLoginState() async {
    final value = await _storage.read(key: 'isLoggedIn');
    return value == 'true';
  }

  /// Clear all saved data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
