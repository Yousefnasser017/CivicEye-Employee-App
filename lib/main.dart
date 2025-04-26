import 'package:civiceye/core/routing/app_roution.dart';
import 'package:civiceye/core/themes/app_theme.dart';
import 'package:civiceye/core/themes/cubit/theme_cubit.dart';
import 'package:civiceye/features/home/logic/home_cubit.dart';
import 'package:civiceye/features/reports/logic/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getString('last_page');
    return lastPage ?? '/';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ReportsCubit()),
        BlocProvider(create: (_) =>  HomeCubit()),
      
        

        
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          return FutureBuilder<String>(
            future: _getInitialRoute(),
            builder: (context, snapshot) {
              final initialRoute = snapshot.data ?? '/';
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Civic Eye',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeCubit.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
