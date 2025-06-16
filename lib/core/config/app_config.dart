import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static late final String baseUrl;

  static void init() {
    if (kIsWeb) {
      baseUrl = 'http://localhost:9090/api/V1';
    } else if (Platform.isAndroid || Platform.isIOS) {
      // baseUrl = 'https://civiceye.onrender.com/api/V1'; 
          baseUrl = 'http://192.168.1.2:9090/api/V1'; 
    } else {
      baseUrl = 'http://localhost:9090/api/V1';
    }
  }
}
