import 'package:flutter/material.dart';

class NotificationCounter {
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static Future<void> updateCount(Future<int> Function() getCount) async {
    notifier.value = await getCount();
  }

  static void reset() {
    notifier.value = 0;
  }
}
