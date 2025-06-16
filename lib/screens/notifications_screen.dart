// ignore_for_file: deprecated_member_use, unused_element, unnecessary_string_interpolations, unused_local_variable, unused_field
import 'dart:async';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/services/notifications_storage.dart';
import 'package:civiceye/core/services/notification_counter.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, String>> _notifications = [];

  // متغير لحالة الاتصال
  ConnectionStatus? _wsStatus;
  StreamSubscription? _wsStatusSubscription;

  // فهرس آخر إشعار جديد
  int? _newNotificationIndex;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    // تصفير عداد الإشعارات عند فتح الصفحة
    NotificationCounter.reset();
    // الاستماع لحالة الاتصال
    _wsStatusSubscription =
        StompWebSocketService().connectionStatusStream.listen((status) {
      setState(() {
        _wsStatus = status;
      });
      // إخفاء الرسالة تلقائياً عند الاتصال
      if (status.connected) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _wsStatus != null && _wsStatus!.connected == true) {
            setState(() {
              _wsStatus = null;
            });
          }
        });
      }
    });
    StompWebSocketService().reportStream.listen((message) async {
      await saveNotification('بلاغ جديد', message);
      await _loadNotifications();
      setState(() {
        _newNotificationIndex = 0; // أحدث إشعار دائماً في أول القائمة
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _newNotificationIndex = null;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _wsStatusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final notifications = await NotificationsStorage.getNotifications();

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });

      // تحديث عداد الإشعارات
      NotificationCounter.updateCount(() async => notifications.length);
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء تحميل الإشعارات';
        _isLoading = false;
      });
    }
  }

  Future<void> _clearNotification(int index) async {
    try {
      await NotificationsStorage.clearNotificationAt(index);
      await _loadNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الإشعار بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حذف الإشعار'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      await NotificationsStorage.clearNotifications();
      await _loadNotifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف جميع الإشعارات بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حذف الإشعارات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> saveNotification(String title, String body) async {
    await NotificationsStorage.addNotification({
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF23232B) : Colors.white;
    final borderColor =
        isDarkMode ? Colors.white10 : AppColors.primary.withOpacity(0.2);
    final subtitleColor = isDarkMode ? Colors.grey[300] : Colors.black54;
    final dialogBg = isDarkMode ? const Color(0xFF23232B) : Colors.white;
    final dialogTextColor = isDarkMode ? Colors.white : Colors.black;
    final iconBg =
        isDarkMode ? Colors.white12 : AppColors.primary.withOpacity(0.1);
    final iconColor = isDarkMode ? AppColors.primary : Colors.redAccent;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF181820) : Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.92),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(22)),
          ),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 24,
                          textDirection: TextDirection.ltr,
                        )),
                  ),
                ),
                const Center(
                  child: Text(
                    'الإشعارات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      if (_notifications.isEmpty) return;
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('تأكيد الحذف',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          content: const Text(
                              'هل أنت متأكد أنك تريد حذف جميع الإشعارات؟',
                              style: TextStyle(fontSize: 16)),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary),
                              child: const Text('إلغاء'),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Text('حذف'),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await _clearAllNotifications();
                      }
                    },
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: AppColors.primary,
                          size: 24,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _error != null
              ? ErrorView(
                  message: _error!,
                  onRetry: _loadNotifications,
                )
              : _notifications.isEmpty
                  ? const EmptyState(
                      message: 'لا توجد إشعارات جديدة',
                      icon: Icons.notifications_none,
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return NotificationItem(
                            title: notification['title'] ?? '',
                            body: notification['body'] ?? '',
                            time: notification['time'] ?? '',
                            onDelete: () => _clearNotification(index),
                          );
                        },
                      ),
                    ),
    );
  }
}
