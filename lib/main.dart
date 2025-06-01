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
  
  runApp( MyApp());
}

extension on FlutterSecureStorage {
  void setOptions(WebOptions webOptions) {}
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getString('last_page');
    return lastPage ?? '/'; // العودة إلى الصفحة الافتراضية إذا لم يتم تحديد أي صفحة
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(formKey: _formKey, emailController: _emailController, passwordController: _passwordController)),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ReportsCubit()),
        BlocProvider(create: (_) => ReportDetailCubit()),
        BlocProvider(create: (_) => ReportCubit())
       
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>( // تغيير هنا لمتابعة ThemeMode
        builder: (context, themeMode) { // هنا نتابع themeMode مباشرة من ThemeCubit
          return FutureBuilder<String>(
            future: _getInitialRoute(),
            builder: (context, snapshot) {
              final initialRoute = snapshot.data ?? '/';
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Civic Eye',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode, // هنا نستخدم themeMode مباشرة
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
    );
  }
}
