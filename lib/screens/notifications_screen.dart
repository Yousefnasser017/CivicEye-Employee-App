// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationsScreen({Key? key, this.notifications = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // سهم الرجوع على الشمال
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
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF0D47A1),
                          size: 24,
                          textDirection: TextDirection.ltr,
                        )
                    ),
                  ),
                ),
                // العنوان في الوسط
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.warning_rounded,
                          color: Colors.redAccent),
                    ),
                    title: Text(
                      notif['title'] ?? 'بلاغ جديد',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      notif['body'] ?? '',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: Text(
                      notif['time'] ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // يمكنك فتح تفاصيل البلاغ هنا
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(notif['title'] ?? ''),
                          content: Text(notif['body'] ?? ''),
                          actions: [
                            TextButton(
                              child: const Text('إغلاق'),
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
      backgroundColor: Colors.grey.shade50,
    );
  }
}
