import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageHelper {
  static const _storage = FlutterSecureStorage();

  /// حفظ بيانات الموظف الأساسية
  static Future<void> saveEmployeeData(Map<String, String> data) async {
    for (var entry in data.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  /// قراءة بيانات الموظف
  static Future<Map<String, String>> readEmployeeData() async {
    final keys = [
      'employeeId',
      'fullName',
      'email',
      'department',
      'cityName',
      'governorateName',
      'username',
    ];
    final Map<String, String> data = {};
    for (var key in keys) {
      final value = await _storage.read(key: key);
      data[key] = value ?? '';
    }
    return data;
  }

  /// حفظ آخر صفحة وصل لها المستخدم
  static Future<void> saveLastPage(String route) async {
    await _storage.write(key: 'last_page', value: route);
  }

  /// قراءة آخر صفحة محفوظة
  static Future<String?> getLastPage() async {
    return await _storage.read(key: 'last_page');
  }

  /// حفظ حالة تسجيل الدخول (true / false)
  static Future<void> saveLoginState(bool isLoggedIn) async {
    await _storage.write(key: 'isLoggedIn', value: isLoggedIn.toString());
  }

  /// قراءة حالة تسجيل الدخول
  static Future<bool> getLoginState() async {
    final value = await _storage.read(key: 'isLoggedIn');
    return value == 'true';
  }

  /// حذف كل البيانات المحفوظة
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
