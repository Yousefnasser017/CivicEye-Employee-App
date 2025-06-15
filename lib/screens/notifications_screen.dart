// ignore_for_file: deprecated_member_use, unused_element, unnecessary_string_interpolations, unused_local_variable

import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/services/notifications_storage.dart';
import 'package:civiceye/core/themes/app_colors.dart';
import 'package:civiceye/core/services/notification_counter.dart';
import 'package:civiceye/screens/report_details.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, String>> notifications = [];
  bool loading = true;

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
    notifications = await NotificationsStorage.getNotifications();
    setState(() {
      loading = false;
    });
    NotificationCounter.notifier.value = notifications.length;
  }

  Future<void> _clearNotifications() async {
    await NotificationsStorage.clearNotifications();
    setState(() {
      notifications = [];
    });
    NotificationCounter.reset();
  }

  static Future<void> saveNotification(String title, String body) async {
    await NotificationsStorage.addNotification({
      'title': title,
      'body': body,
      'time': DateTime.now().toIso8601String(),
    });
  }
  Future<void> _removeNotificationAt(int index) async {
    await NotificationsStorage.clearNotificationAt(index);
    await _loadNotifications();
    NotificationCounter.notifier.value = notifications.length;
  }

  @override
  Widget build(BuildContext context) {
    Widget? connectionBanner;
    if (_wsStatus != null &&
        (!_wsStatus!.connected ||
            _wsStatus!.hasError ||
            _wsStatus!.reconnecting)) {
      Color bgColor;
      String msg;
      if (_wsStatus!.hasError) {
        bgColor = Colors.redAccent;
        msg = 'فشل الاتصال: ${_wsStatus!.errorMessage ?? ''}';
      } else if (_wsStatus!.reconnecting) {
        bgColor = Colors.orangeAccent;
        msg =
            'جاري إعادة الاتصال... (محاولة: ${_wsStatus!.reconnectAttempt ?? 0})';
      } else {
        bgColor = Colors.grey;
        msg = 'غير متصل بالخادم';
      }
      connectionBanner = Container(
        width: double.infinity,
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(_wsStatus!.hasError ? Icons.error : Icons.wifi_off,
                color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
                child: Text(msg,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
      );
    }

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
                      if (notifications.isEmpty) return;
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
                        await _clearNotifications();
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
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد إشعارات جديدة',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black38
                            : Colors.grey.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: borderColor),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: iconBg,
                      child: Icon(Icons.warning_rounded, color: iconColor),
                    ),
                    title: Text(
                      notif['title'] ?? 'بلاغ جديد',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'المدينة: ${notif['cityName'] ?? ''}\n${notif['since'] ?? ''}',
                      style: TextStyle(color: subtitleColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notif['time'] ?? '',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: 'حذف',
                          onPressed: () async {
                            await NotificationsStorage.clearNotificationAt(
                                index);
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: dialogBg,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text('تفاصيل البلاغ',
                                  style: TextStyle(color: dialogTextColor)),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('العنوان: ${notif['title'] ?? ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: dialogTextColor)),
                              const SizedBox(height: 6),
                              Text('المدينة: ${notif['cityName'] ?? ''}',
                                  style: TextStyle(color: dialogTextColor)),
                              const SizedBox(height: 6),
                              Text('${notif['since'] ?? ''}',
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Text('عرض تفاصيل البلاغ'),
                              onPressed: () {
                                Navigator.pop(context); // أغلق الـ Dialog
                                if (notif['reportId'] != null &&
                                    notif['reportId']!.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReportDetailsScreen(
                                        report:
                                            null, // إذا كان متوفر مرر ReportModel كامل، وإلا مرر فقط reportId
                                        reportId: int.tryParse(
                                                notif['reportId'] ?? '') ??
                                            0,
                                        employeeId:
                                            '', // إذا متوفر مرر employeeId
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            TextButton(
                              child: Text('إغلاق',
                                  style: TextStyle(color: dialogTextColor)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMainContent(
      BuildContext context,
      bool isDarkMode,
      Color cardColor,
      Color borderColor,
      Color? subtitleColor,
      Color dialogBg,
      Color dialogTextColor,
      Color? iconBg,
      Color iconColor) {
    // قائمة الإشعارات مع تأثير وميض عند وصول إشعار جديد
    Widget notificationList = notifications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('لا توجد إشعارات جديدة',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final isNew = _newNotificationIndex == index;
              Widget notifCard = Card(
                color: cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: borderColor),
                ),
                child: ListTile(
                  title: Text(notif['title'] ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black)),
                  subtitle: Text(notif['body'] ?? '',
                      style: TextStyle(color: subtitleColor)),
                  trailing: Icon(Icons.notifications, color: iconColor),
                  onTap: () {
                    final reportId = notif['reportId'];
                    if (reportId != null && reportId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailsScreen(
                            report: null,
                            reportId: int.tryParse(reportId) ?? 0,
                            employeeId: '', // إذا توفر مرر employeeId
                          ),
                        ),
                      );
                    } else {
                      // إذا لم يوجد reportId يمكن عرض رسالة أو تفاصيل نصية فقط
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تفاصيل الإشعار'),
                          content: Text(notif['body'] ?? ''),
                          actions: [
                            TextButton(
                              child: const Text('إغلاق'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              );
              if (isNew) {
                notifCard = AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: notifCard,
                );
              }
              return notifCard;
            },
          );

    return notificationList;
  }
}
