import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsStorage {
  static const String _key = 'local_notifications_list';

  static Future<List<Map<String, String>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Map<String, String>.from(json.decode(e))).toList();
  }

  static Future<void> addNotification(Map<String, String> notification) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    final notifications =
        data.map((e) => Map<String, String>.from(json.decode(e))).toList();

    // منطق منع التكرار: إذا كان هناك إشعار بنفس reportId أو بنفس العنوان والنص
    final reportId = notification['reportId'];
    final title = notification['title'];
    final body = notification['body'];
    final isDuplicate = notifications.any((n) =>
        (reportId != null &&
            reportId.isNotEmpty &&
            n['reportId'] == reportId) ||
        (n['title'] == title && n['body'] == body));
    if (isDuplicate) return;

    data.insert(0, json.encode(notification));
    await prefs.setStringList(_key, data);
  }
  static Future<void> clearNotificationAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < data.length) {
      data.removeAt(index);
      await prefs.setStringList(_key, data);
    }
  }
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
