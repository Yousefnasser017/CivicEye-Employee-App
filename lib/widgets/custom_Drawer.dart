import 'package:civiceye/core/themes/cubit/theme_cubit.dart';
import 'package:civiceye/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomDrawer extends StatelessWidget {
  final String username;

  const CustomDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  'أهلاً، $username',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
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
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          SwitchListTile(
              title: const Text('الوضع الداكن'),
              secondary: const Icon(Icons.dark_mode),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
            ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج'),
          onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(' تسجيل الخروج'),
                  content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      child: const Text('إلغاء'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('تسجيل الخروج'),
                      onPressed: () async {
                        final storage = const FlutterSecureStorage();
                        await storage.deleteAll();
                        Navigator.of(context).pop(); // إغلاق الـ Dialog
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
