// ignore_for_file: depend_on_referenced_packages

import 'package:civiceye/core/config/app_config.dart';
import 'package:civiceye/core/config/websocket.dart';
import 'package:civiceye/core/routing/app_roution.dart';
import 'package:civiceye/core/themes/app_theme.dart';
import 'package:civiceye/cubits/home_cubit/home_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_detail_cubit.dart';
import 'package:civiceye/cubits/theme_cubit/theme_cubit.dart';
import 'package:civiceye/cubits/auth_cubit/auth_cubit.dart';
import 'package:civiceye/cubits/report_cubit/report_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

extension on FlutterSecureStorage {
  void setOptions(WebOptions webOptions) {}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          create: (_) {
            final service = StompWebSocketService();
            service.connect();
            return service;
          },
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
