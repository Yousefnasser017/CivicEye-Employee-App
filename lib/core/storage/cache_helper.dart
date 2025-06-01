import 'package:civiceye/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LocalStorageHelper {
  static FlutterSecureStorage _storage = const FlutterSecureStorage();

  @visibleForTesting
  static void overrideStorage(FlutterSecureStorage newStorage) {
    _storage = newStorage;
  }


  /// Save full employee model
  static Future<void> saveEmployee(EmployeeModel employee) async {
    await Future.wait([
      _storage.write(key: 'employeeId', value: employee.id.toString()),
      _storage.write(key: 'fullName', value: employee.fullName),
      _storage.write(key: 'email', value: employee.email),
      _storage.write(key: 'department', value: employee.department),
      _storage.write(key: 'cityName', value: employee.cityName),
      _storage.write(key: 'governorateName', value: employee.governorateName),
      _storage.write(key: 'username', value: employee.nationalId),
    ]);
  }

  /// Get full employee model
  static Future<EmployeeModel?> getEmployee() async {
    final idStr = await _storage.read(key: 'employeeId');
    if (idStr == null) return null;

    return EmployeeModel(
      id: int.tryParse(idStr) ?? 0,
      nationalId: await _storage.read(key: 'username') ?? '',
      firstName: '', // يمكن إضافتها لاحقًا حسب الحاجة
      lastName: '',
      fullName: await _storage.read(key: 'fullName') ?? '',
      email: await _storage.read(key: 'email') ?? '',
      department: await _storage.read(key: 'department') ?? '',
      cityName: await _storage.read(key: 'cityName') ?? '',
      governorateName: await _storage.read(key: 'governorateName') ?? '',
      level: [], // تخزين واسترجاع level ممكن يتم لاحقًا إذا احتجته
    );
  }

  static Future<void> saveLastPage(String route) async {
    await _storage.write(key: 'last_page', value: route);
  }

  static Future<String?> getLastPage() async {
    return _storage.read(key: 'last_page');
  }

  static Future<void> saveLoginState(bool isLoggedIn) async {
    await _storage.write(key: 'isLoggedIn', value: isLoggedIn.toString());
  }

  static Future<bool> getLoginState() async {
    final value = await _storage.read(key: 'isLoggedIn');
    return value == 'true';
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
