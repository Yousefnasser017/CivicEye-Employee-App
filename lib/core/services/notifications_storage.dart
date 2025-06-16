import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsStorage {
  static const String _key = 'local_notifications_list';
  static const int MAX_NOTIFICATIONS = 100;
  static const Duration NOTIFICATION_EXPIRY = Duration(days: 30);

  static Future<List<Map<String, String>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(_key) ?? [];
      return data.map((e) => Map<String, String>.from(json.decode(e))).toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  static Future<void> addNotification(Map<String, String> notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(_key) ?? [];
      final notifications =
          data.map((e) => Map<String, String>.from(json.decode(e))).toList();

      // التحقق من التكرار
      final reportId = notification['reportId'];
      final title = notification['title'];
      final body = notification['body'];
      final isDuplicate = notifications.any((n) =>
          (reportId != null &&
              reportId.isNotEmpty &&
              n['reportId'] == reportId) ||
          (n['title'] == title && n['body'] == body));

      if (isDuplicate) return;

      // إضافة الإشعار الجديد
      notifications.insert(0, notification);

      // تنظيف الإشعارات القديمة
      _cleanOldNotifications(notifications);

      // التحقق من الحد الأقصى
      if (notifications.length > MAX_NOTIFICATIONS) {
        notifications.removeRange(MAX_NOTIFICATIONS, notifications.length);
      }

      // حفظ الإشعارات
      await prefs.setStringList(
          _key, notifications.map((e) => json.encode(e)).toList());
    } catch (e) {
      print('Error adding notification: $e');
      // يمكن إضافة منطق إضافي هنا
    }
  }

  static void _cleanOldNotifications(List<Map<String, String>> notifications) {
    final expiryDate = DateTime.now().subtract(NOTIFICATION_EXPIRY);
    notifications.removeWhere((notification) {
      final time = DateTime.tryParse(notification['time'] ?? '');
      return time != null && time.isBefore(expiryDate);
    });
  }

  static Future<void> clearNotificationAt(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(_key) ?? [];
      if (index >= 0 && index < data.length) {
        data.removeAt(index);
        await prefs.setStringList(_key, data);
      }
    } catch (e) {
      print('Error clearing notification: $e');
    }
  }

  static Future<void> clearNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      print('Error clearing all notifications: $e');
    }
  }
}
