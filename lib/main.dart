// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:civiceye/core/config/app_config.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/routing/app_roution.dart';
import 'package:civiceye/core/services/foreground_service.dart';
import 'package:civiceye/core/services/notification_helper.dart';
import 'package:civiceye/core/services/report_notification_handler.dart';
import 'package:civiceye/core/themes/app_theme.dart';
import 'package:civiceye/cubits/home_cubit/home_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/theme_cubit/theme_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:civiceye/models/report_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.init();
  // إشعار تجريبي للتأكد من عمل الإشعارات
  await NotificationHelper.initEmployee();
 

  if (kIsWeb) {
    const FlutterSecureStorage().setOptions(
      const WebOptions(
        dbName: 'my_secure_storage',
        publicKey: 'my_public_key',
      ),
    );
  }
  ApiConfig.init();
  runApp(const MyApp());
}

void startCallback() {
  FlutterForegroundTask.setTaskHandler(ReportBackgroundTaskHandler());
}

extension on FlutterSecureStorage {
  void setOptions(WebOptions webOptions) {}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final StompWebSocketService _webSocketService = StompWebSocketService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  StreamSubscription<String>? _wsSubscription;
  
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startWebSocket();
  }

  void _startWebSocket() {
    
    _webSocketService.connect();
    _wsSubscription?.cancel();
    _wsSubscription = _webSocketService.reportStream.listen((msg) {
      print('Main: تم استقبال بلاغ جديد من WebSocket: $msg');
      NotificationHelper.showNotification('بلاغ جديد', msg);
      try {
        final decoded = jsonDecode(msg);
        if (decoded is Map<String, dynamic>) {
          final report = ReportModel.fromJson(decoded);
          // مرر البلاغ الجديد مباشرة للـ ReportsCubit
          final cubit = BlocProvider.of<ReportsCubit>(
              navigatorKey.currentContext ?? context,
              listen: false);
          cubit.addReport(report);
        }
      } catch (e) {
        print('خطأ في تحويل البلاغ الجديد إلى ReportModel: $e');
      }
      // يمكنك هنا تحديث الواجهة أيضاً
    });
  }

  void _stopWebSocket() {
    _wsSubscription?.cancel();
    _webSocketService.dispose();
    _wsSubscription = ReportNotificationHandler.listenToWebSocket(
        _webSocketService.reportStream);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // التطبيق دخل الخلفية
      _stopWebSocket();
      FlutterForegroundTask.startService(
        notificationTitle: 'CivicEye',
        notificationText: 'يتم الاستماع للبلاغات الجديدة...',
        callback: startCallback,
      );
    } else if (state == AppLifecycleState.resumed) {
      // التطبيق عاد للواجهة
      FlutterForegroundTask.stopService();
       if (!_webSocketService.isConnected) {
        _webSocketService.connect();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopWebSocket();
    super.dispose();
  }

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getString('last_page');
    return lastPage ?? '/';
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StompWebSocketService>(
          create: (_) => StompWebSocketService(),
          dispose: (_, service) => service.dispose(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoginCubit(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => ReportsCubit()),
          BlocProvider(
            create: (context) => ReportDetailCubit(
              socketService: context.read<StompWebSocketService>(),
              reportsCubit: context.read<ReportsCubit>(),
            ),
          ),
          BlocProvider(create: (_) => ReportCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return FutureBuilder<String>(
              future: _getInitialRoute(),
              builder: (context, snapshot) {
                final initialRoute = snapshot.data ?? '/';
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Civic Eye',
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  initialRoute: initialRoute,
                  onGenerateRoute: AppRouter.generateRoute,
                  builder: (context, child) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: child!,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
