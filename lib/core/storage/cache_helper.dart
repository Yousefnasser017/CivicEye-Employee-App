import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageHelper {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveEmployeeData(Map<String, String> data) async {
    for (var entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }
  static Future<void> saveLastPage(String route) async {
  await _storage.write(key: 'last_page', value: route);
}

static Future<String?> getLastPage() async {
  return await _storage.read(key: 'last_page');
}


  static Future<Map<String, String>> readEmployeeData() async {
    final keys = ['employeeId', 'fullName', 'department', 'city', 'gov', 'username'];
    final Map<String, String> data = {};
    for (var key in keys) {
      final value = await _storage.read(key: key);
      data[key] = value ?? '';
    }
    return data;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
