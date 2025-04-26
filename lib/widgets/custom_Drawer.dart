import 'package:civiceye/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:civiceye/core/themes/cubit/theme_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  const CustomDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo-white.png', width: 100, height: 100),
                  const SizedBox(height: 10),
                  Text('أهلاً، $username',
                      style: const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الرئيسية'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('البلاغات'),
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('الملف الشخصي'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('حول التطبيق'),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            SwitchListTile(
              title: const Text('الوضع الداكن'),
              secondary: const Icon(Icons.dark_mode),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child:ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('تسجيل الخروج'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تأكيد تسجيل الخروج'),
                        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                        actions: [
                          TextButton(
                            child: const Text('إلغاء'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('تأكيد الخروج'),
                            onPressed: () async {
                              Navigator.of(context).pop(); // إغلاق الـ Dialog أولاً

                              await context.read<LoginCubit>().logout(context);

                              Fluttertoast.showToast(
                                msg: 'تم تسجيل الخروج بنجاح',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}
