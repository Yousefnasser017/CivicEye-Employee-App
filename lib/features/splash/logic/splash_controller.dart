import 'package:shared_preferences/shared_preferences.dart';

class SplashController {
  Future<String?> checkToken() async {
    return await StorageService.getToken();
  }

  Future<void> delayNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}

class StorageService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwttoken');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwttoken', token);
  }
}